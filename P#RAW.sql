CREATE OR REPLACE PACKAGE p#raw AS
    PROCEDURE after_load_1c;

    PROCEDURE after_load_dbf;

    PROCEDURE after_autoload;

    PROCEDURE set_raw_1c_acc_num (
        p_raw_1c_id NUMBER,
        p_acc_num VARCHAR2
    );

END p#raw;
/


CREATE OR REPLACE PACKAGE BODY p#raw AS
------------------------------------------

    PROCEDURE load_raw_to_paysource
        AS
    BEGIN
        INSERT INTO t#pay_source (
            c#account,
            c#real_date,
            c#summa,
            c#period,
            c#cod_rkc,
            c#pay_num,
            c#file_id,
            c#comment,
            c#plat
        )
            SELECT
                regexp_substr(ltrim(replace(ls,' ',''),'0'),'[^?-]+',1),
                dt_pay,
                sum_pl,
                period,
                vid_oper,
                n_oper,
                file_id,
                file_name,
                fio
            FROM
                t#raw_dbf d
            WHERE
                id NOT IN (
                    SELECT
                        r.id
                    FROM
                        t#pay_source p
                        JOIN t#raw_dbf r ON ( c#real_date = dt_pay
                                              AND   (
                            regexp_substr(ltrim(replace(ls,' ',''),'0'),'[^?-]+',1) = c#account
                            OR    ls = c#account
                        )
                                              AND   sum_pl = c#summa
                                              AND   p.c#file_id >= 0
                                              AND   period = c#period
                                              AND   nvl(c#pay_num,0) = nvl(n_oper,0) )
                )
            MINUS
            SELECT
                c#account,
                c#real_date,
                c#summa,
                c#period,
                c#cod_rkc,
                TO_CHAR(c#pay_num),
                c#file_id,
                c#comment,
                c#plat
            FROM
                t#pay_source
            WHERE
                c#file_id < 0;

        COMMIT;
    END;
------------------------------------------

    PROCEDURE calc_spec_prihod_vozvrat
        AS
    BEGIN
        FOR rec IN (
            SELECT
                b.house_id house_id,
                r.data pay_date,
                -1 * r.summa pay_sum,
                r.naznachenieplatega pay_comment
            FROM
                t#raw_1c_v101 r
                JOIN v4_bank_vd b ON ( r.platelshikschet = b.acc_num )
                LEFT JOIN spec_prihod s ON ( b.house_id = s.id_house
                                             AND -1 * r.summa = s.pay
                                             AND r.data = s.dt_pay )
            WHERE
                b.acc_type = 2
                AND   s.id_house IS NULL
                AND   b.valid_tag = 'Y'
        ) LOOP
            p#fcr_load_outer_data.ins#spec_prihod(rec.house_id,rec.pay_date,rec.pay_sum,rec.pay_comment);
        END LOOP;

        COMMIT;
    END;
------------------------------------------

    PROCEDURE calc_spec_prihod
        AS
    BEGIN
        FOR rec IN (
            SELECT
                b.house_id house_id,
                r.data pay_date,
                r.summa pay_sum,
                r.naznachenieplatega pay_comment
            FROM
                t#raw_1c_v101 r
                JOIN v4_bank_vd b ON ( r.poluchatelschet = b.acc_num
                                       AND r.naznachenieplatega LIKE '%ћ ƒ('
                || b.house_id
                || ')%' )
                LEFT JOIN spec_prihod s ON ( b.house_id = s.id_house
                                             AND r.summa = s.pay
                                             AND r.data = s.dt_pay )
            WHERE
                b.acc_type = 2
                AND   b.valid_tag = 'Y'
                AND   s.id_house IS NULL
                AND   r.data > DATE '2018-04-01' -- до этой даты спецприход грузилс€ обратным парсингом и даты платежей могут не совпадать
        ) LOOP
            p#fcr_load_outer_data.ins#spec_prihod(rec.house_id,rec.pay_date,rec.pay_sum,rec.pay_comment);
        END LOOP;

        COMMIT;
    END;
------------------------------------------

    PROCEDURE calc_kotel_prihod
        AS
    BEGIN
        FOR rec IN (
            SELECT
                summa pay_sum,
                data pay_date,
                dokument
                || ' '
                || nomer
                || ' - '
                || naznachenieplatega pay_comment
            FROM
                t#raw_1c_v101
            WHERE
                platelshikschet = '40703810302000000250'
                AND   poluchatelschet = '40604810502000000308'
                AND   data > DATE '2018-04-01' -- до этой даты спецприход грузилс€ обратным парсингом и даты платежей могут не совпадать
        ) LOOP
            p#fcr_load_outer_data.ins#kotel_other_prih(rec.pay_sum,rec.pay_date,rec.pay_comment);
        END LOOP;

        COMMIT;
    END;
------------------------------------------

    PROCEDURE del_doubles_dbf
        AS
    BEGIN
        DELETE FROM t#raw_dbf
        WHERE
            id IN (
                SELECT
                    id
                FROM
                    (
                        SELECT
                            s.*,
                            ROW_NUMBER() OVER(
                                PARTITION BY file_name,
                                dt_pay,
                                osb,
                                filial,
                                cashier,
                                n_oper,
                                ls,
                                period,
                                vid_oper
--                               ,file_id
                                ORDER BY
                                    row_time
                            ) num
                        FROM
                            t#raw_dbf s
                    )
                WHERE
                    num <> 1
            );

        COMMIT;
    END;
------------------------------------------

    PROCEDURE del_doubles_1c
        AS
    BEGIN
        DELETE FROM t#raw_1c_v101
        WHERE
            id IN (
                SELECT
                    id
                FROM
                    (
                        SELECT
                            s.*,
                            ROW_NUMBER() OVER(
                                PARTITION BY nomer,
                                data,
                                summa,
                                platelshikschet,
                                poluchatelschet
                                ORDER BY
                                    row_time
                            ) num
                        FROM
                            t#raw_1c_v101 s
                    )
                WHERE
                    num <> 1
            );

        COMMIT;
    END;
------------------------------------------

    PROCEDURE load_1c_raw_250_to_paysource -- груз€тс€ платежи только с расставлеными вручную номерами счетов
        AS
    BEGIN
        INSERT INTO t#pay_source (
            c#account,
            c#real_date,
            c#summa,
            c#period,
            c#cod_rkc,
            c#pay_num,
            c#file_id,
            c#comment,
            c#plat
        )
            SELECT
                TRIM(acc_num),
                data,
                summa,
                TO_CHAR(data,'MMYY'),
                '55',
                nomer,
                -7,
                'RAW_1C_ID:'
                || id
                || ' '
                || naznachenieplatega,
                platelshik1
            FROM
                t#raw_1c_v101 t
            WHERE
                acc_num IS NOT NULL
                AND   id NOT IN (
                    SELECT
                        r.id
                    FROM
                        t#pay_source p
                        JOIN t#raw_1c_v101 r ON ( c#real_date = data
                                                  AND   TRIM(acc_num) = c#account
                                                  AND   summa = c#summa
                                                  AND   p.c#file_id >= 0
                                                  AND   TO_CHAR(data,'MMYY') = c#period
                                                  AND   nvl(c#pay_num,0) = nvl(nomer,0) )
                )
                AND   id NOT IN (
                    SELECT
                        r.id
                    FROM
                        t#raw_1c_v101 r
                        JOIN t#pay_source p ON ( p.c#comment LIKE 'RAW_1C_ID:'
                        || r.id
                        || '%' )
                );

        COMMIT;
    END;
------------------------------------------

    PROCEDURE after_load_1c
        AS
    BEGIN
        del_doubles_1c ();
        calc_spec_prihod_vozvrat ();
        calc_spec_prihod ();
        calc_kotel_prihod ();
        load_1c_raw_250_to_paysource ();
    END after_load_1c;
------------------------------------------

    PROCEDURE after_load_dbf AS
        cnt   NUMBER;
    BEGIN
        del_doubles_dbf ();
        load_raw_to_paysource ();
    END after_load_dbf;
-----------------------------------------------------------

    PROCEDURE do_posting AS
        cnt   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO
            cnt
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
            AND   c#file_id < 0;

        IF
            cnt > 0
        THEN
            p#fcr_load_outer_data.execallfunctioncycleauto ();
        END IF;
    END;
-----------------------------------------------------------

    PROCEDURE after_autoload
        AS
    BEGIN
        after_load_dbf;
        after_load_1c;
        p#dbf.after_autoload ();
        do_posting ();
    END after_autoload;

-----------------------------------------------------------

    PROCEDURE set_raw_1c_acc_num (
        p_raw_1c_id NUMBER,
        p_acc_num VARCHAR2
    )
        AS
    BEGIN
        UPDATE t#raw_1c_v101
            SET
                acc_num = p_acc_num
        WHERE
            id = p_raw_1c_id;

        COMMIT;
    END set_raw_1c_acc_num;

END p#raw;
/
