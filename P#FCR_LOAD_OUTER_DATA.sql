CREATE OR REPLACE PACKAGE "P#FCR_LOAD_OUTER_DATA"
  AS
  /** Author  : ALEXANDER
  * Created : 02-2016 
  */

  a#err VARCHAR2(4000);

  /** 
  * Заполнение таблицы реестра оплат юридицеских лиц
  */
  PROCEDURE INS#MASS_PAY(A#PERSON_ID  INTEGER,
                         A#DATE       DATE,
                         A#SUM        NUMBER,
                         A#LIVING_TAG VARCHAR2,
                         A#NPD        VARCHAR2,
                         A#COD_RKC    VARCHAR2,
                         A#COMMENT    VARCHAR2);

  /** 
  * Распределение оплат юридических лиц 
  * Author  :  ALEXANDER 
  */
  PROCEDURE Filling_these_municipalities;



  /** 
  * Заполнение таблицы реестра оплат финансовой информации
  * Author  : Гридасов Алексей ( модификации ALEXANDER )
  */
  PROCEDURE INS#KOTEL_OTHER_PRIH(A#PL_SUM  IN NUMBER,
                                 A#PL_DATE IN DATE,
                                 A#COMM       VARCHAR2);

  /** 
  * Заполнение таблицы реестра оплат финансовой информации
  * Author  : Гридасов Алексей ( модификации ALEXANDER )
  */
  PROCEDURE INS#SPEC_PRIHOD(A#ID_HOUSE IN NUMBER,
                            A#DT_PAY   IN DATE,
                            A#PAY      IN NUMBER,
                            A#COMMENT     VARCHAR2);



  /** 
  * Загрузка оплат и распределение по счетам физических лиц 
  * Author  :  ALEXANDER 
  * @param a#in_file_id идентификатор файла с загружаемой инфрормацией
  * @param a#in_date дата распределения
  */
  PROCEDURE ExecAllFunction(a#in_file_id NUMBER,
                            a#in_date    DATE);


  PROCEDURE ExecAllFunctionCycle;


--function Distr_Data_Active_Account(a#in_file_id number, a#in_date date)return number;
--function Distr_Data_Not_Active_Account(a#in_file_id number, a#in_date date)  return number;
--function Distr_Data_Bank_Account(a#in_file_id number, a#in_date date)  return number;

END P#FCR_LOAD_OUTER_DATA;
/


CREATE OR REPLACE PACKAGE BODY "P#FCR_LOAD_OUTER_DATA"
  AS

  PROCEDURE INS#MASS_PAY(A#PERSON_ID  INTEGER,
                         A#DATE       DATE,
                         A#SUM        NUMBER,
                         A#LIVING_TAG VARCHAR2,
                         A#NPD        VARCHAR2,
                         A#COD_RKC    VARCHAR2,
                         A#COMMENT    VARCHAR2)
    IS
      a#hash  VARCHAR2(100);
      a#exist INTEGER;
    BEGIN

      a#hash := A#PERSON_ID || TO_CHAR(A#DATE, 'dd.mm.yyyy') || A#SUM || A#NPD || A#COD_RKC;
      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.t#mass_pay
        WHERE (c#PERSON_ID || TO_CHAR(c#DATE, 'dd.mm.yyyy') || c#SUM || c#NPD || c#COD_RKC) = a#hash;
      IF a#exist = 0
      THEN

        INSERT INTO fcr.t#mass_pay (
          C#PERSON_ID, C#DATE, C#SUM, C#LIVING_TAG, C#NPD, C#COD_RKC, C#COMMENT
        )
        VALUES (A#PERSON_ID, A#DATE, A#SUM, A#LIVING_TAG, A#NPD, A#COD_RKC, A#COMMENT);
        COMMIT;

      END IF;
    EXCEPTION
      WHEN OTHERS THEN a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_LOAD_OUTER_DATA', 'INS#MASS_PAY', sysdate, a#err, TO_CHAR(A#PERSON_ID));
          ROLLBACK;

    END INS#MASS_PAY;

  PROCEDURE INS#KOTEL_OTHER_PRIH(A#PL_SUM  IN NUMBER,
                                 A#PL_DATE IN DATE,
                                 A#COMM       VARCHAR2)
    IS
      a#hash  VARCHAR2(100);
      a#exist INTEGER;
    BEGIN

      a#hash := TO_CHAR(A#PL_SUM) || TO_CHAR(A#PL_DATE, 'dd.mm.yyyy') || A#COMM;
      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.KOTEL_OTHER_PRIH
        WHERE (TO_CHAR(PL_SUM) || TO_CHAR(PL_DATE, 'dd.mm.yyyy') || COMM) = a#hash;
      IF a#exist = 0
      THEN

        INSERT INTO fcr.KOTEL_OTHER_PRIH (
          PL_SUM, PL_DATE, COMM
        )
        VALUES (A#PL_SUM, A#PL_DATE, A#COMM);
        COMMIT;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_LOAD_OUTER_DATA', 'INS#KOTEL_OTHER_PRIH', sysdate, a#err, A#COMM);
          ROLLBACK;

    END INS#KOTEL_OTHER_PRIH;

      PROCEDURE ins#spec_prihod (
        a#id_house   IN NUMBER,
        a#dt_pay     IN DATE,
        a#pay        IN NUMBER,
        a#comment    VARCHAR2
    ) IS
        a#hash    VARCHAR2(1000);
        a#exist   INTEGER;
    BEGIN
        a#hash := TO_CHAR(a#id_house)
        || TO_CHAR(a#dt_pay,'dd.mm.yyyy')
        || TO_CHAR(a#pay)
        || a#comment;

        SELECT
            COUNT(*)
        INTO
            a#exist
        FROM
            fcr.spec_prihod
        WHERE
            ( TO_CHAR(id_house)
            || TO_CHAR(dt_pay,'dd.mm.yyyy')
            || TO_CHAR(pay)
            || c#comment ) = a#hash;

        IF
            a#exist = 0
        THEN
            INSERT INTO fcr.spec_prihod (
                id_house,
                dt_pay,
                pay,
                c#comment
            ) VALUES (
                a#id_house,
                a#dt_pay,
                REPLACE(TO_CHAR(a#pay),'.',','),
                a#comment
            );

            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            a#err := 'Error - '
            || TO_CHAR(sqlcode)
            || ' - '
            || sqlerrm;
            INSERT INTO fcr.t#exception (
                c#name_package,
                c#name_proc,
                c#date,
                c#text,
                c#comment
            ) VALUES (
                'P#FCR_LOAD_OUTER_DATA',
                'INS#SPEC_PRIHOD',
                SYSDATE,
                a#err,
                a#comment
            );

            ROLLBACK;
    END ins#spec_prihod;


  /** 
  * Author  : Гридасов Алексей ( модификации ALEXANDER )
  */
  FUNCTION Fill_Active_Account(a#in_file_id NUMBER)
    RETURN NUMBER
    AS
      CURSOR ls_pay (in_file_id IN NUMBER) IS
          SELECT t.c#id,
                 fcr.get_acc_for_pay(t.c#account, t.c#real_date) AS acc_id
            FROM fcr.t#pay_source t
            WHERE 1 = 1
              AND ((in_file_id = -1)
              OR t.c#file_id = in_file_id)
              AND t.c#acc_id IS NULL and C#OPS_ID is null and c#account is not null;
    BEGIN
      FOR c IN ls_pay(a#in_file_id)
      LOOP
        UPDATE fcr.t#pay_source f
          SET f.c#acc_id = c.acc_id
          WHERE f.c#id = c.c#id;
      END LOOP;
      RETURN 1;
    END Fill_Active_Account;

  /** 
  * Author  : Гридасов Алексей ( модификации ALEXANDER )
  */
  FUNCTION Fill_Not_Active_Account(a#in_file_id NUMBER)
    RETURN NUMBER
    AS
      CURSOR ls_pay (in_file_id IN NUMBER) IS
          SELECT t.c#id,
                 fcr.get_acc_for_pay_any(t.c#account, t.c#real_date) AS acc_id_close
            FROM fcr.t#pay_source t
            WHERE 1 = 1
              AND ((in_file_id = -1)
              OR t.c#file_id = in_file_id)
              AND t.c#acc_id IS NULL  and C#OPS_ID is null  and c#account is not null
      ;
    BEGIN
      FOR c IN ls_pay(a#in_file_id)
      LOOP
        UPDATE fcr.t#pay_source f
          SET f.c#acc_id_close = c.acc_id_close
          WHERE f.c#id = c.c#id;
      END LOOP;
      RETURN 1;
    END Fill_Not_Active_Account;

  FUNCTION Fill_Bank_Account(a#in_file_id NUMBER)
    RETURN NUMBER
    AS
      CURSOR ls_pay (in_file_id NUMBER) IS
          SELECT fp.c#id,
                 fcr.get_acc_for_pay_tter(fp.c#account, fp.c#real_date) AS acc_id_tter
            FROM (SELECT fp.*,
                         (SELECT MAX(op.c#out_num)
                             FROM fcr.t#account_op op
                             WHERE 1 = 1
                               AND op.c#out_num LIKE '%' || fp.c#account
                               AND op.c#out_proc_id = 2) AS ls_new
                FROM fcr.t#pay_source fp
                WHERE fp.c#acc_id IS NULL
                  AND fp.c#acc_id_close IS NULL
                   and C#OPS_ID is null
                  ---------------
                  AND ((in_file_id = -1)
                  OR fp.c#file_id = in_file_id)
                  ---------------
                  AND fp.c#cod_rkc IN (51, 52)
                  AND EXISTS (SELECT 1
                      FROM fcr.t#account_op op
                      WHERE 1 = 1
                        AND op.c#out_num LIKE '%' || fp.c#account
                        AND op.c#out_proc_id = 2)
                  AND LENGTH(fp.c#account) > 8
                  AND (SELECT COUNT(op.c#out_num)
                      FROM fcr.t#account_op op
                      WHERE 1 = 1
                        AND op.c#out_num LIKE '%' || fp.c#account
                        AND op.c#out_proc_id = 2) = 1) fp
      ;

    BEGIN
      FOR c IN ls_pay(a#in_file_id)
      LOOP
        UPDATE fcr.t#pay_source f
          SET f.c#acc_id_tter = c.acc_id_tter
          WHERE f.c#id = c.c#id;
      END LOOP;
      RETURN 1;
    END Fill_Bank_Account;

  FUNCTION Distr_Data_Active_Account(a#in_file_id NUMBER,
                                     a#in_date    DATE)
    RETURN NUMBER
    AS

      CURSOR pay (in_file_id NUMBER) IS
          SELECT --t.sort_order, t.acc_id, t.summ_pl, t.cod_rkc, t.data_pl, t.fine, t.period
          t.c#id,
          t.c#acc_id,
          t.c#summa,
          t.c#cod_rkc,
          t.c#real_date,
          t.c#fine,
          t.c#period
            FROM fcr.t#pay_source t
            WHERE t.c#acc_id IS NOT NULL
              AND ((in_file_id = -1)
              OR t.c#file_id = in_file_id)
              AND t.c#ops_id IS NULL
            ORDER BY 2,
                     5,
                     1;

      CURSOR nach (in_ls IN NUMBER, in_a_mn IN NUMBER) IS
          SELECT a.*
            FROM (SELECT A.C#WORK_ID,
                         A.C#DOER_ID,
                         A.C#A_MN,
                         A.C#B_MN,
                         SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) TO_PAY
                FROM (SELECT C.C#WORK_ID,
                             C.C#DOER_ID,
                             C.C#A_MN,
                             C.C#B_MN,
                             C.C#VOL "C#C_VOL",
                             C.C#SUM "C#C_SUM",
                             NULL "C#MC_SUM",
                             NULL "C#M_SUM",
                             NULL "C#MP_SUM",
                             NULL "C#P_SUM"
                    FROM T#CHARGE C
                    WHERE 1 = 1
                      AND C.C#ACCOUNT_ID = in_LS
                    UNION ALL
                  SELECT O.C#WORK_ID,
                         O.C#DOER_ID,
                         O.C#A_MN,
                         O.C#B_MN,
                         NULL "C#C_VOL",
                         NULL "C#C_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'MC' THEN O_VD.C#SUM END "C#MC_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'M' THEN O_VD.C#SUM END "C#M_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'MP' THEN O_VD.C#SUM END "C#MP_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'P' THEN O_VD.C#SUM END "C#P_SUM"
                    FROM T#OP O,
                         T#OP_VD O_VD
                    WHERE 1 = 1
                      AND O.C#ACCOUNT_ID = in_LS
                      AND O_VD.C#ID = O.C#ID
                      AND O_VD.C#VN = (SELECT MAX(C#VN)
                          FROM T#OP_VD
                          WHERE C#ID = O_VD.C#ID)
                      AND O_VD.C#VALID_TAG = 'Y') a
                WHERE a.C#A_MN <= in_A_MN
                GROUP BY A.C#A_MN,
                         A.C#B_MN,
                         A.C#WORK_ID,
                         A.C#DOER_ID
                HAVING SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) <> 0) a
            ORDER BY CASE WHEN a.to_pay < 0 THEN 0 ELSE 1 END,
                     a.c#a_mn,
                     a.c#b_mn,
                     a.c#work_id,
                     a.c#doer_id;

      kind_id  NUMBER;
      A#DATE   DATE;
      w_id     NUMBER;
      w1_id    NUMBER;
      d1_id    NUMBER;
      d_id     NUMBER;
      ops_id   NUMBER;
      op_id    NUMBER;
      ostatok  NUMBER;
      A_MN     NUMBER;
      per_num  NUMBER;
      pay_date DATE;

    BEGIN
      A#DATE := sysdate;
      A_MN := fcr.p#mn_utils.GET#MN(a#in_date);

      FOR c IN pay(a#in_file_id)
      LOOP
        --dbms_output.put_line('Сумма для распределения = '||c.c#summa|| ' дата = '||c.c#real_date || ' cod_rkc : '|| c.c#cod_rkc);

        IF c.c#real_date < fcr.p#mn_utils.GET#DATE(A_MN)
        THEN
          pay_date := fcr.p#mn_utils.GET#DATE(A_MN);
        ELSE
          pay_date := c.c#real_date;
        END IF;

        --dbms_output.put_line('sort_order = '||c.sort_order);

        SELECT ok.c#id
          INTO kind_id
          FROM fcr.t#ops_kind ok
          WHERE ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc, '00'));

        SELECT MAX(a.C#WORK_ID),
               MAX(a.C#DOER_ID)
          INTO w_id,
               d_id
          FROM (SELECT WS.C#SERVICE_ID
                       -- ,W.C#WORKS_ID
                       ,
                       W.C#ID AS c#WORK_ID
                       --      ,W_VD.C#TAR_TYPE_TAG
                       --      ,W_VD.C#TAR_VAL
                       ,
                       D_VD.C#DOER_ID,
                       ROW_NUMBER() OVER (PARTITION BY D.C#house_Id ORDER BY d.c#date DESC, NVL(d_vd.c#end_date, TO_DATE('01.01.2222', 'dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
              FROM T#DOING D,
                   T#DOING_VD D_VD,
                   T#WORK W,
                   T#WORK_VD W_VD,
                   T#WORKS WS
              WHERE 1 = 1
                AND D.C#HOUSE_ID = (SELECT R.C#HOUSE_ID
                    FROM T#ACCOUNT A,
                         T#ROOMS R
                    WHERE A.C#ID = c.c#acc_id
                      AND R.C#ID = A.C#ROOMS_ID)
                AND D.C#DATE = (SELECT MAX(C#DATE)
                    FROM T#DOING
                    WHERE C#HOUSE_ID = D.C#HOUSE_ID
                      AND C#WORKS_ID = D.C#WORKS_ID
                      AND C#DATE <= A#DATE)
                AND D_VD.C#ID = D.C#ID
                AND D_VD.C#VN = (SELECT MAX(C#VN)
                    FROM T#DOING_VD
                    WHERE C#ID = D_VD.C#ID)
                AND D_VD.C#VALID_TAG = 'Y'
                --             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
                AND W.C#WORKS_ID = D.C#WORKS_ID
                AND W.C#DATE = (SELECT MAX(C#DATE)
                    FROM T#WORK
                    WHERE C#WORKS_ID = W.C#WORKS_ID
                      AND C#DATE < A#DATE)
                AND W_VD.C#ID = W.C#ID
                AND W_VD.C#VN = (SELECT MAX(C#VN)
                    FROM T#WORK_VD
                    WHERE C#ID = W_VD.C#ID)
                AND W_VD.C#VALID_TAG = 'Y'
                AND WS.C#ID = W.C#WORKS_ID) a
          WHERE a.sort_order = 1
        ;
        --dbms_output.put_line('w_id = '||w_id);
        IF w_id IS NOT NULL
        THEN

          INSERT INTO fcr.t#ops (
            c#id
          )
          VALUES (fcr.s#ops.NEXTVAL) RETURNING c#id INTO ops_id;

          --dbms_output.put_line('ops_id = '||ops_id);


          INSERT INTO t#ops_vd (
            c#id, c#vn, c#valid_tag, c#kind_id
          )
          VALUES (ops_id, 1, 'Y', kind_id);

          ostatok := c.c#summa;
          IF ostatok > 0
          THEN

            --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.c#real_date);

            FOR d IN nach(c.c#acc_id, a_mn)
            LOOP

              IF ostatok > 0
              THEN

                IF d.to_pay < ostatok
                THEN
                  INSERT INTO fcr.t#op (
                    c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                  )
                  VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                  INSERT INTO fcr.t#op_vd (
                    c#id, c#vn, c#valid_tag, c#sum
                  )
                  VALUES (op_id, 1, 'Y', d.to_pay);
                  ostatok := ostatok - d.to_pay;
                ELSE
                  INSERT INTO fcr.t#op (
                    c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                  )
                  VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                  INSERT INTO fcr.t#op_vd (
                    c#id, c#vn, c#valid_tag, c#sum
                  )
                  VALUES (op_id, 1, 'Y', ostatok);
                  ostatok := 0;
                END IF;
              END IF;
            END LOOP;

            IF ostatok > 0
            THEN --Если остались деньги после всех распределений
              --dbms_output.put_line('Остаток после всех распределений = '||ostatok);  


              BEGIN
                SELECT c#work_id,
                       c#doer_id
                  INTO w1_id,
                       d1_id
                  FROM (SELECT ch.C#WORK_ID,
                               ch.C#DOER_ID,
                               ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                      FROM fcr.v#chop ch
                      WHERE ch.C#ACCOUNT_ID = c.c#acc_id
                        AND ch.C#A_MN = a_mn --a_mn+1
                        AND (ch.C#C_SUM IS NOT NULL
                        OR ch.C#P_SUM IS NOT NULL))
                  WHERE sort_order = 1
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN BEGIN
                      w1_id := w_id;
                      d1_id := d_id;
                    END;
              END;

              INSERT INTO fcr.t#op (
                c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
              )
              VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn, a_mn, 'P')
              --   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')	 
              RETURNING c#id INTO op_id;

              INSERT INTO fcr.t#op_vd (
                c#id, c#vn, c#valid_tag, c#sum
              )
              VALUES (op_id, 1, 'Y', ostatok);

            END IF;



          ELSE --Отрицательная оплата  

            BEGIN
              SELECT c#work_id,
                     c#doer_id
                INTO w1_id,
                     d1_id
                FROM (SELECT ch.C#WORK_ID,
                             ch.C#DOER_ID,
                             ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                    FROM fcr.v#chop ch
                    WHERE ch.C#ACCOUNT_ID = c.c#acc_id
                      AND ch.C#A_MN = a_mn -- a_mn+1
                      AND (ch.C#C_SUM IS NOT NULL
                      OR ch.C#P_SUM IS NOT NULL))
                WHERE sort_order = 1
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN BEGIN
                    w1_id := w_id;
                    d1_id := d_id;
                  END;
            END;

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn, a_mn, 'P')
            --   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
            RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', ostatok);
          END IF;
          UPDATE fcr.t#pay_source f
            SET f.c#transfer_flg = 1, f.c#ops_id = ops_id, f.c#kind_id = kind_id, f.c#date = pay_date
            WHERE 1 = 1
            AND f.c#id = c.c#id;


          IF NVL(c.c#fine, 0) <> 0
          THEN --есть пени

            per_num := fcr.p#mn_utils.GET#MN(TO_DATE(c.c#period, 'mmyy'));

            BEGIN
              SELECT c#work_id,
                     c#doer_id
                INTO w1_id,
                     d1_id
                FROM (SELECT ch.C#WORK_ID,
                             ch.C#DOER_ID,
                             ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                    FROM fcr.v#chop ch
                    WHERE ch.C#ACCOUNT_ID = c.c#acc_id
                      AND ch.C#A_MN = per_num
                      AND (ch.C#C_SUM IS NOT NULL
                      OR ch.C#P_SUM IS NOT NULL))
                WHERE sort_order = 1
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN BEGIN
                    w1_id := w_id;
                    d1_id := d_id;
                  END;
            END;

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FC') RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', c.c#fine);

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FP') RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', c.c#fine);

          END IF;


        END IF;
        COMMIT;
      END LOOP;
      RETURN 1;
    END Distr_Data_Active_Account;


  FUNCTION Distr_Data_Not_Active_Account(a#in_file_id NUMBER,
                                         a#in_date    DATE)
    RETURN NUMBER
    AS
      CURSOR pay (in_file_id NUMBER) IS
          SELECT t.c#id,
                 t.c#acc_id_close AS acc_id,
                 t.c#summa,
                 t.c#cod_rkc,
                 t.c#real_date,
                 t.c#fine,
                 t.c#period
            FROM fcr.t#pay_source t
            WHERE t.c#acc_id_close IS NOT NULL
              AND ((in_file_id = -1)
              OR t.c#file_id = in_file_id)
              AND t.c#ops_id IS NULL
            ORDER BY 2,
                     5,
                     1;
      CURSOR nach (in_ls IN NUMBER, in_a_mn IN NUMBER) IS

          SELECT a.*
            FROM (SELECT A.C#WORK_ID,
                         A.C#DOER_ID,
                         A.C#A_MN,
                         A.C#B_MN,
                         SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) TO_PAY
                FROM (SELECT C.C#WORK_ID,
                             C.C#DOER_ID,
                             C.C#A_MN,
                             C.C#B_MN,
                             C.C#VOL "C#C_VOL",
                             C.C#SUM "C#C_SUM",
                             NULL "C#MC_SUM",
                             NULL "C#M_SUM",
                             NULL "C#MP_SUM",
                             NULL "C#P_SUM"
                    FROM T#CHARGE C
                    WHERE 1 = 1
                      AND C.C#ACCOUNT_ID = IN_LS
                    UNION ALL
                  SELECT O.C#WORK_ID,
                         O.C#DOER_ID,
                         O.C#A_MN,
                         O.C#B_MN,
                         NULL "C#C_VOL",
                         NULL "C#C_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'MC' THEN O_VD.C#SUM END "C#MC_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'M' THEN O_VD.C#SUM END "C#M_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'MP' THEN O_VD.C#SUM END "C#MP_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'P' THEN O_VD.C#SUM END "C#P_SUM"
                    FROM T#OP O,
                         T#OP_VD O_VD
                    WHERE 1 = 1
                      AND O.C#ACCOUNT_ID = IN_LS
                      AND O_VD.C#ID = O.C#ID
                      AND O_VD.C#VN = (SELECT MAX(C#VN)
                          FROM T#OP_VD
                          WHERE C#ID = O_VD.C#ID)
                      AND O_VD.C#VALID_TAG = 'Y') a
                WHERE a.C#A_MN <= IN_A_MN
                GROUP BY A.C#A_MN,
                         A.C#B_MN,
                         A.C#WORK_ID,
                         A.C#DOER_ID
                HAVING SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) <> 0) a
            ORDER BY CASE WHEN a.to_pay < 0 THEN 0 ELSE 1 END,
                     a.c#a_mn,
                     a.c#b_mn,
                     a.c#work_id,
                     a.c#doer_id;
      kind_id  NUMBER;
      A#DATE   DATE;
      w_id     NUMBER;
      w1_id    NUMBER;
      d1_id    NUMBER;
      d_id     NUMBER;
      ops_id   NUMBER;
      op_id    NUMBER;
      ostatok  NUMBER;
      A_MN     NUMBER;
      per_num  NUMBER;
      pay_date DATE;

    BEGIN
      A#DATE := sysdate;
      A_MN := fcr.p#mn_utils.GET#MN(a#in_date);
      FOR c IN pay(a#in_file_id)
      LOOP

        IF c.c#real_date < fcr.p#mn_utils.GET#DATE(A_MN)
        THEN
          pay_date := fcr.p#mn_utils.GET#DATE(A_MN);
        ELSE
          pay_date := c.c#real_date;
        END IF;

        SELECT ok.c#id
          INTO kind_id
          FROM fcr.t#ops_kind ok
          WHERE ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc, '00'));

        SELECT MAX(a.C#WORK_ID),
               MAX(a.C#DOER_ID)
          INTO w_id,
               d_id
          FROM (SELECT WS.C#SERVICE_ID
                       -- ,W.C#WORKS_ID
                       ,
                       W.C#ID AS c#WORK_ID
                       --      ,W_VD.C#TAR_TYPE_TAG
                       --      ,W_VD.C#TAR_VAL
                       ,
                       D_VD.C#DOER_ID,
                       ROW_NUMBER() OVER (PARTITION BY D.C#house_Id ORDER BY d.c#date DESC, NVL(d_vd.c#end_date, TO_DATE('01.01.2222', 'dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
              FROM T#DOING D,
                   T#DOING_VD D_VD,
                   T#WORK W,
                   T#WORK_VD W_VD,
                   T#WORKS WS
              WHERE 1 = 1
                AND D.C#HOUSE_ID = (SELECT R.C#HOUSE_ID
                    FROM T#ACCOUNT A,
                         T#ROOMS R
                    WHERE A.C#ID = c.acc_id
                      AND R.C#ID = A.C#ROOMS_ID)
                AND D.C#DATE = (SELECT MAX(C#DATE)
                    FROM T#DOING
                    WHERE C#HOUSE_ID = D.C#HOUSE_ID
                      AND C#WORKS_ID = D.C#WORKS_ID
                      AND C#DATE <= A#DATE)
                AND D_VD.C#ID = D.C#ID
                AND D_VD.C#VN = (SELECT MAX(C#VN)
                    FROM T#DOING_VD
                    WHERE C#ID = D_VD.C#ID)
                AND D_VD.C#VALID_TAG = 'Y'
                --             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
                AND W.C#WORKS_ID = D.C#WORKS_ID
                AND W.C#DATE = (SELECT MAX(C#DATE)
                    FROM T#WORK
                    WHERE C#WORKS_ID = W.C#WORKS_ID
                      AND C#DATE < A#DATE)
                AND W_VD.C#ID = W.C#ID
                AND W_VD.C#VN = (SELECT MAX(C#VN)
                    FROM T#WORK_VD
                    WHERE C#ID = W_VD.C#ID)
                AND W_VD.C#VALID_TAG = 'Y'
                AND WS.C#ID = W.C#WORKS_ID) a
          WHERE a.sort_order = 1
        ;
        --dbms_output.put_line('w_id = '||w_id);
        IF w_id IS NOT NULL
        THEN

          INSERT INTO fcr.t#ops (
            c#id
          )
          VALUES (fcr.s#ops.NEXTVAL) RETURNING c#id INTO ops_id;

          --dbms_output.put_line('ops_id = '||ops_id);


          INSERT INTO t#ops_vd (
            c#id, c#vn, c#valid_tag, c#kind_id
          )
          VALUES (ops_id, 1, 'Y', kind_id);

          ostatok := c.c#summa;
          IF ostatok > 0
          THEN

            --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

            FOR d IN nach(c.acc_id, a_mn)
            LOOP

              IF ostatok > 0
              THEN

                IF d.to_pay < ostatok
                THEN
                  INSERT INTO fcr.t#op (
                    c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                  )
                  VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                  INSERT INTO fcr.t#op_vd (
                    c#id, c#vn, c#valid_tag, c#sum
                  )
                  VALUES (op_id, 1, 'Y', d.to_pay);
                  ostatok := ostatok - d.to_pay;
                ELSE
                  INSERT INTO fcr.t#op (
                    c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                  )
                  VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                  INSERT INTO fcr.t#op_vd (
                    c#id, c#vn, c#valid_tag, c#sum
                  )
                  VALUES (op_id, 1, 'Y', ostatok);
                  ostatok := 0;
                END IF;
              END IF;
            END LOOP;

            IF ostatok > 0
            THEN --Если остались деньги после всех распределений
              --dbms_output.put_line('Остаток после всех распределений = '||ostatok);  


              BEGIN
                SELECT c#work_id,
                       c#doer_id
                  INTO w1_id,
                       d1_id
                  FROM (SELECT ch.C#WORK_ID,
                               ch.C#DOER_ID,
                               ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                      FROM fcr.v#chop ch
                      WHERE ch.C#ACCOUNT_ID = c.acc_id
                        AND ch.C#A_MN = a_mn --a_mn+1
                        AND (ch.C#C_SUM IS NOT NULL
                        OR ch.C#P_SUM IS NOT NULL))
                  WHERE sort_order = 1
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN BEGIN
                      w1_id := w_id;
                      d1_id := d_id;
                    END;
              END;

              INSERT INTO fcr.t#op (
                c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
              )
              VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn, a_mn, 'P')
              -- values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
              RETURNING c#id INTO op_id;

              INSERT INTO fcr.t#op_vd (
                c#id, c#vn, c#valid_tag, c#sum
              )
              VALUES (op_id, 1, 'Y', ostatok);

            END IF;



          ELSE --Отрицательная оплата  

            BEGIN
              SELECT c#work_id,
                     c#doer_id
                INTO w1_id,
                     d1_id
                FROM (SELECT ch.C#WORK_ID,
                             ch.C#DOER_ID,
                             ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                    FROM fcr.v#chop ch
                    WHERE ch.C#ACCOUNT_ID = c.acc_id
                      AND ch.C#A_MN = a_mn --a_mn+1
                      AND (ch.C#C_SUM IS NOT NULL
                      OR ch.C#P_SUM IS NOT NULL))
                WHERE sort_order = 1
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN BEGIN
                    w1_id := w_id;
                    d1_id := d_id;
                  END;
            END;

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn, a_mn, 'P')
            --   values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
            RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', ostatok);
          END IF;
          UPDATE fcr.t#pay_source f
            SET f.c#transfer_flg = 2, f.c#ops_id = ops_id, f.c#kind_id = kind_id, f.c#date = pay_date
            WHERE 1 = 1
            AND f.c#id = c.c#id;


          IF NVL(c.c#fine, 0) <> 0
          THEN --есть пени

            per_num := fcr.p#mn_utils.GET#MN(TO_DATE(c.c#period, 'mmyy'));

            BEGIN
              SELECT c#work_id,
                     c#doer_id
                INTO w1_id,
                     d1_id
                FROM (SELECT ch.C#WORK_ID,
                             ch.C#DOER_ID,
                             ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                    FROM fcr.v#chop ch
                    WHERE ch.C#ACCOUNT_ID = c.acc_id
                      AND ch.C#A_MN = per_num
                      AND (ch.C#C_SUM IS NOT NULL
                      OR ch.C#P_SUM IS NOT NULL))
                WHERE sort_order = 1
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN BEGIN
                    w1_id := w_id;
                    d1_id := d_id;
                  END;
            END;

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FC') RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', c.c#fine);

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FP') RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', c.c#fine);

          END IF;


        END IF;
        COMMIT;
      END LOOP;
      RETURN 1;
    END Distr_Data_Not_Active_Account;

  FUNCTION Distr_Data_Bank_Account(a#in_file_id NUMBER,
                                   a#in_date    DATE)
    RETURN NUMBER
    AS
      CURSOR pay (in_file_id NUMBER) IS
          SELECT t.c#id,
                 t.c#acc_id_tter AS acc_id,
                 t.c#summa,
                 t.c#cod_rkc,
                 t.c#real_date,
                 t.c#fine,
                 t.c#period
            FROM fcr.t#pay_source t
            WHERE t.c#acc_id_tter IS NOT NULL
              AND ((in_file_id = -1)
              OR t.c#file_id = in_file_id)
              AND t.c#ops_id IS NULL
            ORDER BY 2,
                     5,
                     1;
      CURSOR nach (in_ls IN NUMBER, in_a_mn IN NUMBER) IS

          SELECT a.*
            FROM (SELECT A.C#WORK_ID,
                         A.C#DOER_ID,
                         A.C#A_MN,
                         A.C#B_MN,
                         SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) TO_PAY
                FROM (SELECT C.C#WORK_ID,
                             C.C#DOER_ID,
                             C.C#A_MN,
                             C.C#B_MN,
                             C.C#VOL "C#C_VOL",
                             C.C#SUM "C#C_SUM",
                             NULL "C#MC_SUM",
                             NULL "C#M_SUM",
                             NULL "C#MP_SUM",
                             NULL "C#P_SUM"
                    FROM T#CHARGE C
                    WHERE 1 = 1
                      AND C.C#ACCOUNT_ID = in_LS
                    UNION ALL
                  SELECT O.C#WORK_ID,
                         O.C#DOER_ID,
                         O.C#A_MN,
                         O.C#B_MN,
                         NULL "C#C_VOL",
                         NULL "C#C_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'MC' THEN O_VD.C#SUM END "C#MC_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'M' THEN O_VD.C#SUM END "C#M_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'MP' THEN O_VD.C#SUM END "C#MP_SUM",
                         CASE WHEN O.C#TYPE_TAG = 'P' THEN O_VD.C#SUM END "C#P_SUM"
                    FROM T#OP O,
                         T#OP_VD O_VD
                    WHERE 1 = 1
                      AND O.C#ACCOUNT_ID = in_LS
                      AND O_VD.C#ID = O.C#ID
                      AND O_VD.C#VN = (SELECT MAX(C#VN)
                          FROM T#OP_VD
                          WHERE C#ID = O_VD.C#ID)
                      AND O_VD.C#VALID_TAG = 'Y') a
                WHERE a.C#A_MN <= in_A_MN
                GROUP BY A.C#A_MN,
                         A.C#B_MN,
                         A.C#WORK_ID,
                         A.C#DOER_ID
                HAVING SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) <> 0) a
            ORDER BY CASE WHEN a.to_pay < 0 THEN 0 ELSE 1 END,
                     a.c#a_mn,
                     a.c#b_mn,
                     a.c#work_id,
                     a.c#doer_id;
      kind_id  NUMBER;
      A#DATE   DATE;
      w_id     NUMBER;
      w1_id    NUMBER;
      d1_id    NUMBER;
      d_id     NUMBER;
      ops_id   NUMBER;
      op_id    NUMBER;
      ostatok  NUMBER;
      A_MN     NUMBER;
      per_num  NUMBER;
      pay_date DATE;

    BEGIN
      A#DATE := sysdate;
      A_MN := fcr.p#mn_utils.GET#MN(a#in_date);
      FOR c IN pay(a#in_file_id)
      LOOP

        IF c.c#real_date < fcr.p#mn_utils.GET#DATE(A_MN)
        THEN
          pay_date := fcr.p#mn_utils.GET#DATE(A_MN);
        ELSE
          pay_date := c.c#real_date;
        END IF;

        SELECT ok.c#id
          INTO kind_id
          FROM fcr.t#ops_kind ok
          WHERE ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc, '00'));

        SELECT MAX(a.C#WORK_ID),
               MAX(a.C#DOER_ID)
          INTO w_id,
               d_id
          FROM (SELECT WS.C#SERVICE_ID
                       -- ,W.C#WORKS_ID
                       ,
                       W.C#ID AS c#WORK_ID
                       --      ,W_VD.C#TAR_TYPE_TAG
                       --      ,W_VD.C#TAR_VAL
                       ,
                       D_VD.C#DOER_ID,
                       ROW_NUMBER() OVER (PARTITION BY D.C#house_Id ORDER BY d.c#date DESC, NVL(d_vd.c#end_date, TO_DATE('01.01.2222', 'dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
              FROM T#DOING D,
                   T#DOING_VD D_VD,
                   T#WORK W,
                   T#WORK_VD W_VD,
                   T#WORKS WS
              WHERE 1 = 1
                AND D.C#HOUSE_ID = (SELECT R.C#HOUSE_ID
                    FROM T#ACCOUNT A,
                         T#ROOMS R
                    WHERE A.C#ID = c.acc_id
                      AND R.C#ID = A.C#ROOMS_ID)
                AND D.C#DATE = (SELECT MAX(C#DATE)
                    FROM T#DOING
                    WHERE C#HOUSE_ID = D.C#HOUSE_ID
                      AND C#WORKS_ID = D.C#WORKS_ID
                      AND C#DATE <= A#DATE)
                AND D_VD.C#ID = D.C#ID
                AND D_VD.C#VN = (SELECT MAX(C#VN)
                    FROM T#DOING_VD
                    WHERE C#ID = D_VD.C#ID)
                AND D_VD.C#VALID_TAG = 'Y'
                --             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
                AND W.C#WORKS_ID = D.C#WORKS_ID
                AND W.C#DATE = (SELECT MAX(C#DATE)
                    FROM T#WORK
                    WHERE C#WORKS_ID = W.C#WORKS_ID
                      AND C#DATE < A#DATE)
                AND W_VD.C#ID = W.C#ID
                AND W_VD.C#VN = (SELECT MAX(C#VN)
                    FROM T#WORK_VD
                    WHERE C#ID = W_VD.C#ID)
                AND W_VD.C#VALID_TAG = 'Y'
                AND WS.C#ID = W.C#WORKS_ID) a
          WHERE a.sort_order = 1
        ;
        --dbms_output.put_line('w_id = '||w_id);
        IF w_id IS NOT NULL
        THEN

          INSERT INTO fcr.t#ops (
            c#id
          )
          VALUES (fcr.s#ops.NEXTVAL) RETURNING c#id INTO ops_id;

          --dbms_output.put_line('ops_id = '||ops_id);


          INSERT INTO t#ops_vd (
            c#id, c#vn, c#valid_tag, c#kind_id
          )
          VALUES (ops_id, 1, 'Y', kind_id);

          ostatok := c.c#summa;
          IF ostatok > 0
          THEN

            --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

            FOR d IN nach(c.acc_id, a_mn)
            LOOP

              IF ostatok > 0
              THEN

                IF d.to_pay < ostatok
                THEN
                  INSERT INTO fcr.t#op (
                    c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                  )
                  VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                  INSERT INTO fcr.t#op_vd (
                    c#id, c#vn, c#valid_tag, c#sum
                  )
                  VALUES (op_id, 1, 'Y', d.to_pay);
                  ostatok := ostatok - d.to_pay;
                ELSE
                  INSERT INTO fcr.t#op (
                    c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                  )
                  VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                  INSERT INTO fcr.t#op_vd (
                    c#id, c#vn, c#valid_tag, c#sum
                  )
                  VALUES (op_id, 1, 'Y', ostatok);
                  ostatok := 0;
                END IF;
              END IF;
            END LOOP;

            IF ostatok > 0
            THEN --Если остались деньги после всех распределений
              --dbms_output.put_line('Остаток после всех распределений = '||ostatok);  


              BEGIN
                SELECT c#work_id,
                       c#doer_id
                  INTO w1_id,
                       d1_id
                  FROM (SELECT ch.C#WORK_ID,
                               ch.C#DOER_ID,
                               ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                      FROM fcr.v#chop ch
                      WHERE ch.C#ACCOUNT_ID = c.acc_id
                        AND ch.C#A_MN = a_mn   -- a_mn+1
                        AND (ch.C#C_SUM IS NOT NULL
                        OR ch.C#P_SUM IS NOT NULL))
                  WHERE sort_order = 1
                ;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN BEGIN
                      w1_id := w_id;
                      d1_id := d_id;
                    END;
              END;

              INSERT INTO fcr.t#op (
                c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
              )
              VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn, a_mn, 'P')
              --   values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
              RETURNING c#id INTO op_id;

              INSERT INTO fcr.t#op_vd (
                c#id, c#vn, c#valid_tag, c#sum
              )
              VALUES (op_id, 1, 'Y', ostatok);

            END IF;

          ELSE --Отрицательная оплата  

            BEGIN
              SELECT c#work_id,
                     c#doer_id
                INTO w1_id,
                     d1_id
                FROM (SELECT ch.C#WORK_ID,
                             ch.C#DOER_ID,
                             ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                    FROM fcr.v#chop ch
                    WHERE ch.C#ACCOUNT_ID = c.acc_id
                      AND ch.C#A_MN = a_mn  -- a_mn+1
                      AND (ch.C#C_SUM IS NOT NULL
                      OR ch.C#P_SUM IS NOT NULL))
                WHERE sort_order = 1
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN BEGIN
                    w1_id := w_id;
                    d1_id := d_id;
                  END;
            END;

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn, a_mn, 'P')
            --   values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')	 
            RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', ostatok);
          END IF;
          UPDATE fcr.t#pay_source f
            SET f.c#transfer_flg = 3, f.c#ops_id = ops_id, f.c#kind_id = kind_id, f.c#date = pay_date
            WHERE 1 = 1
            AND f.c#id = c.c#id;


          IF NVL(c.c#fine, 0) <> 0
          THEN --есть пени

            per_num := fcr.p#mn_utils.GET#MN(TO_DATE(c.c#period, 'mmyy'));

            BEGIN
              SELECT c#work_id,
                     c#doer_id
                INTO w1_id,
                     d1_id
                FROM (SELECT ch.C#WORK_ID,
                             ch.C#DOER_ID,
                             ROW_NUMBER() OVER (PARTITION BY ch.C#ACCOUNT_ID ORDER BY ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


                    FROM fcr.v#chop ch
                    WHERE ch.C#ACCOUNT_ID = c.acc_id
                      AND ch.C#A_MN = per_num
                      AND (ch.C#C_SUM IS NOT NULL
                      OR ch.C#P_SUM IS NOT NULL))
                WHERE sort_order = 1
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN BEGIN
                    w1_id := w_id;
                    d1_id := d_id;
                  END;
            END;

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FC') RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', c.c#fine);

            INSERT INTO fcr.t#op (
              c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
            )
            VALUES (fcr.s#op.NEXTVAL, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FP') RETURNING c#id INTO op_id;

            INSERT INTO fcr.t#op_vd (
              c#id, c#vn, c#valid_tag, c#sum
            )
            VALUES (op_id, 1, 'Y', c.c#fine);

          END IF;


        END IF;
        COMMIT;
      END LOOP;
      RETURN 1;
    END Distr_Data_Bank_Account;


  PROCEDURE ExecAllFunction(a#in_file_id NUMBER,
                            a#in_date    DATE)
    AS
      ret NUMBER;
    BEGIN
      ret := Fill_Active_Account(a#in_file_id);

      IF (ret = 1)
      THEN
        dbms_output.put_line('Загрузка активных счетов');
      ELSE
        dbms_output.put_line('Ошибка Загрузки активных счетов');
      END IF;
      ret := Fill_Not_Active_Account(a#in_file_id);
      IF (ret = 1)
      THEN
        dbms_output.put_line('Загрузка не активных счетов');
      ELSE
        dbms_output.put_line('Ошибка Загрузки не активных счетов');
      END IF;
      ret := Fill_Bank_Account(a#in_file_id);
      IF (ret = 1)
      THEN
        dbms_output.put_line('Загрузка ЛС ТТЭР счетов');
      ELSE
        dbms_output.put_line('Ошибка Загрузки ЛС ТТЭР счетов');
      END IF;


      ret := Distr_Data_Active_Account(a#in_file_id, a#in_date);
      IF (ret = 1)
      THEN
        dbms_output.put_line('Распределение активных счетов');
      ELSE
        dbms_output.put_line('Ошибка Распределения активных счетов');
      END IF;
      ret := Distr_Data_Not_Active_Account(a#in_file_id, a#in_date);
      IF (ret = 1)
      THEN
        dbms_output.put_line('Распределение не активных счетов');
      ELSE
        dbms_output.put_line('Ошибка Распределения не активных счетов');
      END IF;
      ret := Distr_Data_Bank_Account(a#in_file_id, a#in_date);
      IF (ret = 1)
      THEN
        dbms_output.put_line('Распределение ЛС ТТЭР счетов');
      ELSE
        dbms_output.put_line('Ошибка Распределения ЛС ТТЭР счетов');
      END IF;

    END;


    PROCEDURE ExecAllFunctionCycle as
    begin
        FOR new_acc_rec IN (
            select distinct
                C#FILE_ID
            from
                T#PAY_SOURCE P
            where
                C#OPS_ID is null
                and C#ACCOUNT in (select C#OUT_NUM from T#ACCOUNT_OP union select c#num from T#ACCOUNT)
            order by     
                c#file_id --desc
        )            
        
        LOOP
            BEGIN
                P#FCR_LOAD_OUTER_DATA.ExecAllFunction (  A#IN_FILE_ID => new_acc_rec.c#file_id, A#IN_DATE => sysdate); 
                COMMIT;
            END;        
        END LOOP;
    end;


  PROCEDURE Filling_these_municipalities
    AS
    BEGIN
      fcr.do#2;
      fcr.do#2_1;
      fcr.do#3;
    END;


END P#FCR_LOAD_OUTER_DATA;
/
