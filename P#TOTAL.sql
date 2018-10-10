CREATE OR REPLACE PACKAGE p#total AS
    PROCEDURE update_total_house (
        p_house_id   IN t#total_house.house_id%TYPE
    );

    PROCEDURE update_total_account (
        p_account_id   IN t#total_account.account_id%TYPE
    );

    PROCEDURE recalc_tt#acc_for_recalc;

    PROCEDURE recalc_tt#acc_for_recalc_auto;

END p#total;
/


CREATE OR REPLACE PACKAGE BODY p#total AS

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

    PROCEDURE recalc_tt#acc_for_recalc
        AS
    BEGIN
        FOR recalc_house_rec IN (
            SELECT DISTINCT
                house_id
            FROM
                v_house_room_acc
            WHERE
                account_id IN (
                    SELECT
                        account_id
                    FROM
                        tt#acc_for_recalc
                )
        ) LOOP
            BEGIN
                p#total.update_total_house(recalc_house_rec.house_id);
                COMMIT;
            END;
        END LOOP;

        FOR recalc_acc_rec IN (
            SELECT DISTINCT
                account_id
            FROM
                tt#acc_for_recalc
        ) LOOP
            BEGIN
                p#total.update_total_account(recalc_acc_rec.account_id);
                DELETE FROM tt#acc_for_recalc
                WHERE
                    account_id = recalc_acc_rec.account_id;

                COMMIT;
            END;
        END LOOP;

    END recalc_tt#acc_for_recalc;

    PROCEDURE recalc_tt#acc_for_recalc_auto
        AS
    BEGIN
        FOR recalc_house_rec IN (
            SELECT DISTINCT
                house_id
            FROM
                v_house_room_acc
            WHERE
                account_id IN (
                    SELECT
                        account_id
                    FROM
                        tt#acc_for_recalc_auto
                )
        ) LOOP
            BEGIN
                p#total.update_total_house(recalc_house_rec.house_id);
                COMMIT;
            END;
        END LOOP;

        FOR recalc_acc_rec IN (
            SELECT DISTINCT
                account_id
            FROM
                tt#acc_for_recalc_auto
        ) LOOP
            BEGIN
                p#total.update_total_account(recalc_acc_rec.account_id);
                DELETE FROM tt#acc_for_recalc_auto
                WHERE
                    account_id = recalc_acc_rec.account_id;

                COMMIT;
            END;
        END LOOP;

    END recalc_tt#acc_for_recalc_auto;
END p#total;
/
