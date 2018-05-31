CREATE OR REPLACE PACKAGE p#raw AS

    PROCEDURE after_load_sber;

    PROCEDURE after_load_post;

    PROCEDURE after_load_1c;

    PROCEDURE after_load_online;

END p#raw;
/


CREATE OR REPLACE PACKAGE BODY p#raw AS

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

    PROCEDURE after_load_sber
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
    END after_load_sber;
------------------------------------------

    PROCEDURE after_load_post
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
    END after_load_post;
------------------------------------------

    PROCEDURE after_load_1c
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
        
        calc_spec_prihod_vozvrat();
        
    END after_load_1c;
------------------------------------------

    PROCEDURE after_load_online
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
    END after_load_online;

END p#raw;
/
