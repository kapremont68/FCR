CREATE OR REPLACE PACKAGE p#total AS

    RowNumCount  NUMBER  := 21;
    

    PROCEDURE update_total_house (
        p_house_id   IN t#total_house.house_id%TYPE
    );

    PROCEDURE update_total_account (
        p_account_id   IN t#total_account.account_id%TYPE
    );

    PROCEDURE recalc_t#acc_for_recalc;

    PROCEDURE recalc_t#acc_for_recalc_auto;

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

    PROCEDURE recalc_t#acc_for_recalc
        AS
    BEGIN
        FOR recalc_rec IN (
            SELECT DISTINCT
                a.account_id,
                house_id
            FROM
                t#acc_for_recalc a
                JOIN v_house_room_acc h ON ( a.account_id = h.account_id )
            where
                rownum < RowNumCount
        ) LOOP
            BEGIN
                p#total.update_total_account(recalc_rec.account_id);
                INSERT INTO t#house_for_recalc ( house_id ) VALUES ( recalc_rec.house_id );

                DELETE FROM t#acc_for_recalc
                WHERE
                    account_id = recalc_rec.account_id;

                COMMIT;
            END;
        END LOOP;

        FOR recalc_house_rec IN (
            SELECT DISTINCT
                house_id
            FROM
                t#house_for_recalc
        ) LOOP
            BEGIN
                p#total.update_total_house(recalc_house_rec.house_id);
                DELETE FROM t#house_for_recalc
                WHERE
                    house_id = recalc_house_rec.house_id;

                COMMIT;
            END;
        END LOOP;

    END recalc_t#acc_for_recalc;

    PROCEDURE recalc_t#acc_for_recalc_auto
        AS
    BEGIN
        FOR recalc_rec IN (
            SELECT DISTINCT
                a.account_id,
                house_id
            FROM
                t#acc_for_recalc_auto a
                JOIN v_house_room_acc h ON ( a.account_id = h.account_id )
            where
                rownum < RowNumCount
        ) LOOP
            BEGIN
                p#total.update_total_account(recalc_rec.account_id);
                INSERT INTO t#house_for_recalc ( house_id ) VALUES ( recalc_rec.house_id );

                DELETE FROM t#acc_for_recalc_auto
                WHERE
                    account_id = recalc_rec.account_id;

                COMMIT;
            END;
        END LOOP;

        FOR recalc_house_rec IN (
            SELECT DISTINCT
                house_id
            FROM
                t#house_for_recalc
        ) LOOP
            BEGIN
                p#total.update_total_house(recalc_house_rec.house_id);
                DELETE FROM t#house_for_recalc
                WHERE
                    house_id = recalc_house_rec.house_id;

                COMMIT;
            END;
        END LOOP;

    END recalc_t#acc_for_recalc_auto;

END p#total;
/
