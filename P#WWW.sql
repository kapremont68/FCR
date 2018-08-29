CREATE OR REPLACE PACKAGE p#www AS
    FUNCTION get#acc_id_by_any_acc_num (
        p_acc_num VARCHAR2
    ) RETURN NUMBER;

    FUNCTION get#acc_balance (
        p_acc_num VARCHAR2
    ) RETURN SYS_REFCURSOR;

    FUNCTION get#info_for_kvit (
        p_acc_num VARCHAR2,
        p_period VARCHAR2
    ) RETURN SYS_REFCURSOR;

    FUNCTION get#kvit_delivery_address (
        p_acc_id NUMBER
    ) RETURN VARCHAR2;

END p#www;
/


CREATE OR REPLACE PACKAGE BODY p#www AS

    FUNCTION get#acc_id_by_any_acc_num (
        p_acc_num VARCHAR2
    ) RETURN NUMBER AS
        ret_acc_id   NUMBER;
    BEGIN
        SELECT
            c#id
        INTO
            ret_acc_id
        FROM
            t#account
        WHERE
            c#num = p_acc_num;

        RETURN ret_acc_id;
    EXCEPTION
        WHEN no_data_found THEN
            BEGIN
                SELECT
                    c#account_id
                INTO
                    ret_acc_id
                FROM
                    v#acc_last
                WHERE
                    c#out_num = p_acc_num
                    AND   ROWNUM < 2;

                RETURN ret_acc_id;
            END;
    END get#acc_id_by_any_acc_num;

--------------------------------------

    FUNCTION get#acc_balance (
        p_acc_num VARCHAR2
    ) RETURN SYS_REFCURSOR AS
        res        SYS_REFCURSOR;
        a_acc_id   NUMBER;
    BEGIN
        SELECT
            p#www.get#acc_id_by_any_acc_num(p_acc_num)
        INTO
            a_acc_id
        FROM
            dual;

        OPEN res FOR WITH ch AS (
            SELECT
                rowidtochar(ROWID) n,
                1 nn,
                c#account_id account_id,
                c#a_mn mn,
                p#utils.get#tarif(c#account_id,p#mn_utils.get#date(c#a_mn) ) tarif,
                c#vol vol,
                c#sum charge_sum
            FROM
                t#charge
        ),pay AS (
            SELECT
                rowidtochar(p.rowid) n,
                2 nn,
                coalesce(c#acc_id,c#acc_id_close,c#acc_id_tter) account_id,
                p#mn_utils.get#mn(c#real_date) mn,
                c#real_date real_date,
                c#period pay_period,
                c#cod_rkc rkc_code,
                r.c#name rkc_name,
                c#account account_num,
                c#summa pay_sum,
                c#comment pay_comment,
                c#plat payer
            FROM
                t#pay_source p
                LEFT JOIN t#out_proc r ON ( to_number(p.c#cod_rkc) = to_number(r.c#code) )
            WHERE
                c#ops_id IS NOT NULL
        ),alls AS (
            SELECT
                n,
                nn,
                account_id,
                mn,
                TO_CHAR(p#mn_utils.get#date(mn),'mm.yyyy') mn_per,
                tarif,
                vol,
                NULL real_date,
                NULL real_date_str,
                NULL pay_period,
                NULL rkc_name,
                NULL account_num,
                NULL pay_comment,
                NULL payer,
                charge_sum,
                NULL pay_sum
            FROM
                ch
            UNION ALL
            SELECT
                n,
                nn,
                account_id,
                mn,
                NULL mn_per,
                NULL tarif,
                NULL vol,
                real_date,
                TO_CHAR(real_date,'dd.mm.yyyy') real_date_str,
                pay_period,
                rkc_name,
                account_num,
                pay_comment,
                payer,
                NULL charge_sum,
                pay_sum
            FROM
                pay
        ) SELECT
            alls.*,
            SUM(charge_sum) OVER(
            ORDER BY
                mn,
                nn,
                n
            ) charge_total,
            SUM(pay_sum) OVER(
            ORDER BY
                mn,
                nn,
                n
            ) pay_total,
            SUM(nvl(pay_sum,0) - nvl(charge_sum,0) ) OVER(
            ORDER BY
                mn,
                nn,
                n
            ) balance
          FROM
            alls
          WHERE
            account_id = a_acc_id
        ORDER BY
            mn,
            nn,
            real_date;

        RETURN res;
    END get#acc_balance;
-------------------------------------------------------------------------

    FUNCTION get#info_for_kvit (
        p_acc_num VARCHAR2,
        p_period VARCHAR2
    ) RETURN SYS_REFCURSOR AS
        res   SYS_REFCURSOR;
    BEGIN
        OPEN res FOR SELECT
            p_acc_num acc_num,
            ha.addr
            ||
                CASE
                    WHEN r.c#valid_tag = 'Y' THEN ', кв. '
                    ELSE ', пом. '
                END
            || t.flat_num addr,
            TO_CHAR(r.c#area_val) area_val,
            p#tools.get_person_name_by_id(l.c#person_id) person_name,
            TO_CHAR(p#utils.get#tarif(t.account_id,TO_DATE(p_period,'mm.yyyy') ) ) tarif,
            p#tools.period_in_words(t.period) period,
            TO_DATE('01.'
            || t.period,'dd.mm.yyyy') period_full,
            TO_CHAR(charge_sum_mn) charge_sum_mn,
            TO_CHAR(charge_sum_total - charge_sum_mn) charge_sum_total,
            TO_CHAR(pay_sum_total - pay_sum_mn) pay_sum_total,
            TO_CHAR( (charge_sum_total - charge_sum_mn) - (pay_sum_total - pay_sum_mn) ) dolg_sum_total,
            TO_CHAR(
                CASE
                    WHEN(charge_sum_total - charge_sum_mn) - (pay_sum_total - pay_sum_mn) >= 0 THEN charge_sum_mn
                    ELSE greatest(0,charge_sum_mn + (charge_sum_total - charge_sum_mn) - (pay_sum_total - pay_sum_mn) )
                END
            ) to_pay_mn,
            TO_CHAR(
                CASE
                    WHEN(charge_sum_total - charge_sum_mn) - (pay_sum_total - pay_sum_mn) >= 0 THEN charge_sum_mn
                    ELSE greatest(0,charge_sum_mn + (charge_sum_total - charge_sum_mn) - (pay_sum_total - pay_sum_mn) )
                END
            + greatest(0, (charge_sum_total - charge_sum_mn) - (pay_sum_total - pay_sum_mn) ) ) to_pay_total,
            coalesce(p#www.get#kvit_delivery_address(t.account_id),p#utils.get_obj#house_postamt(t.house_id).f#code
            || ', '
            || ha.addr
            ||
                CASE
                    WHEN r.c#valid_tag = 'Y' THEN ', кв. '
                    ELSE ', пом. '
                END
            || t.flat_num) delivery_addr
                     FROM
            t#total_account t
            JOIN mv_houses_adreses ha ON ( t.house_id = ha.house_id )
            JOIN v#rooms r ON ( t.rooms_id = r.c#rooms_id )
            JOIN v#acc_last2 l ON ( t.account_id = l.c#account_id )
                     WHERE
            account_id = (
                SELECT
                    p#www.get#acc_id_by_any_acc_num(p_acc_num)
                FROM
                    dual
            )
            AND   t.period = p_period;

        RETURN res;
    END get#info_for_kvit;
    
-------------------------------------------------------------------

    FUNCTION get#kvit_delivery_address (
        p_acc_id NUMBER
    ) RETURN VARCHAR2 AS
        v_addr   VARCHAR2(500);
    BEGIN
        SELECT
            addr
        INTO
            v_addr
        FROM
            v#person_addr
        WHERE
            person_id = (
                SELECT
                    c#person_id
                FROM
                    v#acc_last
                WHERE
                    c#account_id = p_acc_id
                    AND   ROWNUM < 2
            );

        RETURN v_addr;
    END get#kvit_delivery_address;

END p#www;
/
