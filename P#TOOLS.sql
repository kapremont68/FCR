CREATE OR REPLACE PACKAGE P#TOOLS
  AS
  
  PROCEDURE FILL_ACCOUNTS_ADRESES;

  FUNCTION GET_ACCOUNT_BY_ADRES(P_ADRES IN VARCHAR2)
    RETURN SYS_REFCURSOR;

  FUNCTION GET_PERSON_NAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_SNAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_1NAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_2NAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_TIP_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  PROCEDURE ADD_NEW_ERC_ACCOUNTS;

  PROCEDURE ADD_NEW_ERC_ACCOUNTS_BY_ID;


-- добавл€ем внешний счет (равный внутреннему от той же даты) дл€ аккаунтов у которых их нет
  PROCEDURE ADD_NEW_FCR_ACCOUNTS;
  
-- возвращает площадь помещени€ по номеру счета на дату  
  FUNCTION get#acc_area(a#acc_id NUMBER, a#date DATE DEFAULT sysdate) RETURN NUMBER;

-- возвращает адрес по account_id  
  FUNCTION get#acc_addr(a#acc_id NUMBER) RETURN VARCHAR2;

  
-- возвращает максимальную свободную дату дл€ добавлени€ – ÷ дл€ заданного счета
  FUNCTION GET_NEW_RKC_DATE(p_ACC_ID NUMBER, p_DATE DATE) return DATE;

-- возвращает MN закрыти€ счета или 1000 если открыт
  FUNCTION get#end_account_mn(a#acc_id NUMBER) RETURN NUMBER;

-- возвращает дл€ задонного acc_id количество записей из T#PAY_SOURCE с кодом – ÷ 88
  FUNCTION get#count_88(a#acc_id NUMBER) RETURN NUMBER;

-- возвращает account_id дл€ номера счета
  FUNCTION get#acc_id#by#acc_num(a#acc_num VARCHAR2) RETURN NUMBER;

-- возвращает внутренний номер счета по account_id
  FUNCTION get#acc_num#by#acc_id(a#acc_id NUMBER) RETURN VARCHAR2;

-- перенос всех платежей со счета на счет (в параметрах указывать внутренние счета)  
  PROCEDURE transfer#all_pays(from_acc_num VARCHAR2, to_acc_num VARCHAR2);    

-- добавл€ет и делает текущей площадь дл€ помещени€
  PROCEDURE set_rooms_area(p_ROOMS_ID NUMBER, p_NEW_AREA NUMBER);


-- открыт дом с заданным ACCOUNT_ID или нет
  FUNCTION house_is_open(a#acc_id NUMBER) RETURN VARCHAR2;

-- закрыт ли счет в день открыти€
  FUNCTION account_is_open_error(a#acc_id NUMBER) RETURN VARCHAR2;


-- тип баковского счета (котел, спец) по id дома
  FUNCTION ACC_TYPE_BY_HOUSE_ID(a#house_id NUMBER) RETURN VARCHAR2;


-- удал€ет дл€ указанного счета все записи из T#MASS_PAY, T#OP, T#OP_VD
    PROCEDURE DEL#MASS_PAY_FOR_ACC(a#acc_id NUMBER);    


    PROCEDURE FILL_CHARGE_PAY_J_TABLES(p_PERSON_ID INTEGER);

END P#TOOLS;
/


CREATE OR REPLACE PACKAGE BODY P#TOOLS
  AS

  PROCEDURE FILL_ACCOUNTS_ADRESES
    AS

    BEGIN
      DELETE FROM FCR.TT#ACCOUNTS_ADRESES;
      INSERT INTO FCR.TT#ACCOUNTS_ADRESES
        SELECT C#ROOMS_ID,
               C#NUM,
               v#ACCOUNT.C#DATE,
               C#END_DATE,
               fcr.p#utils.get#rooms_addr(C#ROOMS_ID),
               C#OUT_NUM
          FROM v#account,
               T#ACCOUNT_OP
          WHERE v#ACCOUNT.C#ID = T#ACCOUNT_OP.C#ACCOUNT_ID (+);
      COMMIT;
    END FILL_ACCOUNTS_ADRESES;

  FUNCTION GET_ACCOUNT_BY_ADRES(P_ADRES IN VARCHAR2)
    RETURN SYS_REFCURSOR
    AS
      cur SYS_REFCURSOR;
    BEGIN
      OPEN cur FOR
      SELECT *
        FROM TT#ACCOUNTS_ADRESES
        WHERE ADRES LIKE P_ADRES;
      RETURN cur;
    END GET_ACCOUNT_BY_ADRES;

  FUNCTION GET_PERSON_NAME_BY_ID(P_PERSON_ID IN NUMBER)
    RETURN VARCHAR2
    AS
      OUT_PERSON_NAME VARCHAR2(100);
    BEGIN
      WITH TMP#PERSON AS (SELECT TRIM(C#NAME) || ' (»ЌЌ: ' || TRIM(C#INN_NUM) || ')' PERSON_NAME
            FROM T#PERSON_J
            WHERE C#PERSON_ID = P_PERSON_ID
            UNION
          SELECT TRIM(C#F_NAME) || ' ' || TRIM(C#I_NAME) || ' ' || TRIM(C#O_NAME) PERSON_NAME
            FROM T#PERSON_P
            WHERE C#PERSON_ID = P_PERSON_ID)
      SELECT PERSON_NAME
        INTO OUT_PERSON_NAME
        FROM TMP#PERSON;
      RETURN OUT_PERSON_NAME;
    EXCEPTION
      WHEN OTHERS THEN RETURN NULL;
    END GET_PERSON_NAME_BY_ID;


  FUNCTION GET_PERSON_TIP_BY_ID(P_PERSON_ID IN NUMBER)
    RETURN VARCHAR2
    AS
      OUT_PERSON_TIP VARCHAR2(100);
    BEGIN
      WITH TMP#PERSON AS (SELECT C#TIP_UL PERSON_TIP
            FROM T#PERSON_J
            WHERE C#PERSON_ID = P_PERSON_ID
            UNION
          SELECT 'PER' PERSON_TIP
            FROM T#PERSON_P
            WHERE C#PERSON_ID = P_PERSON_ID)
      SELECT PERSON_TIP
        INTO OUT_PERSON_TIP
        FROM TMP#PERSON;
      RETURN OUT_PERSON_TIP;
    EXCEPTION
      WHEN OTHERS THEN RETURN NULL;
    END GET_PERSON_TIP_BY_ID;



  FUNCTION GET_PERSON_SNAME_BY_ID(P_PERSON_ID IN NUMBER)
    RETURN VARCHAR2
    AS
      OUT_PERSON_NAME VARCHAR2(100);
    BEGIN
      WITH TMP#PERSON AS (SELECT C#NAME || ' (»ЌЌ: ' || C#INN_NUM || ')' PERSON_NAME
            FROM T#PERSON_J
            WHERE C#PERSON_ID = P_PERSON_ID
            UNION
          SELECT C#F_NAME PERSON_NAME
            FROM T#PERSON_P
            WHERE C#PERSON_ID = P_PERSON_ID)
      SELECT PERSON_NAME
        INTO OUT_PERSON_NAME
        FROM TMP#PERSON;
      RETURN NVL(OUT_PERSON_NAME, ' ');
    EXCEPTION
      WHEN OTHERS THEN RETURN ' ';
    END GET_PERSON_SNAME_BY_ID;

  FUNCTION GET_PERSON_1NAME_BY_ID(P_PERSON_ID IN NUMBER)
    RETURN VARCHAR2
    AS
      OUT_PERSON_NAME VARCHAR2(100);
    BEGIN
      WITH TMP#PERSON AS (SELECT C#I_NAME PERSON_NAME
            FROM T#PERSON_P
            WHERE C#PERSON_ID = P_PERSON_ID)
      SELECT PERSON_NAME
        INTO OUT_PERSON_NAME
        FROM TMP#PERSON;
      RETURN NVL(OUT_PERSON_NAME, ' ');
    EXCEPTION
      WHEN OTHERS THEN RETURN ' ';
    END GET_PERSON_1NAME_BY_ID;

  FUNCTION GET_PERSON_2NAME_BY_ID(P_PERSON_ID IN NUMBER)
    RETURN VARCHAR2
    AS
      OUT_PERSON_NAME VARCHAR2(100);
    BEGIN
      WITH TMP#PERSON AS (SELECT C#O_NAME PERSON_NAME
            FROM T#PERSON_P
            WHERE C#PERSON_ID = P_PERSON_ID)
      SELECT PERSON_NAME
        INTO OUT_PERSON_NAME
        FROM TMP#PERSON;
      RETURN NVL(OUT_PERSON_NAME, ' ');
    EXCEPTION
      WHEN OTHERS THEN RETURN ' ';
    END GET_PERSON_2NAME_BY_ID;
    
    
    FUNCTION GET_NEW_RKC_DATE(p_ACC_ID NUMBER, p_DATE DATE) return DATE as
        ND DATE;
        BEG_DATE DATE;
    begin
        BEG_DATE := TO_DATE('01.05.2014','dd.mm.yyyy');
        select
            max(DD)
        into ND    
        from
            (SELECT
                    BEG_DATE+level-1 DD
                FROM
                    dual
                CONNECT BY
                    level <= p_DATE-BEG_DATE+1
            )
        where
            DD not in (select C#DATE from T#ACCOUNT_OP where T#ACCOUNT_OP.C#ACCOUNT_ID = p_ACC_ID)
        ;    
        return ND;
    end GET_NEW_RKC_DATE;
    


  PROCEDURE ADD_NEW_ERC_ACCOUNTS_BY_ID AS
  BEGIN
    FOR new_acc_rec IN (
            with
                ups as (
                    select distinct
                        REPLACE(REPLACE(REPLACE(REPLACE(CITY, ' –ј—Ќ≈Ќ№ јя, де', ' –ј—Ќ≈Ќ№ јя'),'“јћЅќ¬, город','“јћЅќ¬'),'—троитель, посе','—“–ќ»“≈Ћ№'),'Ѕокино, село','Ѕќ »Ќќ')  CITY
                        ,UPPER(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UL_NAME,'бульвар',''),'мкр.',''),'шоссе',''),'пер.',''),'пр.',''),'ул.',''),'пл.',''),'им.',''))) UL_NAME
                        ,UPPER(TRIM(DOM))||CASE WHEN TRIM(DOP_NAME) <> '--' THEN '-'|| TRIM(REPLACE(DOP_NAME,'корпус','')) ELSE '' END DOM
                        ,LPAD(UPPER(TRIM(KV)),15,'0') KV
                        ,PL_OB
                        ,NEW_ACCOUNT_NUM
                        ,PER_BEG
                    FROM
                        V#ERC_NEW_ACCOUNTS V
                )
                ,erc as (
                    select
                        CITY||','||UL_NAME||','||DOM DOM
                        ,PL_OB
                        ,KV
                        ,NEW_ACCOUNT_NUM
                        ,PER_BEG
                    from
                        ups
                )
                ,rooms as (
                    select 
                        T#ROOMS.C#ID ROOMS_ID
                        ,T#ACCOUNT.C#ID ACCOUNT_ID            
                        ,T#ROOMS.C#FLAT_NUM FLAT_NUM
                        ,T#ROOMS.C#HOUSE_ID HOUSE_ID
                        ,C#AREA_VAl AREA
                    from
                        T#ROOMS
                        join T#ROOMS_SPEC on (T#ROOMS_SPEC.C#ROOMS_ID = T#ROOMS.C#ID)
                        join T#ROOMS_SPEC_VD on (T#ROOMS_SPEC_VD.C#ID = T#ROOMS_SPEC.C#ID)
                        join T#ACCOUNT on (T#ACCOUNT.C#ROOMS_ID = T#ROOMS.C#ID)
                )
                ,kvs as (
                    select
                        R.HOUSE_ID
                        ,ADDR2 DOM
                        ,R.ROOMS_ID
                        ,LPAD(UPPER(TRIM(R.FLAT_NUM)),15,'0') KV
                        ,R.AREA    
                        ,ACCOUNT_ID
                    from
                        MV_HOUSES_ADRESES M
                        join rooms R on (M.HOUSE_ID = R.HOUSE_ID)
                )
                ,eq as (
                    select
                        *
                    from
                        erc
                        join kvs on (kvs.DOM like '%'||erc.DOM and erc.KV = kvs.KV and kvs.AREA = erc.PL_OB)
                )
            select distinct
                ACCOUNT_ID,
                TO_DATE(PER_BEG||'01','yyyymmdd') NEW_DATE,
                NEW_ACCOUNT_NUM
            from
                eq
          )
    LOOP
        BEGIN
            P#FCR.ins#account_op (  
                A#ACCOUNT_ID => new_acc_rec.ACCOUNT_ID,
                A#DATE => GET_NEW_RKC_DATE(new_acc_rec.ACCOUNT_ID, new_acc_rec.NEW_DATE),
                A#OUT_PROC_ID => 1,
                A#OUT_NUM => new_acc_rec.NEW_ACCOUNT_NUM,
                A#NOTE => 'ADD_NEW_ERC_ACCOUNTS_BY_ID: '||sysdate); 
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;        
    END LOOP;
   END ADD_NEW_ERC_ACCOUNTS_BY_ID;



  PROCEDURE ADD_NEW_ERC_ACCOUNTS AS
  BEGIN
    FOR new_acc_rec IN (
        select distinct
          C#ACCOUNT_ID ACCOUNT_ID,
          TO_DATE(PER_BEG||'01','yyyymmdd') NEW_DATE,
          NEW_ACCOUNT_NUM
        from
          V#ERC_NEW_ACCOUNTS
          join T#ACCOUNT_OP  on (OLD_ACCOUNT_NUM = C#OUT_NUM)
        where
            C#OUT_NUM in (
                select
                    C#OUT_NUM
                from
                    T#ACCOUNT_OP
                GROUP BY
                    C#OUT_NUM
                HAVING
                    count(*) = 1
            )
          )

    LOOP
        BEGIN
            P#FCR.ins#account_op (  
                A#ACCOUNT_ID => new_acc_rec.ACCOUNT_ID,
                A#DATE => GET_NEW_RKC_DATE(new_acc_rec.ACCOUNT_ID, new_acc_rec.NEW_DATE),
                A#OUT_PROC_ID => 1,
                A#OUT_NUM => new_acc_rec.NEW_ACCOUNT_NUM,
                A#NOTE => 'ADD_NEW_ERC_ACCOUNTS: '||sysdate); 
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;        
    END LOOP;
   END ADD_NEW_ERC_ACCOUNTS;



  PROCEDURE ADD_NEW_FCR_ACCOUNTS AS
  BEGIN
    FOR new_acc_rec IN (
        select distinct
          A.C#ID ACCOUNT_ID,
          A.C#DATE NEW_DATE,
          C#NUM NEW_ACCOUNT_NUM
        from
          T#ACCOUNT A
          left join t#account_op O on (A.C#ID = O.C#ACCOUNT_ID)
        WHERE
            O.C#ACCOUNT_ID is null
--          C#OUT_NUM is null
    )      
    LOOP
        BEGIN
            P#FCR.ins#account_op (  
                A#ACCOUNT_ID => new_acc_rec.ACCOUNT_ID,
                A#DATE => GET_NEW_RKC_DATE(new_acc_rec.ACCOUNT_ID,new_acc_rec.NEW_DATE),
                A#OUT_PROC_ID => 10,
                A#OUT_NUM => new_acc_rec.NEW_ACCOUNT_NUM,
                A#NOTE => 'ADD_NEW_FCR_ACCOUNTS: '||sysdate 
                ); 
--        EXCEPTION
--            WHEN OTHERS THEN NULL;
        END;        
    END LOOP;
   END ADD_NEW_FCR_ACCOUNTS;




  FUNCTION get#acc_area(a#acc_id NUMBER, a#date DATE  DEFAULT sysdate) RETURN NUMBER AS
      res NUMBER;
    BEGIN
      SELECT SUM(rsvd.c#area_val)
        INTO res
        FROM 
             t#account a,
             t#rooms r,
             t#rooms_spec rs,
             (SELECT *
                 FROM t#rooms_spec_vd rsvd
                 WHERE 1 = 1
                   AND rsvd.c#valid_tag = 'Y'
                   AND rsvd.c#vn = (SELECT MAX(t.c#vn)
                       FROM t#rooms_spec_vd t
                       WHERE t.c#id = rsvd.c#id)) rsvd
        WHERE 1 = 1
          AND a.c#id = a#acc_id
          AND a.c#rooms_id = r.c#id
          AND rs.c#rooms_id = r.c#id
          AND rs.c#id = rsvd.c#id
          AND rs.c#date <= a#date;

      RETURN res;
    END;


  FUNCTION get#acc_addr(a#acc_id NUMBER) RETURN VARCHAR2 AS
    ret VARCHAR2(500); 
  BEGIN
    select P#UTILS.GET#ROOMS_ADDR(C#ROOMS_ID) 
    into ret
    from T#ACCOUNT
    where C#ID = a#acc_id and rownum < 2;
    RETURN ret;
  END get#acc_addr;

  FUNCTION get#end_account_mn(a#acc_id NUMBER) RETURN NUMBER AS
    ret NUMBER;
  BEGIN
    select NVL(P#MN_UTILS.GET#MN(L.C#END_DATE),1000)
    into ret
    from V#ACC_LAST_END L
    where L.C#ACCOUNT_ID = a#acc_id;
    RETURN ret;
  END get#end_account_mn;

  FUNCTION get#count_88(a#acc_id NUMBER) RETURN NUMBER AS
    ret NUMBER;
  BEGIN
    select 
        count(*) 
    into ret    
    from T#PAY_SOURCE 
    where C#COD_RKC = '88' and NVL(C#ACC_ID, C#ACC_ID_CLOSE) = a#acc_id;
    RETURN ret;
  END get#count_88;

  FUNCTION get#acc_id#by#acc_num(a#acc_num VARCHAR2) RETURN NUMBER AS
    ret NUMBER;
  BEGIN
    select C#ID into ret from V#ACCOUNT where C#NUM = a#acc_num;
    RETURN ret;
  END get#acc_id#by#acc_num;

  FUNCTION get#acc_num#by#acc_id(a#acc_id NUMBER) RETURN VARCHAR2 AS
    ret VARCHAR2(50);
  BEGIN
    select C#NUM into ret from V#ACCOUNT where C#ID = a#acc_id;
    RETURN ret;
  END get#acc_num#by#acc_id;

-- перенос всех платежей со счета на счет (в параметрах указывать внутренние счета)  
  PROCEDURE transfer#all_pays(from_acc_num VARCHAR2, to_acc_num VARCHAR2) AS
    cursor PAYS is
        select
            P.C#ID PS_ID,
            P#TOOLS.GET#ACC_ID#BY#ACC_NUM(to_acc_num) TO_ACC_ID,
            sysdate tr_date,
            P#UTILS.GET#OPEN_MN() tr_mn
        from
            T#PAY_SOURCE P
            join V#ACCOUNT A on (NVL(C#ACC_ID,C#ACC_ID_CLOSE) = A.C#ID)
        where
            A.C#NUM = from_acc_num
            AND P.c#storno_id IS NULL
            AND P.c#id NOT IN (SELECT c#storno_id FROM t#pay_source  WHERE c#storno_id IS NOT NULL)
        ;
  BEGIN
    for P in PAYS loop
        TRANSFER#PAY(P.PS_ID, P.TO_ACC_ID, P.TR_DATE, P.TR_MN);
    end loop;          
  END transfer#all_pays;

  PROCEDURE set_rooms_area(p_ROOMS_ID NUMBER, p_NEW_AREA NUMBER) AS
    A#ID NUMBER;
    A#VN NUMBER;
    A#LT VARCHAR2(1);
    A#OTT VARCHAR2(1);
  BEGIN
    SELECT C#ID INTO A#ID FROM T#ROOMS_SPEC where C#ROOMS_ID = p_ROOMS_ID and C#DATE = (SELECT MAX(C#DATE) FROM T#ROOMS_SPEC where C#ROOMS_ID = p_ROOMS_ID);
    SELECT MAX(C#VN) INTO A#VN FROM T#ROOMS_SPEC_VD WHERE C#ID = A#ID;
    SELECT
        C#LIVING_TAG,
        C#OWN_TYPE_TAG
    INTO
        A#LT,
        A#OTT
    FROM     
        T#ROOMS_SPEC_VD
    WHERE
        C#ID = A#ID
        AND C#VN = A#VN
    ;
    INSERT INTO T#ROOMS_SPEC_VD (C#ID, C#VN, C#VALID_TAG, C#LIVING_TAG, C#OWN_TYPE_TAG, C#AREA_VAL)
    VALUES (A#ID, A#VN+1, 'Y', A#LT, A#OTT, p_NEW_AREA);
    COMMIT;
  END set_rooms_area;

  FUNCTION house_is_open(a#acc_id NUMBER) RETURN VARCHAR2 AS
    res VARCHAR2(1);
  BEGIN
    select
        CASE WHEN HI.C#END_DATE is null THEN 'Y' ELSE 'N' END
    into
        res
    from
        V#ACCOUNT A
        join V#ROOMS R on (A.C#ROOMS_ID = R.C#ROOMS_ID)
        join T#HOUSE_INFO HI on (R.C#HOUSE_ID = HI.C#HOUSE_ID)
    where
        A.C#ID = a#acc_id
    ;        
    RETURN res;
  END house_is_open;



  PROCEDURE DEL#MASS_PAY_FOR_ACC(a#acc_id NUMBER) AS
    A#NUM VARCHAR2(50);
  BEGIN
    select C#NUM into A#NUM from fcr.v#account where c#id = a#acc_id and c#end_date is not null;
    if A#NUM is not null then
        execute immediate 'ALTER TRIGGER TR#OP_VD#STOP_MOD DISABLE';
        execute immediate 'ALTER TRIGGER TR#OP#STOP_MOD DISABLE';
        delete from T#OP where C#ID in (
            SELECT
                O.C#ID
            FROM
                T#OP O
                LEFT JOIN T#PAY_SOURCE P ON (P.C#OPS_ID = O.C#OPS_ID)
            WHERE
                O.C#ACCOUNT_ID = a#acc_id
                AND P.C#ID IS NULL
        );
        delete from T#MASS_PAY where c#acc_id = a#acc_id;
        COMMIT;
        execute immediate 'ALTER TRIGGER TR#OP_VD#STOP_MOD ENABLE';
        execute immediate 'ALTER TRIGGER TR#OP#STOP_MOD ENABLE';
        DO#RECALC_ACCOUNT(A#NUM ,TO_DATE('01.06.2014','dd.mm.yyyy'));
        COMMIT;
    end if;    
  END DEL#MASS_PAY_FOR_ACC;

  FUNCTION account_is_open_error(a#acc_id NUMBER) RETURN VARCHAR2 AS
    res VARCHAR2(1);
  BEGIN
    select CASE count(*) WHEN 0 THEN 'N' ELSE 'Y' END
    into res
    from v#account 
    where C#ID = a#acc_id and C#DATE = c#end_date;
    RETURN res;
  END account_is_open_error;

  PROCEDURE FILL_CHARGE_PAY_J_TABLES(p_PERSON_ID INTEGER) AS
  BEGIN
DELETE FROM tt#akt_j;

INSERT INTO tt#akt_j SELECT
    ch.c#account_id,
    ch.m,
    nach,
    sum_op
FROM
    (
        SELECT
            t1.c#person_id,
            t1.m,
            t1.c#account_id,
            MAX(t1.c#tar_val) c#tar_val,
            SUM(nach) nach
        FROM
            (
                SELECT
                    t.c#person_id,
                    TO_CHAR(
                        p#mn_utils.get#date(tc.c#a_mn),
                        'mm.yyyy'
                    ) m,
                    tc.c#account_id,
                    MAX(v.c#tar_val) c#tar_val,
                    SUM(tc.c#sum) nach
                FROM
                    fcr.t#charge tc
                    INNER JOIN (
                        SELECT
                            *
                        FROM
                            (
                                SELECT
                                    asp.c#person_id,
                                    asp.c#account_id,
                                    a.c#num,
                                    asp.c#date,
                                    nvl(
                                        LEAD(
                                            asp.c#date
                                        ) OVER(PARTITION BY
                                            asp.c#account_id
                                            ORDER BY asp.c#date
                                        ),
                                        fcr.p#mn_utils.get#date(fcr.p#utils.get#open_mn + 1)
                                    ) "C#NEXT_DATE"
                                FROM
                                    v#account_spec asp
                                    INNER JOIN t#account a ON (
                                        a.c#id = asp.c#account_id
                                    )
                                WHERE
                                        1 = 1
                                    AND
                                        asp.c#valid_tag = 'Y'
                                    AND
                                        asp.c#account_id IN (
                                            SELECT
                                                c#account_id
                                            FROM
                                                v#account_spec
                                            WHERE
                                                    1 = 1
                                                AND
                                                    c#valid_tag = 'Y'
                                                AND
                                                    c#person_id = p_PERSON_ID
                                        )
                            ) t2
                        WHERE
                            c#person_id = p_PERSON_ID
                    ) t ON (
                            tc.c#account_id = t.c#account_id
                        AND
                            tc.c#a_mn <= fcr.p#mn_utils.get#mn(t.c#next_date)
                    )
                    LEFT JOIN (
                        SELECT
                            vw.c#id,
                            vw.c#date,
                            tobj.c#account_id,
                            vw.c#tar_val
                        FROM
                            fcr.v#obj tobj
                            INNER JOIN fcr.v#work vw ON (
                                tobj.c#work_id = vw.c#id
                            )
                    ) v ON (
                            v.c#account_id = tc.c#account_id
                        AND
                            tc.c#work_id = v.c#id
                    )
                WHERE
                    1 = 1
                GROUP BY
                    t.c#person_id,
                    TO_CHAR(
                        p#mn_utils.get#date(tc.c#a_mn),
                        'mm.yyyy'
                    ),
                    tc.c#account_id
            ) t1
        GROUP BY
            t1.c#person_id,
            t1.m,
            t1.c#account_id
    ) ch
    LEFT JOIN (
        SELECT
            c#account_id,
            m,
            SUM(sum_op) sum_op
        FROM
            (
                SELECT
                    vop.c#account_id,
                    TO_CHAR(
                        CASE
                            WHEN(
                                SELECT
                                    c#date
                                FROM
                                    v#account va
                                WHERE
                                    va.c#id = vop.c#account_id
                            ) > c#real_date THEN(
                                SELECT
                                    c#date
                                FROM
                                    v#account va
                                WHERE
                                    va.c#id = vop.c#account_id
                            )
                            WHEN months_between(
                                c#real_date,
                                (
                                    SELECT
                                        c#end_date
                                    FROM
                                        v#account va
                                    WHERE
                                        va.c#id = vop.c#account_id
                                )
                            ) >-1 THEN
                                CASE
                                    WHEN(
                                        SELECT
                                            c#end_date
                                        FROM
                                            v#account va
                                        WHERE
                                            va.c#id = vop.c#account_id
                                    ) > (
                                        SELECT
                                            c#date
                                        FROM
                                            v#account va
                                        WHERE
                                            va.c#id = vop.c#account_id
                                    ) THEN add_months(
                                        (
                                            SELECT
                                                c#end_date
                                            FROM
                                                v#account va
                                            WHERE
                                                va.c#id = vop.c#account_id
                                        ),
                                        -1
                                    )
                                    ELSE(
                                        SELECT
                                            c#end_date
                                        FROM
                                            v#account va
                                        WHERE
                                            va.c#id = vop.c#account_id
                                    )
                                END
                            ELSE
                                CASE
                                    WHEN months_between(c#real_date,t.c#next_date) >-1 THEN add_months(t.c#next_date,-1)
                                    ELSE c#real_date
                                END
                        END,
                        'mm.yyyy'
                    ) m,
                    SUM(c#sum) sum_op
                FROM
                    fcr.v#op vop
                    INNER JOIN (
                        SELECT
                            *
                        FROM
                            (
                                SELECT
                                    asp.c#person_id,
                                    asp.c#account_id,
                                    a.c#num,
                                    asp.c#date,
                                    nvl(
                                        LEAD(
                                            asp.c#date
                                        ) OVER(PARTITION BY
                                            asp.c#account_id
                                            ORDER BY asp.c#date
                                        ),
                                        fcr.p#mn_utils.get#date(fcr.p#utils.get#open_mn + 1)
                                    ) "C#NEXT_DATE"
                                FROM
                                    v#account_spec asp
                                    INNER JOIN t#account a ON (
                                        a.c#id = asp.c#account_id
                                    )
                                WHERE
                                        1 = 1
                                    AND
                                        asp.c#valid_tag = 'Y'
                                    AND
                                        asp.c#account_id IN (
                                            SELECT
                                                c#account_id
                                            FROM
                                                v#account_spec
                                            WHERE
                                                    1 = 1
                                                AND
                                                    c#valid_tag = 'Y'
                                                AND
                                                    c#person_id = p_PERSON_ID
                                        )
                            ) t2
                        WHERE
                            c#person_id = p_PERSON_ID
                    ) t ON (
                            vop.c#account_id = t.c#account_id
                        AND
                            vop.c#a_mn <= fcr.p#mn_utils.get#mn(t.c#next_date)
                    )
                WHERE
                    1 = 1
                GROUP BY
                    vop.c#account_id,
                    c#real_date,
                    t.c#next_date
            ) t
        GROUP BY
            c#account_id,
            m
    ) op ON (
            ch.m = op.m
        AND
            ch.c#account_id = op.c#account_id
    );

COMMIT;
  
        delete from TT#CHARGE_PAY_J;
        insert into TT#CHARGE_PAY_J
        with
            acc as (
                select
                    C#ACCOUNT_ID,
                    C#ACC_NUM
                from
                    V#ACC_LAST2
                WHERE
                    C#PERSON_ID = p_PERSON_ID
            )
            ,ch as (
                select
                    C#ACCOUNT_ID,
                    C#A_MN,
                    SUM(C#SUM) CHARGE_SUM
                from
                    t#charge
                where
                    C#ACCOUNT_ID in (select C#ACCOUNT_ID from acc)
                GROUP BY
                    C#ACCOUNT_ID,
                    C#A_MN
            )
            ,pay as (
                select
                    C#ACCOUNT_ID,
                    C#A_MN,
                    SUM(C#SUM) PAY_SUM
                from
                    v#op
                where
                    C#ACCOUNT_ID in (select C#ACCOUNT_ID from acc)
                GROUP BY
                    C#ACCOUNT_ID,
                    C#A_MN
            )
            ,alls as (
                select
                    acc.*,
                    ch.C#A_MN,
                    ch.CHARGE_SUM,
                    pay.PAY_SUM
                from
                    acc
                    left join ch on (acc.C#ACCOUNT_ID = ch.C#ACCOUNT_ID)
                    left join pay on (ch.C#ACCOUNT_ID = pay.C#ACCOUNT_ID and ch.C#A_MN = pay.C#A_MN)
            )
        select
            *
        from
            alls
        ;
        COMMIT;
        
        
        P#REPORTS.LST#REESTR2(p_PERSON_ID);

        P#PRINT_BILL_J.do#prepare2(TO_DATE('01.06.2014','dd.mm.yyyy'),sysdate,p_PERSON_ID);

  END FILL_CHARGE_PAY_J_TABLES;

    FUNCTION ACC_TYPE_BY_HOUSE_ID(a#house_id NUMBER) RETURN VARCHAR2 AS
        res varchar2(3);
    BEGIN
        select acc_type into res from V4_BANK_VD where house_id = a#house_id;
        RETURN res;
    END ACC_TYPE_BY_HOUSE_ID;

END P#TOOLS;
/
