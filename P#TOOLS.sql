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
      WITH TMP#PERSON AS (SELECT C#NAME || ' (»ЌЌ: ' || C#INN_NUM || ')' PERSON_NAME
            FROM T#PERSON_J
            WHERE C#PERSON_ID = P_PERSON_ID
            UNION
          SELECT C#F_NAME || ' ' || C#I_NAME || ' ' || C#O_NAME PERSON_NAME
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

END P#TOOLS;
/
