CREATE OR REPLACE PACKAGE p#raw AS

    PROCEDURE after_load_sber;

    PROCEDURE after_load_post;

    PROCEDURE after_load_1c;

    PROCEDURE after_load_online;

END p#raw;
/


CREATE OR REPLACE PACKAGE BODY p#raw AS


------------------------------------------

    PROCEDURE load_post_to_paysource
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
                '52' rkc,
                n_oper,
                -2 file_id,
                file_name,
                fio
            FROM
                t#raw_post
            WHERE
                id NOT IN (
                    SELECT
                        r.id
                    FROM
                        t#pay_source p
                        JOIN t#raw_sber r ON ( c#real_date = dt_pay
                                               AND   (
                            regexp_substr(ltrim(replace(ls,' ',''),'0'),'[^?-]+',1) = c#account
                            OR    ls = c#account
                        )
                                               AND   sum_pl = c#summa
                                               AND   c#comment = fio
                                               AND   period = c#period
                                               AND   c#pay_num = n_oper )
                    WHERE
                        c#cod_rkc = 52
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
                c#file_id =-2;

    END;
------------------------------------------

    PROCEDURE load_sber_to_paysource
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
                '51' rkc,
                n_oper,
                -1 file_id,
                file_name,
                fio
            FROM
                t#raw_sber
            WHERE
                id NOT IN (
                    SELECT
                        r.id
                    FROM
                        t#pay_source p
                        JOIN t#raw_sber r ON ( c#real_date = dt_pay
                                               AND   (
                            regexp_substr(ltrim(replace(ls,' ',''),'0'),'[^?-]+',1) = c#account
                            OR    ls = c#account
                        )
                                               AND   sum_pl = c#summa
                                               AND   c#comment = fio
                                               AND   period = c#period
                                               AND   c#pay_num = n_oper )
                    WHERE
                        c#cod_rkc = 51
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
                c#file_id =-1;

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
            WHERE
                b.acc_type = 2
                AND   b.valid_tag = 'Y'
        ) LOOP
            p#fcr_load_outer_data.ins#spec_prihod(rec.house_id,rec.pay_date,rec.pay_sum,rec.pay_comment);
        END LOOP;
    END;
------------------------------------------

    PROCEDURE del_doubles_sber
        AS
    BEGIN
        DELETE FROM t#raw_sber
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
                                ls
                                ORDER BY
                                    row_time
                            ) num
                        FROM
                            t#raw_sber s
                    )
                WHERE
                    num <> 1
            );

        COMMIT;
    END;

------------------------------------------

    PROCEDURE del_doubles_post
        AS
    BEGIN
        DELETE FROM t#raw_post
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
                                ls
                                ORDER BY
                                    row_time
                            ) num
                        FROM
                            t#raw_post s
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

    PROCEDURE del_doubles_online
        AS
    BEGIN
        DELETE FROM t#raw_online
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
                                ls
                                ORDER BY
                                    row_time
                            ) num
                        FROM
                            t#raw_online s
                    )
                WHERE
                    num <> 1
            );

        COMMIT;
    END;
------------------------------------------

    PROCEDURE after_load_sber
        AS
    BEGIN
        del_doubles_sber ();
        load_sber_to_paysource ();
    END after_load_sber;
------------------------------------------

    PROCEDURE after_load_post
        AS
    BEGIN
        del_doubles_post ();
        load_post_to_paysource ();
    END after_load_post;
------------------------------------------

    PROCEDURE after_load_1c
        AS
    BEGIN
        del_doubles_1c ();
        calc_spec_prihod_vozvrat ();
    END after_load_1c;
------------------------------------------

    PROCEDURE after_load_online
        AS
    BEGIN
        del_doubles_online ();
    END after_load_online;
------------------------------------------

END p#raw;
/
