CREATE OR REPLACE PACKAGE P#CLOSE_MN
  IS

  -- Author  : ALEXANDER
  -- Created : 27.10.2016 16:05:18

  -- Purpose : процедуры закрытия месяца 

  a#err VARCHAR(4000);

  PROCEDURE DO#BALANCE_ACCOUNT;
  PROCEDURE DO#BALANCE_BANK_ACCOUNT;
  PROCEDURE DO#OVERPAYMENT;
  PROCEDURE DO#PAGE_TWO;
  PROCEDURE DO#PAGE_THREE;
  PROCEDURE DO#ALL;

END P#CLOSE_MN;

/


CREATE OR REPLACE PACKAGE BODY P#CLOSE_MN
  IS

  PROCEDURE DO#BALANCE_ACCOUNT
    IS
      a#id NUMBER;
    BEGIN
      FOR A#MN IN fcr.p#utils.GET#OPEN_MN .. fcr.p#utils.GET#OPEN_MN
      LOOP
        dbms_stats.gather_schema_stats(ownname => 'FCR',
        cascade => TRUE,
        options => 'GATHER AUTO');
        FOR CR#I IN (SELECT t.c#id,
                            t.c#num
            FROM fcr.t#account t
            ORDER BY 1)
        LOOP
          BEGIN
            a#id := CR#I.C#ID;
            DO#CALC_CHARGE(CR#I.C#ID, A#MN, A#MN, A#MN);
            DO#CALC_STORE(CR#I.C#ID, A#MN + 1);
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN ROLLBACK;
                a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
                P#EXCEPTION.LOG#EXCEPTION('P#CLOSE_MN', 'DO#BALANCE_ACCOUNT', a#err, CR#I.c#num);
          END;
        END LOOP;
      END LOOP;

    END;

  PROCEDURE DO#BALANCE_BANK_ACCOUNT
    IS
      a#id NUMBER;
    BEGIN
      FOR A#MN IN fcr.p#utils.GET#OPEN_B_MN .. fcr.p#utils.GET#OPEN_B_MN
      LOOP
        dbms_stats.gather_schema_stats(ownname => 'FCR',
        cascade => TRUE,
        options => 'GATHER AUTO');
        FOR CR#I IN (SELECT T.C#ID
            FROM T#HOUSE T
            ORDER BY 1)
        LOOP
          BEGIN
            a#id := CR#I.C#ID;
            DO#CALC_B_STORE(CR#I.C#ID, A#MN + 1);
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN ROLLBACK;
                a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
                P#EXCEPTION.LOG#EXCEPTION('P#CLOSE_MN', 'DO#BALANCE_ACCOUNT', a#err, TO_CHAR(a#id));

          END;
        END LOOP;
      END LOOP;
    END;

  PROCEDURE DO#OVERPAYMENT
    IS
      CURSOR pay (p#a_mn NUMBER) IS
          SELECT ch.C#ACCOUNT_ID,
                 ch.C#WORK_ID,
                 ch.C#DOER_ID,
                 ch.C#A_MN,
                 ch.C#B_MN,
                 SUM(NVL(ch.C#C_SUM, 0) + NVL(ch.C#MC_SUM, 0) +
                 NVL(ch.C#M_SUM, 0)) to_pay,
                 SUM(NVL(ch.C#MP_SUM, 0) + NVL(ch.C#P_SUM, 0)) pay,
                 SUM(NVL(ch.C#C_SUM, 0) + NVL(ch.C#MC_SUM, 0) +
                 NVL(ch.C#M_SUM, 0)) -
                 SUM(NVL(ch.C#MP_SUM, 0) + NVL(ch.C#P_SUM, 0)) t_p
            FROM fcr.v#chop ch
            WHERE ch.C#A_MN <= p#a_mn
            GROUP BY ch.C#ACCOUNT_ID,
                     ch.C#WORK_ID,
                     ch.C#DOER_ID,
                     ch.C#A_MN,
                     ch.C#B_MN
            HAVING SUM(NVL(ch.C#C_SUM, 0) + NVL(ch.C#MC_SUM, 0) + NVL(ch.C#M_SUM, 0)) - SUM(NVL(ch.C#MP_SUM, 0) + NVL(ch.C#P_SUM, 0)) < 0
            ORDER BY 1,
                     2,
                     3,
                     4,
                     5;

      CURSOR nach (ls IN NUMBER, p#a_mn IN NUMBER) IS
          SELECT a.*
            FROM (SELECT A.C#WORK_ID,
                         A.C#DOER_ID,
                         A.C#A_MN,
                         A.C#B_MN,
                         SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) +
                         NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) -
                         NVL(C#P_SUM, 0)) TO_PAY
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
                      AND C.C#ACCOUNT_ID = LS
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
                      AND O.C#ACCOUNT_ID = LS
                      AND O_VD.C#ID = O.C#ID
                      AND O_VD.C#VN = (SELECT MAX(C#VN)
                          FROM T#OP_VD
                          WHERE C#ID = O_VD.C#ID)
                      AND O_VD.C#VALID_TAG = 'Y') a
                WHERE a.C#A_MN <= p#a_mn
                GROUP BY A.C#A_MN,
                         A.C#B_MN,
                         A.C#WORK_ID,
                         A.C#DOER_ID
                HAVING SUM(NVL(A.C#C_SUM, 0) + NVL(A.C#MC_SUM, 0) + NVL(A.C#M_SUM, 0) - NVL(A.C#MP_SUM, 0) - NVL(C#P_SUM, 0)) > 0) a
            ORDER BY a.c#a_mn,
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
      A_MN := fcr.p#utils.GET#OPEN_MN;

      FOR c IN pay(A_MN)
      LOOP
        BEGIN
          pay_date := LAST_DAY(fcr.p#mn_utils.GET#DATE(A_MN));

          SELECT ok.c#id
            INTO kind_id
            FROM fcr.t#ops_kind ok
            WHERE ok.c#cod = '99';

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
                      WHERE A.C#ID = c.C#ACCOUNT_ID
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
            WHERE a.sort_order = 1;
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

            ostatok := -1 * c.t_p;
            IF ostatok > 0
            THEN

              --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

              FOR d IN nach(c.c#account_id, a_mn)
              LOOP

                IF ostatok > 0
                THEN

                  IF d.to_pay < ostatok
                  THEN
                    --Забираем переплату
                    INSERT INTO fcr.t#op (
                      c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                    )
                    VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#account_id, c.c#work_id, c.c#doer_id, pay_date, pay_date, c.c#a_mn, c.c#b_mn, 'P') RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                      c#id, c#vn, c#valid_tag, c#sum
                    )
                    VALUES (op_id, 1, 'Y', -1 * d.to_pay);
                    --Забираем переплату

                    --Ставим переплату                             
                    INSERT INTO fcr.t#op (
                      c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                    )
                    VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#account_id, d.c#work_id, d.c#doer_id, pay_date, pay_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                      c#id, c#vn, c#valid_tag, c#sum
                    )
                    VALUES (op_id, 1, 'Y', d.to_pay);
                    --Ставим переплату             
                    ostatok := ostatok - d.to_pay;
                  ELSE
                    --Забираем переплату        
                    INSERT INTO fcr.t#op (
                      c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                    )
                    VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#account_id, c.c#work_id, C.C#DOER_ID, pay_date, pay_date, c.c#a_mn, c.c#b_mn, 'P') RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                      c#id, c#vn, c#valid_tag, c#sum
                    )
                    VALUES (op_id, 1, 'Y', -1 * ostatok);
                    --Забираем переплату

                    --Ставим переплату  
                    INSERT INTO fcr.t#op (
                      c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                    )
                    VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#account_id, d.c#work_id, d.c#doer_id, pay_date, pay_date, d.c#a_mn, d.c#b_mn, 'P') RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                      c#id, c#vn, c#valid_tag, c#sum
                    )
                    VALUES (op_id, 1, 'Y', ostatok);
                    --Ставим переплату             
                    ostatok := 0;
                  END IF;
                END IF;
              END LOOP;
              
              IF nach%ISOPEN  THEN  CLOSE nach;  END IF;

              IF ostatok > 0
              THEN
                --Если остались деньги после всех распределений
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
                        WHERE ch.C#ACCOUNT_ID = c.c#account_id
                          AND ch.C#A_MN = a_mn + 1
                          AND (ch.C#C_SUM IS NOT NULL
                          OR ch.C#P_SUM IS NOT NULL))
                    WHERE sort_order = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN BEGIN
                        w1_id := w_id;
                        d1_id := d_id;
                      END;
                END;
                --Забираем переплату
                INSERT INTO fcr.t#op (
                  c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                )
                VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#account_id, c.c#work_id, C.C#DOER_ID, pay_date, pay_date, c.c#a_mn, c.c#b_mn, 'P') RETURNING c#id INTO op_id;

                INSERT INTO fcr.t#op_vd (
                  c#id, c#vn, c#valid_tag, c#sum
                )
                VALUES (op_id, 1, 'Y', -1 * ostatok);
                --Забираем переплату

                --Ставим переплату 
                INSERT INTO fcr.t#op (
                  c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag
                )
                VALUES (fcr.s#op.NEXTVAL, ops_id, c.c#account_id, w1_id, d1_id, pay_date, pay_date, a_mn + 1, a_mn + 1, 'P') RETURNING c#id INTO op_id;

                INSERT INTO fcr.t#op_vd (
                  c#id, c#vn, c#valid_tag, c#sum
                )
                VALUES (op_id, 1, 'Y', ostatok);
              --Ставим переплату  
              END IF;
            END IF;
          END IF;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN ROLLBACK;
              a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
              P#EXCEPTION.LOG#EXCEPTION('P#CLOSE_MN', 'DO#OVERPAYMENT', a#err, TO_CHAR(c.c#account_id));
        END;
      END LOOP;
    END;

  PROCEDURE DO#PAGE_TWO
    IS
      CURSOR close_month IS
          SELECT h.c#id AS house_id,
                 s.c#id AS service_id
            FROM fcr.t#house h,
                 fcr.t#service s;
      cl_id  NUMBER;
      v_n    NUMBER;
      new_mn NUMBER;
    BEGIN

      new_mn := fcr.p#utils.GET#OPEN_MN + 1;

      FOR c IN close_month
      LOOP
        BEGIN
          SELECT MAX(t.c#id)
            INTO cl_id
            FROM fcr.t#close t
            WHERE t.c#house_id = c.house_id
              AND t.c#service_id = c.service_id;

          IF cl_id IS NULL
          THEN
            INSERT INTO fcr.t#close (
              c#id, c#house_id, c#service_id
            )
            VALUES (fcr.s#close.NEXTVAL, c.house_id, c.service_id) RETURNING c#id INTO cl_id;
            INSERT INTO fcr.t#close_vd (
              c#id, c#vn, c#valid_tag, c#mn
            )
            VALUES (cl_id, 1, 'Y', new_mn);
          ELSE
            SELECT NVL(MAX(tvd.c#vn), 0) + 1
              INTO v_n
              FROM fcr.t#close_vd tvd
              WHERE tvd.c#id = cl_id;
            INSERT INTO fcr.t#close_vd (
              c#id, c#vn, c#valid_tag, c#mn
            )
            VALUES (cl_id, v_n, 'Y', new_mn);
          END IF;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN ROLLBACK;
              a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
              P#EXCEPTION.LOG#EXCEPTION('P#CLOSE_MN', 'DO#PAGE_TWO', a#err, TO_CHAR(c.house_id) || ' ' || TO_CHAR(c.service_id));
        END;
      END LOOP;

    END;

  PROCEDURE DO#PAGE_THREE
    IS
      CURSOR close_month IS
          SELECT h.c#id AS house_id,
                 s.c#id AS service_id
            FROM fcr.t#house h,
                 fcr.t#service s;
      cl_id  NUMBER;
      v_n    NUMBER;
      new_mn NUMBER;
    BEGIN
      new_mn := fcr.p#utils.GET#OPEN_B_MN + 1;

      FOR c IN close_month
      LOOP
        BEGIN
          SELECT MAX(t.c#id)
            INTO cl_id
            FROM fcr.t#b_close t
            WHERE t.c#house_id = c.house_id
              AND t.c#service_id = c.service_id;

          IF cl_id IS NULL
          THEN
            INSERT INTO fcr.t#b_close (
              c#id, c#house_id, c#service_id
            )
            VALUES (fcr.s#b_close.NEXTVAL, c.house_id, c.service_id) RETURNING c#id INTO cl_id;
            INSERT INTO fcr.t#b_close_vd (
              c#id, c#vn, c#valid_tag, c#mn
            )
            VALUES (cl_id, 1, 'Y', new_mn);
          ELSE
            SELECT NVL(MAX(tvd.c#vn), 0) + 1
              INTO v_n
              FROM fcr.t#b_close_vd tvd
              WHERE tvd.c#id = cl_id;
            INSERT INTO fcr.t#b_close_vd (
              c#id, c#vn, c#valid_tag, c#mn
            )
            VALUES (cl_id, v_n, 'Y', new_mn);
          END IF;
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN ROLLBACK;
              a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
              P#EXCEPTION.LOG#EXCEPTION('P#CLOSE_MN', 'DO#PAGE_TWO', a#err, TO_CHAR(c.house_id) || ' ' || TO_CHAR(c.service_id));
        END;
      END LOOP;
    END;

  PROCEDURE DO#ALL
    IS
    BEGIN
      DO#BALANCE_ACCOUNT;
      DO#BALANCE_BANK_ACCOUNT;
      DO#OVERPAYMENT;
      DO#PAGE_TWO;
      DO#PAGE_THREE;
    END;

END P#CLOSE_MN;
/
