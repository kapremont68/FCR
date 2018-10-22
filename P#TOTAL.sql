CREATE OR REPLACE PACKAGE p#total AS
    PROCEDURE update_total_house (
        p_house_id   IN t#total_house.house_id%TYPE
    );

    PROCEDURE update_total_account (
        p_account_id   IN t#total_account.account_id%TYPE
    );

    PROCEDURE update_totals;

    FUNCTION get_recalc_total_status RETURN NUMBER;

END p#total;
/


CREATE OR REPLACE PACKAGE BODY p#total AS

------------------------

    PROCEDURE update_total_house (
        p_house_id   IN t#total_house.house_id%TYPE
    )
        AS
    BEGIN
        DELETE FROM t#total_house WHERE
            house_id = p_house_id;

        INSERT INTO t#total_house
            SELECT
                v.*,
                SYSDATE
            FROM
                v3_house_balance v
            WHERE
                house_id = p_house_id;

        COMMIT;
    END update_total_house;

------------------------

    PROCEDURE update_total_account (
        p_account_id   IN t#total_account.account_id%TYPE
    )
        AS
    BEGIN
        DELETE FROM t#total_account WHERE
            account_id = p_account_id;

        INSERT INTO t#total_account
            SELECT
                v.*,
                SYSDATE
            FROM
                v_account_balance v
            WHERE
                account_id = p_account_id;

        COMMIT;
    END update_total_account;

------------------------

    FUNCTION get_recalc_total_status RETURN NUMBER AS
        cnt   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO
            cnt
        FROM
            t#total_house_tmp;

        RETURN cnt;
    END get_recalc_total_status;

------------------------

    PROCEDURE update_totals
        AS
    BEGIN
--        EXECUTE IMMEDIATE 'TRUNCATE TABLE t#total_account_tmp'; -- обновляем временную таблицу итогов целиком
        INSERT INTO t#total_account_tmp
            SELECT
                v.*,
                sysdate
            FROM
                v_account_balance v;
--
--        COMMIT;
--        EXECUTE IMMEDIATE 'TRUNCATE TABLE t#total_house_tmp'; --  обновляем временную таблицу итогов по домам целиком
        INSERT INTO t#total_house_tmp
            SELECT
                v.*,
                sysdate
            FROM
                v3_house_balance v;

--        COMMIT;
        ------------------------------------------------
        DELETE FROM t#total_account -- удаляем из чистовой таблицы изменившиеся счета
        WHERE
            account_id IN (
                SELECT
                    t.account_id
                FROM
                    t#total_account t
                    JOIN t#total_account_tmp tt ON ( t.account_id = tt.account_id
                                                     AND   t.mn = tt.mn )
                WHERE
                    tt.row_time > t.row_time
                    and (t.period <> tt.period
                    OR   t.house_id <> tt.house_id
                    OR   t.rooms_id <> tt.rooms_id
                    OR   t.flat_num <> tt.flat_num
                    OR   t.end_account_mn <> tt.end_account_mn
                    OR   t.charge_sum_total <> tt.charge_sum_total
                    OR   t.pay_sum_total <> tt.pay_sum_total
                    OR   t.dolg_sum_total <> tt.dolg_sum_total
                    OR   t.peni_sum_total <> tt.peni_sum_total
                    OR   t.barter_sum_total <> tt.barter_sum_total
                    OR   t.charge_sum_mn <> tt.charge_sum_mn
                    OR   t.pay_sum_mn <> tt.pay_sum_mn
                    OR   t.dolg_sum_mn <> tt.dolg_sum_mn
                    OR   t.peni_sum_mn <> tt.peni_sum_mn
                    OR   t.barter_sum_mn <> tt.barter_sum_mn)
            );

        INSERT INTO t#total_account -- добавляем в чистовую итоговую таблицу из временной записи по счетам, которых там нет
            SELECT
                t.*
            FROM
                t#total_account_tmp t
            WHERE
                account_id NOT IN (
                    SELECT
                        account_id
                    FROM
                        t#total_account
                );

--        COMMIT;
        ----------------------------------------------------------    
        
        DELETE FROM t#total_house -- удаляем из чистовой таблицы изменившиеся дома
        WHERE
            house_id IN (
                SELECT
                    t.house_id
                FROM
                    t#total_house t
                    JOIN t#total_house_tmp tt ON ( t.house_id = tt.house_id
                                                   AND   t.mn = tt.mn )
                WHERE
                    tt.row_time > t.row_time
                    and (t.period <> tt.period
                    OR   t.charge_sum_total <> tt.charge_sum_total
                    OR   t.pay_sum_total <> tt.pay_sum_total
                    OR   t.dolg_sum_total <> tt.dolg_sum_total
                    OR   t.peni_sum_total <> tt.peni_sum_total
                    OR   t.barter_sum_total <> tt.barter_sum_total
                    OR   t.balance_sum_total <> tt.balance_sum_total
                    OR   t.job_sum_total <> tt.job_sum_total
                    OR   t.owners_job_sum_total <> tt.owners_job_sum_total
                    OR   t.gos_job_sum_total <> tt.gos_job_sum_total
                    OR   t.charge_sum_mn <> tt.charge_sum_mn
                    OR   t.pay_sum_mn <> tt.pay_sum_mn
                    OR   t.dolg_sum_mn <> tt.dolg_sum_mn
                    OR   t.peni_sum_mn <> tt.peni_sum_mn
                    OR   t.barter_sum_mn <> tt.barter_sum_mn
                    OR   t.balance_sum_mn <> tt.balance_sum_mn
                    OR   t.job_sum_mn <> tt.job_sum_mn
                    OR   t.owners_job_sum_mn <> tt.owners_job_sum_mn
                    OR   t.gos_job_sum_mn <> tt.gos_job_sum_mn)
            );

        INSERT INTO t#total_house -- добавляем в чистовую итоговую таблицу из временной записи по домам, которых там нет
            SELECT
                t.*
            FROM
                t#total_house_tmp t
            WHERE
                house_id NOT IN (
                    SELECT
                        house_id
                    FROM
                        t#total_house
                );

        COMMIT;
--        EXECUTE IMMEDIATE 'TRUNCATE TABLE t#total_house_tmp'; --  чистим таблицу для get_recalc_total_status
        ----------------------------------------------------------    
    END update_totals;

END p#total;
/
