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

  PROCEDURE ExecAllFunctionCycleAuto;

--function Distr_Data_Active_Account(a#in_file_id number, a#in_date date)return number;
--function Distr_Data_Not_Active_Account(a#in_file_id number, a#in_date date)  return number;
--function Distr_Data_Bank_Account(a#in_file_id number, a#in_date date)  return number;

END P#FCR_LOAD_OUTER_DATA;
/


CREATE OR REPLACE PACKAGE BODY "P#FCR_LOAD_OUTER_DATA" AS

    PROCEDURE ins#mass_pay (
        a#person_id    INTEGER,
        a#date         DATE,
        a#sum          NUMBER,
        a#living_tag   VARCHAR2,
        a#npd          VARCHAR2,
        a#cod_rkc      VARCHAR2,
        a#comment      VARCHAR2
    ) IS
        a#hash    VARCHAR2(1000);
        a#exist   INTEGER;
    BEGIN
        a#hash := a#person_id
        || TO_CHAR(a#date,'dd.mm.yyyy')
        || a#sum
        || a#npd
        || a#cod_rkc;

        SELECT
            COUNT(*)
        INTO
            a#exist
        FROM
            fcr.t#mass_pay
        WHERE
            ( c#person_id
            || TO_CHAR(c#date,'dd.mm.yyyy')
            || c#sum
            || c#npd
            || c#cod_rkc ) = a#hash;

        IF
            a#exist = 0
        THEN
            INSERT INTO fcr.t#mass_pay (
                c#person_id,
                c#date,
                c#sum,
                c#living_tag,
                c#npd,
                c#cod_rkc,
                c#comment
            ) VALUES (
                a#person_id,
                a#date,
                a#sum,
                a#living_tag,
                a#npd,
                a#cod_rkc,
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
                'INS#MASS_PAY',
                SYSDATE,
                a#err,
                TO_CHAR(a#person_id)
            );

            ROLLBACK;
    END ins#mass_pay;

    PROCEDURE ins#kotel_other_prih (
        a#pl_sum    IN NUMBER,
        a#pl_date   IN DATE,
        a#comm      VARCHAR2
    ) IS
        a#hash    VARCHAR2(1000);
        a#exist   INTEGER;
    BEGIN
        a#hash := TO_CHAR(a#pl_sum)
        || TO_CHAR(a#pl_date,'dd.mm.yyyy')
        || a#comm;

        SELECT
            COUNT(*)
        INTO
            a#exist
        FROM
            fcr.kotel_other_prih
        WHERE
            ( TO_CHAR(pl_sum)
            || TO_CHAR(pl_date,'dd.mm.yyyy')
            || comm ) = a#hash;

        IF
            a#exist = 0
        THEN
            INSERT INTO fcr.kotel_other_prih (
                pl_sum,
                pl_date,
                comm
            ) VALUES (
                a#pl_sum,
                a#pl_date,
                a#comm
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
                'INS#KOTEL_OTHER_PRIH',
                SYSDATE,
                a#err,
                a#comm
            );

            ROLLBACK;
    END ins#kotel_other_prih;

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
                replace(TO_CHAR(a#pay),'.',','),
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

    FUNCTION fill_active_account (
        a#in_file_id NUMBER
    ) RETURN NUMBER AS

        CURSOR ls_pay (
            in_file_id IN NUMBER
        ) IS SELECT
            t.c#id,
            fcr.get_acc_for_pay(t.c#account,t.c#real_date) AS acc_id
             FROM
            fcr.t#pay_source t
             WHERE
            1 = 1
            AND   t.c#file_id = in_file_id
            AND   t.c#acc_id IS NULL
            AND   c#ops_id IS NULL
            AND   c#account IS NOT NULL;

    BEGIN
        FOR c IN ls_pay(a#in_file_id) LOOP
            UPDATE fcr.t#pay_source f
                SET
                    f.c#acc_id = c.acc_id
            WHERE
                f.c#id = c.c#id;

        END LOOP;

        RETURN 1;
    END fill_active_account;

  /** 
  * Author  : Гридасов Алексей ( модификации ALEXANDER )
  */

    FUNCTION fill_not_active_account (
        a#in_file_id NUMBER
    ) RETURN NUMBER AS

        CURSOR ls_pay (
            in_file_id IN NUMBER
        ) IS SELECT
            t.c#id,
            fcr.get_acc_for_pay_any(t.c#account,t.c#real_date) AS acc_id_close
             FROM
            fcr.t#pay_source t
             WHERE
            1 = 1
            AND   t.c#file_id = in_file_id
            AND   t.c#acc_id IS NULL
            AND   c#ops_id IS NULL
            AND   c#account IS NOT NULL;

    BEGIN
        FOR c IN ls_pay(a#in_file_id) LOOP
            UPDATE fcr.t#pay_source f
                SET
                    f.c#acc_id_close = c.acc_id_close
            WHERE
                f.c#id = c.c#id;

        END LOOP;

        RETURN 1;
    END fill_not_active_account;

    FUNCTION fill_bank_account (
        a#in_file_id NUMBER
    ) RETURN NUMBER AS

        CURSOR ls_pay (
            in_file_id NUMBER
        ) IS SELECT
            fp.c#id,
            fcr.get_acc_for_pay_tter(fp.c#account,fp.c#real_date) AS acc_id_tter
             FROM
            (
                SELECT
                    fp.*,
                    (
                        SELECT
                            MAX(op.c#out_num)
                        FROM
                            fcr.t#account_op op
                        WHERE
                            1 = 1
                            AND   op.c#out_num LIKE '%'
                            || fp.c#account
                            AND   op.c#out_proc_id = 2
                    ) AS ls_new
                FROM
                    fcr.t#pay_source fp
                WHERE
                    fp.c#acc_id IS NULL
                    AND   fp.c#acc_id_close IS NULL
                    AND   c#ops_id IS NULL
                  ---------------
                    AND   fp.c#file_id = in_file_id
                  ---------------
                    AND   fp.c#cod_rkc IN (
                        51,
                        52
                    )
                    AND   EXISTS (
                        SELECT
                            1
                        FROM
                            fcr.t#account_op op
                        WHERE
                            1 = 1
                            AND   op.c#out_num LIKE '%'
                            || fp.c#account
                            AND   op.c#out_proc_id = 2
                    )
                    AND   length(fp.c#account) > 8
                    AND   (
                        SELECT
                            COUNT(op.c#out_num)
                        FROM
                            fcr.t#account_op op
                        WHERE
                            1 = 1
                            AND   op.c#out_num LIKE '%'
                            || fp.c#account
                            AND   op.c#out_proc_id = 2
                    ) = 1
            ) fp;

    BEGIN
        FOR c IN ls_pay(a#in_file_id) LOOP
            UPDATE fcr.t#pay_source f
                SET
                    f.c#acc_id_tter = c.acc_id_tter
            WHERE
                f.c#id = c.c#id;

        END LOOP;

        RETURN 1;
    END fill_bank_account;

    FUNCTION distr_data_active_account (
        a#in_file_id NUMBER,
        a#in_date DATE
    ) RETURN NUMBER AS

        CURSOR pay (
            in_file_id NUMBER
        ) IS SELECT --t.sort_order, t.acc_id, t.summ_pl, t.cod_rkc, t.data_pl, t.fine, t.period
            t.c#id,
            t.c#acc_id,
            t.c#summa,
            t.c#cod_rkc,
            t.c#real_date,
            t.c#fine,
            t.c#period
             FROM
            fcr.t#pay_source t
             WHERE
            t.c#acc_id IS NOT NULL
            AND   t.c#file_id = in_file_id
            AND   t.c#ops_id IS NULL
        ORDER BY
            2,
            5,
            1;

        CURSOR nach (
            in_ls     IN NUMBER,
            in_a_mn   IN NUMBER
        ) IS SELECT
            a.*
             FROM
            (
                SELECT
                    a.c#work_id,
                    a.c#doer_id,
                    a.c#a_mn,
                    a.c#b_mn,
                    SUM(nvl(a.c#c_sum,0) + nvl(a.c#mc_sum,0) + nvl(a.c#m_sum,0) - nvl(a.c#mp_sum,0) - nvl(c#p_sum,0) ) to_pay
                FROM
                    (
                        SELECT
                            c.c#work_id,
                            c.c#doer_id,
                            c.c#a_mn,
                            c.c#b_mn,
                            c.c#vol "C#C_VOL",
                            c.c#sum "C#C_SUM",
                            NULL "C#MC_SUM",
                            NULL "C#M_SUM",
                            NULL "C#MP_SUM",
                            NULL "C#P_SUM"
                        FROM
                            t#charge c
                        WHERE
                            1 = 1
                            AND   c.c#account_id = in_ls
                        UNION ALL
                        SELECT
                            o.c#work_id,
                            o.c#doer_id,
                            o.c#a_mn,
                            o.c#b_mn,
                            NULL "C#C_VOL",
                            NULL "C#C_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'MC' THEN o_vd.c#sum
                                END
                            "C#MC_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'M' THEN o_vd.c#sum
                                END
                            "C#M_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'MP' THEN o_vd.c#sum
                                END
                            "C#MP_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'P' THEN o_vd.c#sum
                                END
                            "C#P_SUM"
                        FROM
                            t#op o,
                            t#op_vd o_vd
                        WHERE
                            1 = 1
                            AND   o.c#account_id = in_ls
                            AND   o_vd.c#id = o.c#id
                            AND   o_vd.c#vn = (
                                SELECT
                                    MAX(c#vn)
                                FROM
                                    t#op_vd
                                WHERE
                                    c#id = o_vd.c#id
                            )
                            AND   o_vd.c#valid_tag = 'Y'
                    ) a
                WHERE
                    a.c#a_mn <= in_a_mn
                GROUP BY
                    a.c#a_mn,
                    a.c#b_mn,
                    a.c#work_id,
                    a.c#doer_id
                HAVING
                    SUM(nvl(a.c#c_sum,0) + nvl(a.c#mc_sum,0) + nvl(a.c#m_sum,0) - nvl(a.c#mp_sum,0) - nvl(c#p_sum,0) ) <> 0
            ) a
        ORDER BY
            CASE
                WHEN a.to_pay < 0 THEN 0
                ELSE 1
            END,
            a.c#a_mn,
            a.c#b_mn,
            a.c#work_id,
            a.c#doer_id;

        kind_id    NUMBER;
        a#date     DATE;
        w_id       NUMBER;
        w1_id      NUMBER;
        d1_id      NUMBER;
        d_id       NUMBER;
        ops_id     NUMBER;
        op_id      NUMBER;
        ostatok    NUMBER;
        a_mn       NUMBER;
        per_num    NUMBER;
        pay_date   DATE;
    BEGIN
        a#date := SYSDATE;
        a_mn := fcr.p#mn_utils.get#mn(a#in_date);
        FOR c IN pay(a#in_file_id) LOOP
        --dbms_output.put_line('Сумма для распределения = '||c.c#summa|| ' дата = '||c.c#real_date || ' cod_rkc : '|| c.c#cod_rkc);
            IF
                c.c#real_date < fcr.p#mn_utils.get#date(a_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(a_mn);
            ELSE
                pay_date := c.c#real_date;
            END IF;

        --dbms_output.put_line('sort_order = '||c.sort_order);

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc,'00') )
                OR   ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc,'000') );

            SELECT
                MAX(a.c#work_id),
                MAX(a.c#doer_id)
            INTO
                w_id,d_id
            FROM
                (
                    SELECT
                        ws.c#service_id
                       -- ,W.C#WORKS_ID
                       ,
                        w.c#id AS c#work_id
                       -- ,W_VD.C#TAR_TYPE_TAG
                       -- ,W_VD.C#TAR_VAL
                       ,
                        d_vd.c#doer_id,
                        ROW_NUMBER() OVER(
                            PARTITION BY d.c#house_id
                            ORDER BY
                                d.c#date DESC,
                                nvl(d_vd.c#end_date,TO_DATE('01.01.2222','dd.mm.yyyy') ),
                                d.c#works_id,
                                d_vd.c#doer_id
                        ) sort_order
                    FROM
                        t#doing d,
                        t#doing_vd d_vd,
                        t#work w,
                        t#work_vd w_vd,
                        t#works ws
                    WHERE
                        1 = 1
                        AND   d.c#house_id = (
                            SELECT
                                r.c#house_id
                            FROM
                                t#account a,
                                t#rooms r
                            WHERE
                                a.c#id = c.c#acc_id
                                AND   r.c#id = a.c#rooms_id
                        )
                        AND   d.c#date = (
                            SELECT
                                MAX(c#date)
                            FROM
                                t#doing
                            WHERE
                                c#house_id = d.c#house_id
                                AND   c#works_id = d.c#works_id
                                AND   c#date <= a#date
                        )
                        AND   d_vd.c#id = d.c#id
                        AND   d_vd.c#vn = (
                            SELECT
                                MAX(c#vn)
                            FROM
                                t#doing_vd
                            WHERE
                                c#id = d_vd.c#id
                        )
                        AND   d_vd.c#valid_tag = 'Y'
                --             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
                        AND   w.c#works_id = d.c#works_id
                        AND   w.c#date = (
                            SELECT
                                MAX(c#date)
                            FROM
                                t#work
                            WHERE
                                c#works_id = w.c#works_id
                                AND   c#date < a#date
                        )
                        AND   w_vd.c#id = w.c#id
                        AND   w_vd.c#vn = (
                            SELECT
                                MAX(c#vn)
                            FROM
                                t#work_vd
                            WHERE
                                c#id = w_vd.c#id
                        )
                        AND   w_vd.c#valid_tag = 'Y'
                        AND   ws.c#id = w.c#works_id
                ) a
            WHERE
                a.sort_order = 1;
        --dbms_output.put_line('w_id = '||w_id);

            IF
                w_id IS NOT NULL
            THEN
                INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;

          --dbms_output.put_line('ops_id = '||ops_id);

                INSERT INTO t#ops_vd (
                    c#id,
                    c#vn,
                    c#valid_tag,
                    c#kind_id
                ) VALUES (
                    ops_id,
                    1,
                    'Y',
                    kind_id
                );

                ostatok := c.c#summa;
                IF
                    ostatok > 0
                THEN

            --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.c#real_date);
                    FOR d IN nach(c.c#acc_id,a_mn) LOOP
                        IF
                            ostatok > 0
                        THEN
                            IF
                                d.to_pay < ostatok
                            THEN
                                INSERT INTO fcr.t#op (
                                    c#id,
                                    c#ops_id,
                                    c#account_id,
                                    c#work_id,
                                    c#doer_id,
                                    c#date,
                                    c#real_date,
                                    c#a_mn,
                                    c#b_mn,
                                    c#type_tag
                                ) VALUES (
                                    fcr.s#op.nextval,
                                    ops_id,
                                    c.c#acc_id,
                                    d.c#work_id,
                                    d.c#doer_id,
                                    pay_date,
                                    c.c#real_date,
                                    d.c#a_mn,
                                    d.c#b_mn,
                                    'P'
                                ) RETURNING c#id INTO op_id;

                                INSERT INTO fcr.t#op_vd (
                                    c#id,
                                    c#vn,
                                    c#valid_tag,
                                    c#sum
                                ) VALUES (
                                    op_id,
                                    1,
                                    'Y',
                                    d.to_pay
                                );

                                ostatok := ostatok - d.to_pay;
                            ELSE
                                INSERT INTO fcr.t#op (
                                    c#id,
                                    c#ops_id,
                                    c#account_id,
                                    c#work_id,
                                    c#doer_id,
                                    c#date,
                                    c#real_date,
                                    c#a_mn,
                                    c#b_mn,
                                    c#type_tag
                                ) VALUES (
                                    fcr.s#op.nextval,
                                    ops_id,
                                    c.c#acc_id,
                                    d.c#work_id,
                                    d.c#doer_id,
                                    pay_date,
                                    c.c#real_date,
                                    d.c#a_mn,
                                    d.c#b_mn,
                                    'P'
                                ) RETURNING c#id INTO op_id;

                                INSERT INTO fcr.t#op_vd (
                                    c#id,
                                    c#vn,
                                    c#valid_tag,
                                    c#sum
                                ) VALUES (
                                    op_id,
                                    1,
                                    'Y',
                                    ostatok
                                );

                                ostatok := 0;
                            END IF;

                        END IF;
                    END LOOP;

                    IF
                        ostatok > 0
                    THEN --Если остались деньги после всех распределений
              --dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
                        BEGIN
                            SELECT
                                c#work_id,
                                c#doer_id
                            INTO
                                w1_id,d1_id
                            FROM
                                (
                                    SELECT
                                        ch.c#work_id,
                                        ch.c#doer_id,
                                        ROW_NUMBER() OVER(
                                            PARTITION BY ch.c#account_id
                                            ORDER BY
                                                ch.c#mn,
                                                ch.c#b_mn,
                                                ch.c#work_id,
                                                ch.c#doer_id
                                        ) sort_order
                                    FROM
                                        fcr.v#chop ch
                                    WHERE
                                        ch.c#account_id = c.c#acc_id
                                        AND   ch.c#a_mn = a_mn --a_mn+1
                                        AND   (
                                            ch.c#c_sum IS NOT NULL
                                            OR    ch.c#p_sum IS NOT NULL
                                        )
                                )
                            WHERE
                                sort_order = 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                BEGIN
                                    w1_id := w_id;
                                    d1_id := d_id;
                                END;
                        END;

                        INSERT INTO fcr.t#op (
                            c#id,
                            c#ops_id,
                            c#account_id,
                            c#work_id,
                            c#doer_id,
                            c#date,
                            c#real_date,
                            c#a_mn,
                            c#b_mn,
                            c#type_tag
                        ) VALUES (
                            fcr.s#op.nextval,
                            ops_id,
                            c.c#acc_id,
                            w1_id,
                            d1_id,
                            pay_date,
                            c.c#real_date,
                            a_mn,
                            a_mn,
                            'P'
                        )
              --   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')	 
                         RETURNING c#id INTO op_id;

                        INSERT INTO fcr.t#op_vd (
                            c#id,
                            c#vn,
                            c#valid_tag,
                            c#sum
                        ) VALUES (
                            op_id,
                            1,
                            'Y',
                            ostatok
                        );

                    END IF;

                ELSE --Отрицательная оплата  
                    BEGIN
                        SELECT
                            c#work_id,
                            c#doer_id
                        INTO
                            w1_id,d1_id
                        FROM
                            (
                                SELECT
                                    ch.c#work_id,
                                    ch.c#doer_id,
                                    ROW_NUMBER() OVER(
                                        PARTITION BY ch.c#account_id
                                        ORDER BY
                                            ch.c#mn,
                                            ch.c#b_mn,
                                            ch.c#work_id,
                                            ch.c#doer_id
                                    ) sort_order
                                FROM
                                    fcr.v#chop ch
                                WHERE
                                    ch.c#account_id = c.c#acc_id
                                    AND   ch.c#a_mn = a_mn -- a_mn+1
                                    AND   (
                                        ch.c#c_sum IS NOT NULL
                                        OR    ch.c#p_sum IS NOT NULL
                                    )
                            )
                        WHERE
                            sort_order = 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            BEGIN
                                w1_id := w_id;
                                d1_id := d_id;
                            END;
                    END;

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.c#acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        a_mn,
                        a_mn,
                        'P'
                    )
            --   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
                     RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        ostatok
                    );

                END IF;

                UPDATE fcr.t#pay_source f
                    SET
                        f.c#transfer_flg = 1,
                        f.c#ops_id = ops_id,
                        f.c#kind_id = kind_id,
                        f.c#date = pay_date
                WHERE
                    1 = 1
                    AND   f.c#id = c.c#id;

                IF
                    nvl(c.c#fine,0) <> 0
                THEN --есть пени
                    per_num := fcr.p#mn_utils.get#mn(TO_DATE(c.c#period,'mmyy') );

                    BEGIN
                        SELECT
                            c#work_id,
                            c#doer_id
                        INTO
                            w1_id,d1_id
                        FROM
                            (
                                SELECT
                                    ch.c#work_id,
                                    ch.c#doer_id,
                                    ROW_NUMBER() OVER(
                                        PARTITION BY ch.c#account_id
                                        ORDER BY
                                            ch.c#mn,
                                            ch.c#b_mn,
                                            ch.c#work_id,
                                            ch.c#doer_id
                                    ) sort_order
                                FROM
                                    fcr.v#chop ch
                                WHERE
                                    ch.c#account_id = c.c#acc_id
                                    AND   ch.c#a_mn = per_num
                                    AND   (
                                        ch.c#c_sum IS NOT NULL
                                        OR    ch.c#p_sum IS NOT NULL
                                    )
                            )
                        WHERE
                            sort_order = 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            BEGIN
                                w1_id := w_id;
                                d1_id := d_id;
                            END;
                    END;

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.c#acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        per_num,
                        per_num,
                        'FC'
                    ) RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        c.c#fine
                    );

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.c#acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        per_num,
                        per_num,
                        'FP'
                    ) RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        c.c#fine
                    );

                END IF;

            END IF;

            COMMIT;
        END LOOP;

        RETURN 1;
    END distr_data_active_account;

    FUNCTION distr_data_not_active_account (
        a#in_file_id NUMBER,
        a#in_date DATE
    ) RETURN NUMBER AS

        CURSOR pay (
            in_file_id NUMBER
        ) IS SELECT
            t.c#id,
            t.c#acc_id_close AS acc_id,
            t.c#summa,
            t.c#cod_rkc,
            t.c#real_date,
            t.c#fine,
            t.c#period
             FROM
            fcr.t#pay_source t
             WHERE
            t.c#acc_id_close IS NOT NULL
            AND    t.c#file_id = in_file_id
            AND   t.c#ops_id IS NULL
        ORDER BY
            2,
            5,
            1;

        CURSOR nach (
            in_ls     IN NUMBER,
            in_a_mn   IN NUMBER
        ) IS SELECT
            a.*
             FROM
            (
                SELECT
                    a.c#work_id,
                    a.c#doer_id,
                    a.c#a_mn,
                    a.c#b_mn,
                    SUM(nvl(a.c#c_sum,0) + nvl(a.c#mc_sum,0) + nvl(a.c#m_sum,0) - nvl(a.c#mp_sum,0) - nvl(c#p_sum,0) ) to_pay
                FROM
                    (
                        SELECT
                            c.c#work_id,
                            c.c#doer_id,
                            c.c#a_mn,
                            c.c#b_mn,
                            c.c#vol "C#C_VOL",
                            c.c#sum "C#C_SUM",
                            NULL "C#MC_SUM",
                            NULL "C#M_SUM",
                            NULL "C#MP_SUM",
                            NULL "C#P_SUM"
                        FROM
                            t#charge c
                        WHERE
                            1 = 1
                            AND   c.c#account_id = in_ls
                        UNION ALL
                        SELECT
                            o.c#work_id,
                            o.c#doer_id,
                            o.c#a_mn,
                            o.c#b_mn,
                            NULL "C#C_VOL",
                            NULL "C#C_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'MC' THEN o_vd.c#sum
                                END
                            "C#MC_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'M' THEN o_vd.c#sum
                                END
                            "C#M_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'MP' THEN o_vd.c#sum
                                END
                            "C#MP_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'P' THEN o_vd.c#sum
                                END
                            "C#P_SUM"
                        FROM
                            t#op o,
                            t#op_vd o_vd
                        WHERE
                            1 = 1
                            AND   o.c#account_id = in_ls
                            AND   o_vd.c#id = o.c#id
                            AND   o_vd.c#vn = (
                                SELECT
                                    MAX(c#vn)
                                FROM
                                    t#op_vd
                                WHERE
                                    c#id = o_vd.c#id
                            )
                            AND   o_vd.c#valid_tag = 'Y'
                    ) a
                WHERE
                    a.c#a_mn <= in_a_mn
                GROUP BY
                    a.c#a_mn,
                    a.c#b_mn,
                    a.c#work_id,
                    a.c#doer_id
                HAVING
                    SUM(nvl(a.c#c_sum,0) + nvl(a.c#mc_sum,0) + nvl(a.c#m_sum,0) - nvl(a.c#mp_sum,0) - nvl(c#p_sum,0) ) <> 0
            ) a
        ORDER BY
            CASE
                WHEN a.to_pay < 0 THEN 0
                ELSE 1
            END,
            a.c#a_mn,
            a.c#b_mn,
            a.c#work_id,
            a.c#doer_id;

        kind_id    NUMBER;
        a#date     DATE;
        w_id       NUMBER;
        w1_id      NUMBER;
        d1_id      NUMBER;
        d_id       NUMBER;
        ops_id     NUMBER;
        op_id      NUMBER;
        ostatok    NUMBER;
        a_mn       NUMBER;
        per_num    NUMBER;
        pay_date   DATE;
    BEGIN
        a#date := SYSDATE;
        a_mn := fcr.p#mn_utils.get#mn(a#in_date);
        FOR c IN pay(a#in_file_id) LOOP
            IF
                c.c#real_date < fcr.p#mn_utils.get#date(a_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(a_mn);
            ELSE
                pay_date := c.c#real_date;
            END IF;

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc,'00') )
                OR   ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc,'000') );

            SELECT
                MAX(a.c#work_id),
                MAX(a.c#doer_id)
            INTO
                w_id,d_id
            FROM
                (
                    SELECT
                        ws.c#service_id
                       -- ,W.C#WORKS_ID
                       ,
                        w.c#id AS c#work_id
                       -- ,W_VD.C#TAR_TYPE_TAG
                       -- ,W_VD.C#TAR_VAL
                       ,
                        d_vd.c#doer_id,
                        ROW_NUMBER() OVER(
                            PARTITION BY d.c#house_id
                            ORDER BY
                                d.c#date DESC,
                                nvl(d_vd.c#end_date,TO_DATE('01.01.2222','dd.mm.yyyy') ),
                                d.c#works_id,
                                d_vd.c#doer_id
                        ) sort_order
                    FROM
                        t#doing d,
                        t#doing_vd d_vd,
                        t#work w,
                        t#work_vd w_vd,
                        t#works ws
                    WHERE
                        1 = 1
                        AND   d.c#house_id = (
                            SELECT
                                r.c#house_id
                            FROM
                                t#account a,
                                t#rooms r
                            WHERE
                                a.c#id = c.acc_id
                                AND   r.c#id = a.c#rooms_id
                        )
                        AND   d.c#date = (
                            SELECT
                                MAX(c#date)
                            FROM
                                t#doing
                            WHERE
                                c#house_id = d.c#house_id
                                AND   c#works_id = d.c#works_id
                                AND   c#date <= a#date
                        )
                        AND   d_vd.c#id = d.c#id
                        AND   d_vd.c#vn = (
                            SELECT
                                MAX(c#vn)
                            FROM
                                t#doing_vd
                            WHERE
                                c#id = d_vd.c#id
                        )
                        AND   d_vd.c#valid_tag = 'Y'
                --             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
                        AND   w.c#works_id = d.c#works_id
                        AND   w.c#date = (
                            SELECT
                                MAX(c#date)
                            FROM
                                t#work
                            WHERE
                                c#works_id = w.c#works_id
                                AND   c#date < a#date
                        )
                        AND   w_vd.c#id = w.c#id
                        AND   w_vd.c#vn = (
                            SELECT
                                MAX(c#vn)
                            FROM
                                t#work_vd
                            WHERE
                                c#id = w_vd.c#id
                        )
                        AND   w_vd.c#valid_tag = 'Y'
                        AND   ws.c#id = w.c#works_id
                ) a
            WHERE
                a.sort_order = 1;
        --dbms_output.put_line('w_id = '||w_id);

            IF
                w_id IS NOT NULL
            THEN
                INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;

          --dbms_output.put_line('ops_id = '||ops_id);

                INSERT INTO t#ops_vd (
                    c#id,
                    c#vn,
                    c#valid_tag,
                    c#kind_id
                ) VALUES (
                    ops_id,
                    1,
                    'Y',
                    kind_id
                );

                ostatok := c.c#summa;
                IF
                    ostatok > 0
                THEN

            --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);
                    FOR d IN nach(c.acc_id,a_mn) LOOP
                        IF
                            ostatok > 0
                        THEN
                            IF
                                d.to_pay < ostatok
                            THEN
                                INSERT INTO fcr.t#op (
                                    c#id,
                                    c#ops_id,
                                    c#account_id,
                                    c#work_id,
                                    c#doer_id,
                                    c#date,
                                    c#real_date,
                                    c#a_mn,
                                    c#b_mn,
                                    c#type_tag
                                ) VALUES (
                                    fcr.s#op.nextval,
                                    ops_id,
                                    c.acc_id,
                                    d.c#work_id,
                                    d.c#doer_id,
                                    pay_date,
                                    c.c#real_date,
                                    d.c#a_mn,
                                    d.c#b_mn,
                                    'P'
                                ) RETURNING c#id INTO op_id;

                                INSERT INTO fcr.t#op_vd (
                                    c#id,
                                    c#vn,
                                    c#valid_tag,
                                    c#sum
                                ) VALUES (
                                    op_id,
                                    1,
                                    'Y',
                                    d.to_pay
                                );

                                ostatok := ostatok - d.to_pay;
                            ELSE
                                INSERT INTO fcr.t#op (
                                    c#id,
                                    c#ops_id,
                                    c#account_id,
                                    c#work_id,
                                    c#doer_id,
                                    c#date,
                                    c#real_date,
                                    c#a_mn,
                                    c#b_mn,
                                    c#type_tag
                                ) VALUES (
                                    fcr.s#op.nextval,
                                    ops_id,
                                    c.acc_id,
                                    d.c#work_id,
                                    d.c#doer_id,
                                    pay_date,
                                    c.c#real_date,
                                    d.c#a_mn,
                                    d.c#b_mn,
                                    'P'
                                ) RETURNING c#id INTO op_id;

                                INSERT INTO fcr.t#op_vd (
                                    c#id,
                                    c#vn,
                                    c#valid_tag,
                                    c#sum
                                ) VALUES (
                                    op_id,
                                    1,
                                    'Y',
                                    ostatok
                                );

                                ostatok := 0;
                            END IF;

                        END IF;
                    END LOOP;

                    IF
                        ostatok > 0
                    THEN --Если остались деньги после всех распределений
              --dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
                        BEGIN
                            SELECT
                                c#work_id,
                                c#doer_id
                            INTO
                                w1_id,d1_id
                            FROM
                                (
                                    SELECT
                                        ch.c#work_id,
                                        ch.c#doer_id,
                                        ROW_NUMBER() OVER(
                                            PARTITION BY ch.c#account_id
                                            ORDER BY
                                                ch.c#mn,
                                                ch.c#b_mn,
                                                ch.c#work_id,
                                                ch.c#doer_id
                                        ) sort_order
                                    FROM
                                        fcr.v#chop ch
                                    WHERE
                                        ch.c#account_id = c.acc_id
                                        AND   ch.c#a_mn = a_mn --a_mn+1
                                        AND   (
                                            ch.c#c_sum IS NOT NULL
                                            OR    ch.c#p_sum IS NOT NULL
                                        )
                                )
                            WHERE
                                sort_order = 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                BEGIN
                                    w1_id := w_id;
                                    d1_id := d_id;
                                END;
                        END;

                        INSERT INTO fcr.t#op (
                            c#id,
                            c#ops_id,
                            c#account_id,
                            c#work_id,
                            c#doer_id,
                            c#date,
                            c#real_date,
                            c#a_mn,
                            c#b_mn,
                            c#type_tag
                        ) VALUES (
                            fcr.s#op.nextval,
                            ops_id,
                            c.acc_id,
                            w1_id,
                            d1_id,
                            pay_date,
                            c.c#real_date,
                            a_mn,
                            a_mn,
                            'P'
                        )
              -- values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
                         RETURNING c#id INTO op_id;

                        INSERT INTO fcr.t#op_vd (
                            c#id,
                            c#vn,
                            c#valid_tag,
                            c#sum
                        ) VALUES (
                            op_id,
                            1,
                            'Y',
                            ostatok
                        );

                    END IF;

                ELSE --Отрицательная оплата  
                    BEGIN
                        SELECT
                            c#work_id,
                            c#doer_id
                        INTO
                            w1_id,d1_id
                        FROM
                            (
                                SELECT
                                    ch.c#work_id,
                                    ch.c#doer_id,
                                    ROW_NUMBER() OVER(
                                        PARTITION BY ch.c#account_id
                                        ORDER BY
                                            ch.c#mn,
                                            ch.c#b_mn,
                                            ch.c#work_id,
                                            ch.c#doer_id
                                    ) sort_order
                                FROM
                                    fcr.v#chop ch
                                WHERE
                                    ch.c#account_id = c.acc_id
                                    AND   ch.c#a_mn = a_mn --a_mn+1
                                    AND   (
                                        ch.c#c_sum IS NOT NULL
                                        OR    ch.c#p_sum IS NOT NULL
                                    )
                            )
                        WHERE
                            sort_order = 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            BEGIN
                                w1_id := w_id;
                                d1_id := d_id;
                            END;
                    END;

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        a_mn,
                        a_mn,
                        'P'
                    )
            --   values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
                     RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        ostatok
                    );

                END IF;

                UPDATE fcr.t#pay_source f
                    SET
                        f.c#transfer_flg = 2,
                        f.c#ops_id = ops_id,
                        f.c#kind_id = kind_id,
                        f.c#date = pay_date
                WHERE
                    1 = 1
                    AND   f.c#id = c.c#id;

                IF
                    nvl(c.c#fine,0) <> 0
                THEN --есть пени
                    per_num := fcr.p#mn_utils.get#mn(TO_DATE(c.c#period,'mmyy') );

                    BEGIN
                        SELECT
                            c#work_id,
                            c#doer_id
                        INTO
                            w1_id,d1_id
                        FROM
                            (
                                SELECT
                                    ch.c#work_id,
                                    ch.c#doer_id,
                                    ROW_NUMBER() OVER(
                                        PARTITION BY ch.c#account_id
                                        ORDER BY
                                            ch.c#mn,
                                            ch.c#b_mn,
                                            ch.c#work_id,
                                            ch.c#doer_id
                                    ) sort_order
                                FROM
                                    fcr.v#chop ch
                                WHERE
                                    ch.c#account_id = c.acc_id
                                    AND   ch.c#a_mn = per_num
                                    AND   (
                                        ch.c#c_sum IS NOT NULL
                                        OR    ch.c#p_sum IS NOT NULL
                                    )
                            )
                        WHERE
                            sort_order = 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            BEGIN
                                w1_id := w_id;
                                d1_id := d_id;
                            END;
                    END;

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        per_num,
                        per_num,
                        'FC'
                    ) RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        c.c#fine
                    );

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        per_num,
                        per_num,
                        'FP'
                    ) RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        c.c#fine
                    );

                END IF;

            END IF;

            COMMIT;
        END LOOP;

        RETURN 1;
    END distr_data_not_active_account;

    FUNCTION distr_data_bank_account (
        a#in_file_id NUMBER,
        a#in_date DATE
    ) RETURN NUMBER AS

        CURSOR pay (
            in_file_id NUMBER
        ) IS SELECT
            t.c#id,
            t.c#acc_id_tter AS acc_id,
            t.c#summa,
            t.c#cod_rkc,
            t.c#real_date,
            t.c#fine,
            t.c#period
             FROM
            fcr.t#pay_source t
             WHERE
            t.c#acc_id_tter IS NOT NULL
            AND  t.c#file_id = in_file_id
            AND   t.c#ops_id IS NULL
        ORDER BY
            2,
            5,
            1;

        CURSOR nach (
            in_ls     IN NUMBER,
            in_a_mn   IN NUMBER
        ) IS SELECT
            a.*
             FROM
            (
                SELECT
                    a.c#work_id,
                    a.c#doer_id,
                    a.c#a_mn,
                    a.c#b_mn,
                    SUM(nvl(a.c#c_sum,0) + nvl(a.c#mc_sum,0) + nvl(a.c#m_sum,0) - nvl(a.c#mp_sum,0) - nvl(c#p_sum,0) ) to_pay
                FROM
                    (
                        SELECT
                            c.c#work_id,
                            c.c#doer_id,
                            c.c#a_mn,
                            c.c#b_mn,
                            c.c#vol "C#C_VOL",
                            c.c#sum "C#C_SUM",
                            NULL "C#MC_SUM",
                            NULL "C#M_SUM",
                            NULL "C#MP_SUM",
                            NULL "C#P_SUM"
                        FROM
                            t#charge c
                        WHERE
                            1 = 1
                            AND   c.c#account_id = in_ls
                        UNION ALL
                        SELECT
                            o.c#work_id,
                            o.c#doer_id,
                            o.c#a_mn,
                            o.c#b_mn,
                            NULL "C#C_VOL",
                            NULL "C#C_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'MC' THEN o_vd.c#sum
                                END
                            "C#MC_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'M' THEN o_vd.c#sum
                                END
                            "C#M_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'MP' THEN o_vd.c#sum
                                END
                            "C#MP_SUM",
                            CASE
                                    WHEN o.c#type_tag = 'P' THEN o_vd.c#sum
                                END
                            "C#P_SUM"
                        FROM
                            t#op o,
                            t#op_vd o_vd
                        WHERE
                            1 = 1
                            AND   o.c#account_id = in_ls
                            AND   o_vd.c#id = o.c#id
                            AND   o_vd.c#vn = (
                                SELECT
                                    MAX(c#vn)
                                FROM
                                    t#op_vd
                                WHERE
                                    c#id = o_vd.c#id
                            )
                            AND   o_vd.c#valid_tag = 'Y'
                    ) a
                WHERE
                    a.c#a_mn <= in_a_mn
                GROUP BY
                    a.c#a_mn,
                    a.c#b_mn,
                    a.c#work_id,
                    a.c#doer_id
                HAVING
                    SUM(nvl(a.c#c_sum,0) + nvl(a.c#mc_sum,0) + nvl(a.c#m_sum,0) - nvl(a.c#mp_sum,0) - nvl(c#p_sum,0) ) <> 0
            ) a
        ORDER BY
            CASE
                WHEN a.to_pay < 0 THEN 0
                ELSE 1
            END,
            a.c#a_mn,
            a.c#b_mn,
            a.c#work_id,
            a.c#doer_id;

        kind_id    NUMBER;
        a#date     DATE;
        w_id       NUMBER;
        w1_id      NUMBER;
        d1_id      NUMBER;
        d_id       NUMBER;
        ops_id     NUMBER;
        op_id      NUMBER;
        ostatok    NUMBER;
        a_mn       NUMBER;
        per_num    NUMBER;
        pay_date   DATE;
    BEGIN
        a#date := SYSDATE;
        a_mn := fcr.p#mn_utils.get#mn(a#in_date);
        FOR c IN pay(a#in_file_id) LOOP
            IF
                c.c#real_date < fcr.p#mn_utils.get#date(a_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(a_mn);
            ELSE
                pay_date := c.c#real_date;
            END IF;

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc,'00') )
                OR   ok.c#cod = TRIM(TO_CHAR(c.c#cod_rkc,'000') );

            SELECT
                MAX(a.c#work_id),
                MAX(a.c#doer_id)
            INTO
                w_id,d_id
            FROM
                (
                    SELECT
                        ws.c#service_id
                       -- ,W.C#WORKS_ID
                       ,
                        w.c#id AS c#work_id
                       -- ,W_VD.C#TAR_TYPE_TAG
                       -- ,W_VD.C#TAR_VAL
                       ,
                        d_vd.c#doer_id,
                        ROW_NUMBER() OVER(
                            PARTITION BY d.c#house_id
                            ORDER BY
                                d.c#date DESC,
                                nvl(d_vd.c#end_date,TO_DATE('01.01.2222','dd.mm.yyyy') ),
                                d.c#works_id,
                                d_vd.c#doer_id
                        ) sort_order
                    FROM
                        t#doing d,
                        t#doing_vd d_vd,
                        t#work w,
                        t#work_vd w_vd,
                        t#works ws
                    WHERE
                        1 = 1
                        AND   d.c#house_id = (
                            SELECT
                                r.c#house_id
                            FROM
                                t#account a,
                                t#rooms r
                            WHERE
                                a.c#id = c.acc_id
                                AND   r.c#id = a.c#rooms_id
                        )
                        AND   d.c#date = (
                            SELECT
                                MAX(c#date)
                            FROM
                                t#doing
                            WHERE
                                c#house_id = d.c#house_id
                                AND   c#works_id = d.c#works_id
                                AND   c#date <= a#date
                        )
                        AND   d_vd.c#id = d.c#id
                        AND   d_vd.c#vn = (
                            SELECT
                                MAX(c#vn)
                            FROM
                                t#doing_vd
                            WHERE
                                c#id = d_vd.c#id
                        )
                        AND   d_vd.c#valid_tag = 'Y'
                --             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
                        AND   w.c#works_id = d.c#works_id
                        AND   w.c#date = (
                            SELECT
                                MAX(c#date)
                            FROM
                                t#work
                            WHERE
                                c#works_id = w.c#works_id
                                AND   c#date < a#date
                        )
                        AND   w_vd.c#id = w.c#id
                        AND   w_vd.c#vn = (
                            SELECT
                                MAX(c#vn)
                            FROM
                                t#work_vd
                            WHERE
                                c#id = w_vd.c#id
                        )
                        AND   w_vd.c#valid_tag = 'Y'
                        AND   ws.c#id = w.c#works_id
                ) a
            WHERE
                a.sort_order = 1;
        --dbms_output.put_line('w_id = '||w_id);

            IF
                w_id IS NOT NULL
            THEN
                INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;

          --dbms_output.put_line('ops_id = '||ops_id);

                INSERT INTO t#ops_vd (
                    c#id,
                    c#vn,
                    c#valid_tag,
                    c#kind_id
                ) VALUES (
                    ops_id,
                    1,
                    'Y',
                    kind_id
                );

                ostatok := c.c#summa;
                IF
                    ostatok > 0
                THEN

            --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);
                    FOR d IN nach(c.acc_id,a_mn) LOOP
                        IF
                            ostatok > 0
                        THEN
                            IF
                                d.to_pay < ostatok
                            THEN
                                INSERT INTO fcr.t#op (
                                    c#id,
                                    c#ops_id,
                                    c#account_id,
                                    c#work_id,
                                    c#doer_id,
                                    c#date,
                                    c#real_date,
                                    c#a_mn,
                                    c#b_mn,
                                    c#type_tag
                                ) VALUES (
                                    fcr.s#op.nextval,
                                    ops_id,
                                    c.acc_id,
                                    d.c#work_id,
                                    d.c#doer_id,
                                    pay_date,
                                    c.c#real_date,
                                    d.c#a_mn,
                                    d.c#b_mn,
                                    'P'
                                ) RETURNING c#id INTO op_id;

                                INSERT INTO fcr.t#op_vd (
                                    c#id,
                                    c#vn,
                                    c#valid_tag,
                                    c#sum
                                ) VALUES (
                                    op_id,
                                    1,
                                    'Y',
                                    d.to_pay
                                );

                                ostatok := ostatok - d.to_pay;
                            ELSE
                                INSERT INTO fcr.t#op (
                                    c#id,
                                    c#ops_id,
                                    c#account_id,
                                    c#work_id,
                                    c#doer_id,
                                    c#date,
                                    c#real_date,
                                    c#a_mn,
                                    c#b_mn,
                                    c#type_tag
                                ) VALUES (
                                    fcr.s#op.nextval,
                                    ops_id,
                                    c.acc_id,
                                    d.c#work_id,
                                    d.c#doer_id,
                                    pay_date,
                                    c.c#real_date,
                                    d.c#a_mn,
                                    d.c#b_mn,
                                    'P'
                                ) RETURNING c#id INTO op_id;

                                INSERT INTO fcr.t#op_vd (
                                    c#id,
                                    c#vn,
                                    c#valid_tag,
                                    c#sum
                                ) VALUES (
                                    op_id,
                                    1,
                                    'Y',
                                    ostatok
                                );

                                ostatok := 0;
                            END IF;

                        END IF;
                    END LOOP;

                    IF
                        ostatok > 0
                    THEN --Если остались деньги после всех распределений
              --dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
                        BEGIN
                            SELECT
                                c#work_id,
                                c#doer_id
                            INTO
                                w1_id,d1_id
                            FROM
                                (
                                    SELECT
                                        ch.c#work_id,
                                        ch.c#doer_id,
                                        ROW_NUMBER() OVER(
                                            PARTITION BY ch.c#account_id
                                            ORDER BY
                                                ch.c#mn,
                                                ch.c#b_mn,
                                                ch.c#work_id,
                                                ch.c#doer_id
                                        ) sort_order
                                    FROM
                                        fcr.v#chop ch
                                    WHERE
                                        ch.c#account_id = c.acc_id
                                        AND   ch.c#a_mn = a_mn   -- a_mn+1
                                        AND   (
                                            ch.c#c_sum IS NOT NULL
                                            OR    ch.c#p_sum IS NOT NULL
                                        )
                                )
                            WHERE
                                sort_order = 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                BEGIN
                                    w1_id := w_id;
                                    d1_id := d_id;
                                END;
                        END;

                        INSERT INTO fcr.t#op (
                            c#id,
                            c#ops_id,
                            c#account_id,
                            c#work_id,
                            c#doer_id,
                            c#date,
                            c#real_date,
                            c#a_mn,
                            c#b_mn,
                            c#type_tag
                        ) VALUES (
                            fcr.s#op.nextval,
                            ops_id,
                            c.acc_id,
                            w1_id,
                            d1_id,
                            pay_date,
                            c.c#real_date,
                            a_mn,
                            a_mn,
                            'P'
                        )
              --   values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')
                         RETURNING c#id INTO op_id;

                        INSERT INTO fcr.t#op_vd (
                            c#id,
                            c#vn,
                            c#valid_tag,
                            c#sum
                        ) VALUES (
                            op_id,
                            1,
                            'Y',
                            ostatok
                        );

                    END IF;

                ELSE --Отрицательная оплата  
                    BEGIN
                        SELECT
                            c#work_id,
                            c#doer_id
                        INTO
                            w1_id,d1_id
                        FROM
                            (
                                SELECT
                                    ch.c#work_id,
                                    ch.c#doer_id,
                                    ROW_NUMBER() OVER(
                                        PARTITION BY ch.c#account_id
                                        ORDER BY
                                            ch.c#mn,
                                            ch.c#b_mn,
                                            ch.c#work_id,
                                            ch.c#doer_id
                                    ) sort_order
                                FROM
                                    fcr.v#chop ch
                                WHERE
                                    ch.c#account_id = c.acc_id
                                    AND   ch.c#a_mn = a_mn  -- a_mn+1
                                    AND   (
                                        ch.c#c_sum IS NOT NULL
                                        OR    ch.c#p_sum IS NOT NULL
                                    )
                            )
                        WHERE
                            sort_order = 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            BEGIN
                                w1_id := w_id;
                                d1_id := d_id;
                            END;
                    END;

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        a_mn,
                        a_mn,
                        'P'
                    )
            --   values(fcr.s#op.nextval, ops_id, c.acc_id, w1_id, d1_id, pay_date, c.c#real_date, a_mn+1, a_mn+1, 'P')	 
                     RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        ostatok
                    );

                END IF;

                UPDATE fcr.t#pay_source f
                    SET
                        f.c#transfer_flg = 3,
                        f.c#ops_id = ops_id,
                        f.c#kind_id = kind_id,
                        f.c#date = pay_date
                WHERE
                    1 = 1
                    AND   f.c#id = c.c#id;

                IF
                    nvl(c.c#fine,0) <> 0
                THEN --есть пени
                    per_num := fcr.p#mn_utils.get#mn(TO_DATE(c.c#period,'mmyy') );

                    BEGIN
                        SELECT
                            c#work_id,
                            c#doer_id
                        INTO
                            w1_id,d1_id
                        FROM
                            (
                                SELECT
                                    ch.c#work_id,
                                    ch.c#doer_id,
                                    ROW_NUMBER() OVER(
                                        PARTITION BY ch.c#account_id
                                        ORDER BY
                                            ch.c#mn,
                                            ch.c#b_mn,
                                            ch.c#work_id,
                                            ch.c#doer_id
                                    ) sort_order
                                FROM
                                    fcr.v#chop ch
                                WHERE
                                    ch.c#account_id = c.acc_id
                                    AND   ch.c#a_mn = per_num
                                    AND   (
                                        ch.c#c_sum IS NOT NULL
                                        OR    ch.c#p_sum IS NOT NULL
                                    )
                            )
                        WHERE
                            sort_order = 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            BEGIN
                                w1_id := w_id;
                                d1_id := d_id;
                            END;
                    END;

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        per_num,
                        per_num,
                        'FC'
                    ) RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        c.c#fine
                    );

                    INSERT INTO fcr.t#op (
                        c#id,
                        c#ops_id,
                        c#account_id,
                        c#work_id,
                        c#doer_id,
                        c#date,
                        c#real_date,
                        c#a_mn,
                        c#b_mn,
                        c#type_tag
                    ) VALUES (
                        fcr.s#op.nextval,
                        ops_id,
                        c.acc_id,
                        w1_id,
                        d1_id,
                        pay_date,
                        c.c#real_date,
                        per_num,
                        per_num,
                        'FP'
                    ) RETURNING c#id INTO op_id;

                    INSERT INTO fcr.t#op_vd (
                        c#id,
                        c#vn,
                        c#valid_tag,
                        c#sum
                    ) VALUES (
                        op_id,
                        1,
                        'Y',
                        c.c#fine
                    );

                END IF;

            END IF;

            COMMIT;
        END LOOP;

        RETURN 1;
    END distr_data_bank_account;

    PROCEDURE execallfunction (
        a#in_file_id NUMBER,
        a#in_date DATE
    ) AS
        ret   NUMBER;
    BEGIN
        ret := fill_active_account(a#in_file_id);
        IF
            ( ret = 1 )
        THEN
            dbms_output.put_line('Загрузка активных счетов');
        ELSE
            dbms_output.put_line('Ошибка Загрузки активных счетов');
        END IF;

        ret := fill_not_active_account(a#in_file_id);
        IF
            ( ret = 1 )
        THEN
            dbms_output.put_line('Загрузка не активных счетов');
        ELSE
            dbms_output.put_line('Ошибка Загрузки не активных счетов');
        END IF;

        ret := fill_bank_account(a#in_file_id);
        IF
            ( ret = 1 )
        THEN
            dbms_output.put_line('Загрузка ЛС ТТЭР счетов');
        ELSE
            dbms_output.put_line('Ошибка Загрузки ЛС ТТЭР счетов');
        END IF;

        ret := distr_data_active_account(a#in_file_id,a#in_date);
        IF
            ( ret = 1 )
        THEN
            dbms_output.put_line('Распределение активных счетов');
        ELSE
            dbms_output.put_line('Ошибка Распределения активных счетов');
        END IF;

        ret := distr_data_not_active_account(a#in_file_id,a#in_date);
        IF
            ( ret = 1 )
        THEN
            dbms_output.put_line('Распределение не активных счетов');
        ELSE
            dbms_output.put_line('Ошибка Распределения не активных счетов');
        END IF;

        ret := distr_data_bank_account(a#in_file_id,a#in_date);
        IF
            ( ret = 1 )
        THEN
            dbms_output.put_line('Распределение ЛС ТТЭР счетов');
        ELSE
            dbms_output.put_line('Ошибка Распределения ЛС ТТЭР счетов');
        END IF;

    END;


    PROCEDURE execallfunctioncycle
        AS
    BEGIN
        DELETE FROM t#acc_for_recalc;

        COMMIT;
        INSERT INTO t#acc_for_recalc
            SELECT
                account_id
            FROM
                (
                    SELECT
                        c#account_id account_id,
                        c#out_num
                    FROM
                        t#account_op
                    UNION
                    SELECT
                        c#id,
                        c#num
                    FROM
                        t#account
                )
            WHERE
                c#out_num IN (
                    SELECT
                        c#account
                    FROM
                        t#pay_source
                    WHERE
                        c#ops_id IS NULL
                        and c#file_id >= 0
                );

        COMMIT;
        
        
        FOR new_acc_rec IN (
            SELECT DISTINCT
                c#file_id
            FROM
                t#pay_source p
            WHERE
                c#ops_id IS NULL
                and c#file_id >= 0
                AND   c#account IN (
                    SELECT
                        c#out_num
                    FROM
                        t#account_op
                    UNION
                    SELECT
                        c#num
                    FROM
                        t#account
                )
            ORDER BY
                c#file_id --desc
        ) LOOP
            BEGIN
                p#fcr_load_outer_data.execallfunction(a#in_file_id => new_acc_rec.c#file_id,a#in_date => SYSDATE);
                COMMIT;
            END;
        END LOOP;

        p#total.recalc_t#acc_for_recalc();




    END;

    PROCEDURE execallfunctioncycleauto
        AS
    BEGIN
        DELETE FROM t#acc_for_recalc_auto;

        COMMIT;
        INSERT INTO t#acc_for_recalc_auto
            SELECT
                account_id
            FROM
                (
                    SELECT
                        c#account_id account_id,
                        c#out_num
                    FROM
                        t#account_op
                    UNION
                    SELECT
                        c#id,
                        c#num
                    FROM
                        t#account
                )
            WHERE
                c#out_num IN (
                    SELECT
                        c#account
                    FROM
                        t#pay_source
                    WHERE
                        c#ops_id IS NULL
                        AND   c#file_id < 0
                );

        COMMIT;
        FOR new_acc_rec IN (
            SELECT DISTINCT
                c#file_id
            FROM
                t#pay_source p
            WHERE
                c#ops_id IS NULL
                AND   c#account IN (
                    SELECT
                        c#out_num
                    FROM
                        t#account_op
                    UNION
                    SELECT
                        c#num
                    FROM
                        t#account
                )
                AND   c#file_id < 0
        ) LOOP
            BEGIN
                p#fcr_load_outer_data.execallfunction(a#in_file_id => new_acc_rec.c#file_id,a#in_date => SYSDATE);
                COMMIT;
            END;
        END LOOP;


        p#total.recalc_t#acc_for_recalc_auto();

    END;

    PROCEDURE filling_these_municipalities
        AS
    BEGIN
        fcr.do#2;
        fcr.do#2_1;
        fcr.do#3;
    END;

END p#fcr_load_outer_data;
/
