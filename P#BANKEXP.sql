CREATE OR REPLACE PACKAGE P#BANKEXP AS 

-- всего собрали по счету без учета зачетов на дату
    FUNCTION GET#PAY_WITOUT_BARTER(p_T#B_ACCOUNT_ID NUMBER, p_DATE DATE DEFAULT sysdate) RETURN NUMBER;

-- всего перечислено на спецсчет на дату
    FUNCTION GET#SPEC_TRANSFER(p_T#B_ACCOUNT_ID NUMBER, p_DATE DATE DEFAULT sysdate) RETURN NUMBER;
    
-- всего перечислено на котел на дату
    FUNCTION GET#KOTEL_TRANSFER(p_DATE DATE DEFAULT sysdate) RETURN NUMBER;


END P#BANKEXP;
/


CREATE OR REPLACE PACKAGE BODY p#bankexp AS

    FUNCTION get#pay_witout_barter (
        p_t#b_account_id   NUMBER,
        p_date             DATE DEFAULT SYSDATE
    ) RETURN NUMBER AS
        res   NUMBER;
    BEGIN
        SELECT
            nvl(SUM(pay_sum_total),0) - nvl(SUM(barter_sum_total),0)
        INTO
            res
        FROM
            T#TOTAL_HOUSE
        WHERE
            mn = p#mn_utils.get#mn(p_date)
            AND   house_id IN (
                SELECT
                    house_id
                FROM
                    v4_bank_vd
                WHERE
                    b_account_id = p_t#b_account_id
                    and VALID_TAG = 'Y'
                    
            );

        RETURN res;
    END get#pay_witout_barter;
--------------------------------------------

    FUNCTION get#spec_transfer (
        p_t#b_account_id   NUMBER,
        p_date             DATE DEFAULT SYSDATE
    ) RETURN NUMBER AS
        res   NUMBER;
    BEGIN
        SELECT
            SUM(pay)
        INTO
            res
        FROM
            spec_prihod
        WHERE
            dt_pay <= p_date
            AND   id_house IN (
                SELECT
                    house_id
                FROM
                    v4_bank_vd
                WHERE
                    b_account_id = p_t#b_account_id
                    and VALID_TAG = 'Y'
            );

        RETURN res;
    END get#spec_transfer;
--------------------------------------------
    FUNCTION get#kotel_transfer (
        p_date DATE DEFAULT SYSDATE
    ) RETURN NUMBER AS
        res   NUMBER;
    BEGIN
        SELECT
            SUM(pl_sum)
        INTO
            res
        FROM
            kotel_other_prih
        WHERE
            pl_date <= p_date;

        RETURN res;
    END get#kotel_transfer;

END p#bankexp;
/
