CREATE OR REPLACE PACKAGE P#RECALC AS 

-- форс-пересчет счета
    PROCEDURE FORCE_RECALC_ACC(p_ACC_ID NUMBER, p_RECALC_HOUSE VARCHAR2 DEFAULT 'Y');

-- форс-пересчет всех счетов дома + накопления самого дома
    PROCEDURE FORCE_RECALC_HOUSE(p_HOUSE_ID NUMBER);
    
    PROCEDURE FORCE_RECALC_HOUSE_ONLY(p_HOUSE_ID NUMBER);

    
    PROCEDURE RESET_PAY_SOURCE_FOR_ACC(p_ACC_ID NUMBER);
    

END P#RECALC;
/


CREATE OR REPLACE PACKAGE BODY p#recalc AS

    PROCEDURE force_recalc_acc (
        p_acc_id         NUMBER,
        p_recalc_house   VARCHAR2 DEFAULT 'Y'
    ) AS
        a_house_id   NUMBER;
--    maxMN NUMBER;
    BEGIN
        do#recalc_account(NULL,TO_DATE('01.06.2014','dd.mm.yyyy'),p_acc_id);
        p#total.update_total_account(p_acc_id);
        IF
            p_recalc_house = 'Y'
        THEN
            SELECT
                house_id
            INTO
                a_house_id
            FROM
                v_house_room_acc
            WHERE
                account_id = p_acc_id
                AND   ROWNUM < 2;

            p#total.update_total_house(a_house_id);
        END IF;


--    maxMN := P#UTILS.GET#OPEN_MN()+1;
--    
--    EXECUTE IMMEDIATE 'alter trigger TR#STORE#WARD disable';
--    EXECUTE IMMEDIATE 'alter trigger TR#STORAGE#WARD disable';
--    FOR lmn IN 163..maxMN LOOP
--        DO#CALC_STORE(p_ACC_ID,lmn);
--    END LOOP;
--    EXECUTE IMMEDIATE 'alter trigger TR#STORE#WARD enable';
--    EXECUTE IMMEDIATE 'alter trigger TR#STORAGE#WARD enable';

        COMMIT;
    END force_recalc_acc;

------------------------------------------------------------------------

    PROCEDURE force_recalc_house (
        p_house_id NUMBER
    )
        AS
    BEGIN
        FOR accitem IN (
            SELECT
                account_id
            FROM
                v_house_room_acc
            WHERE
                house_id = p_house_id
        ) LOOP
            force_recalc_acc(accitem.account_id,'N');
        END LOOP;

        p#total.update_total_house(p_house_id);
    END force_recalc_house;

------------------------------------------------------------------------

    PROCEDURE reset_pay_source_for_acc (
        p_acc_id NUMBER
    )
        AS
    BEGIN
        UPDATE t#pay_source
            SET
                c#acc_id_close = NULL,
                c#acc_id = NULL,
                c#acc_id_tter = NULL,
                c#ops_id = NULL
        WHERE
            coalesce(c#acc_id,c#acc_id_tter,c#acc_id_close) = p_acc_id;

        EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD disable';
        EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD disable';
        DELETE FROM t#op WHERE
            c#account_id = p_acc_id;

        EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD enable';
        EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD enable';
        COMMIT;
    END reset_pay_source_for_acc;

------------------------------------------------------------------------
    PROCEDURE force_recalc_house_only (
        p_house_id NUMBER
    )
        AS
    BEGIN
        p#total.update_total_house(p_house_id);
    END force_recalc_house_only;
------------------------------------------------------------------------

END p#recalc;
/
