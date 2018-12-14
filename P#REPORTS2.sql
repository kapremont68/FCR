CREATE OR REPLACE PACKAGE p#reports2 AS

-- долги по муниципальному и региональному жилью за период
    FUNCTION lst#mun_dolg (
        a#period VARCHAR2 -- mm.yyyy
    ) RETURN SYS_REFCURSOR;

    FUNCTION lst#akt_j (
        a#person_id   NUMBER,
        a#start_per   VARCHAR2, -- mm.yyyy 
        a#end_per     VARCHAR2 -- mm.yyyy 
    ) RETURN SYS_REFCURSOR;

    FUNCTION lst#person_j_payments (
        a#person_j_id NUMBER
    ) RETURN SYS_REFCURSOR;
    
    FUNCTION lst_person_j_ostatki RETURN SYS_REFCURSOR;

    FUNCTION lst_person_j_pay_source RETURN SYS_REFCURSOR;
    

END p#reports2;
/


CREATE OR REPLACE PACKAGE BODY p#reports2 AS

    FUNCTION lst#mun_dolg (
        a#period VARCHAR2 -- mm.yyyy
    ) RETURN SYS_REFCURSOR AS
        ret   SYS_REFCURSOR;
    BEGIN
        OPEN ret FOR SELECT
                         CASE
                             WHEN j.c#tip_ul IN (
                                 'MBU',
                                 'MKU',
                                 'MUP',
                                 'OMS'
                             ) THEN 'M'
                             WHEN j.c#tip_ul IN (
                                 'GUP',
                                 'OBL'
                             ) THEN 'R'
                         END type,
                         j.c#name   name,
                         MAX(t.period) per,
                         SUM(charge_sum_total) charge_sum,
                         SUM(pay_sum_total) pay_sum,
                         SUM(dolg_sum_total) dolg_sum
                     FROM
                         v#acc_last2 l
                         JOIN t#person_j j ON ( l.c#person_id = j.c#person_id )
                         JOIN t#total_account t ON ( l.c#account_id = t.account_id )
                     WHERE
                         CASE
                             WHEN j.c#tip_ul IN (
                                 'MBU',
                                 'MKU',
                                 'MUP',
                                 'OMS'
                             ) THEN 'M'
                             WHEN j.c#tip_ul IN (
                                 'GUP',
                                 'OBL'
                             ) THEN 'R'
                         END IN (
                             'M',
                             'R'
                         )
                         AND t.period = a#period
                     GROUP BY
                         CASE
                             WHEN j.c#tip_ul IN (
                                 'MBU',
                                 'MKU',
                                 'MUP',
                                 'OMS'
                             ) THEN 'M'
                             WHEN j.c#tip_ul IN (
                                 'GUP',
                                 'OBL'
                             ) THEN 'R'
                         END,
                         j.c#name,
                         t.mn
                     ORDER BY
                         CASE
                             WHEN j.c#tip_ul IN (
                                 'MBU',
                                 'MKU',
                                 'MUP',
                                 'OMS'
                             ) THEN 'M'
                             WHEN j.c#tip_ul IN (
                                 'GUP',
                                 'OBL'
                             ) THEN 'R'
                         END,
                         j.c#name,
                         t.mn;

        RETURN ret;
    END lst#mun_dolg;
---------------------------

    FUNCTION lst#akt_j (
        a#person_id   NUMBER,
        a#start_per   VARCHAR2, -- mm.yyyy 
        a#end_per     VARCHAR2 -- mm.yyyy 
    ) RETURN SYS_REFCURSOR AS
        res          SYS_REFCURSOR;
        a#mn_begin   INTEGER;
        a#mn_end     INTEGER;
    BEGIN
        SELECT
            months_between(trunc(TO_DATE('01.' || a#start_per, 'dd.mm.yyyy'), 'MM'), DATE '2000-12-01')
        INTO a#mn_begin
        FROM
            dual;

        SELECT
            months_between(trunc(TO_DATE('01.' || a#end_per, 'dd.mm.yyyy'), 'MM'), DATE '2000-12-01')
        INTO a#mn_end
        FROM
            dual;

--        a#mn_begin := 162;
--        a#mn_end := 500;

        OPEN res FOR WITH jacc AS (
                        SELECT
                            c#account_id
                        FROM
                            v#account_spec
                        WHERE
                            c#person_id = a#person_id
                    ), ops AS (
                        SELECT
                            *
                        FROM
                            v#op
                            JOIN v#ops ON ( v#op.c#ops_id = v#ops.c#id )
                        WHERE
                            c#account_id IN (
                                SELECT
                                    *
                                FROM
                                    jacc
                            )
                    ), charg AS (
                        SELECT
                            c#mn   ch_mn,
                            SUM(c#vol) ch_vol,
                            SUM(c#sum) ch_sum
                        FROM
                            t#charge
                        WHERE
                            c#account_id IN (
                                SELECT
                                    *
                                FROM
                                    jacc
                            )
                            AND c#mn BETWEEN a#mn_begin AND a#mn_end
                        GROUP BY
                            c#mn
                    ), pays AS (
                        SELECT
                            TO_CHAR(c#real_date, 'mm.yyyy') p_per,
                            SUM(c#sum) p_sum
                        FROM
                            v#op
                        WHERE
                            c#account_id IN (
                                SELECT
                                    *
                                FROM
                                    jacc
                            )
                        GROUP BY
                            TO_CHAR(c#real_date, 'mm.yyyy')
                    ), chp AS (
                        SELECT
                            ch_mn,
                            TO_CHAR(p#mn_utils.get#date(ch_mn), 'mm.yyyy') per,
                            p#tools.get_tarif(p#mn_utils.get#date(ch_mn)) tarif,
                            ch_vol,
                            ch_sum,
                            p_sum
                        FROM
                            charg left
                            JOIN pays ON ( TO_CHAR(p#mn_utils.get#date(ch_mn), 'mm.yyyy') = p_per )
                        ORDER BY
                            ch_mn
                    ), total1 AS (
                        SELECT
                            chp.*,
                            SUM(ch_sum) OVER(
                                PARTITION BY 1
                                ORDER BY
                                    ch_mn
                            ) ch_total,
                            SUM(p_sum) OVER(
                                PARTITION BY 1
                                ORDER BY
                                    ch_mn
                            ) p_total
                        FROM
                            chp
                    ), total2 AS (
                        SELECT
                            substr(p#tools.get_person_name_by_id(a#person_id), 1, instr(p#tools.get_person_name_by_id(19), '(ИНН'
                            ) - 1) jname,
                            per,
                            tarif,
                            ch_vol,
                            nvl(ch_sum, 0) ch_sum,
                            nvl(p_sum, 0) p_sum,
                            nvl(ch_total, 0) ch_total,
                            nvl(p_total, 0) p_total,
                            nvl(ch_total, 0) - nvl(p_total, 0) dolg
                        FROM
                            total1
                    )
                    SELECT
                        *
                    FROM
                        total2;

        RETURN res;
    END lst#akt_j;
--------------------------------------------------------

    FUNCTION lst#person_j_payments (
        a#person_j_id NUMBER
    ) RETURN SYS_REFCURSOR AS
        res   SYS_REFCURSOR;
    BEGIN
        OPEN res FOR SELECT
                         c#person_id   mass_pay_person_id,
                         NULL pay_source_acc_num,
                         c#date        pay_date,
                         c#sum         pay_sum
                     FROM
                         t#mass_pay
                     WHERE
                         c#person_id = a#person_j_id
                     UNION ALL
                     SELECT
                         NULL mass_pay_person_id,
                         c#account     pay_source_acc_num,
                         c#real_date   pay_date,
                         c#summa       pay_sum
                     FROM
                         t#pay_source
                     WHERE
                         coalesce(c#acc_id, c#acc_id_tter, c#acc_id_close) IN (
                             SELECT
                                 c#account_id
                             FROM
                                 v#acc_last2
                             WHERE
                                 c#person_id = a#person_j_id
                         );

        RETURN res;
    END lst#person_j_payments;
----------------------------------------

    FUNCTION lst_person_j_ostatki RETURN SYS_REFCURSOR AS
        ret   SYS_REFCURSOR;
    BEGIN
        OPEN ret FOR WITH ost AS (
                         SELECT
                             c#person_id,
                             SUM(с#ostatok) ostatok
                         FROM
                             (
                                 SELECT
                                     mp.c#person_id,
                                     mp.с#ostatok,
                                     mp.c#date,
                                     mp.c#living_tag,
                                     mp.c#id,
                                     mp.c#npd,
                                     mp.c#cod_rkc,
                                     mp.c#comment
                                 FROM
                                     t#mass_pay mp
                                 WHERE
                                     1 = 1
                                     AND nvl(mp.с#ostatok, 0) > 0
                                     AND nvl(mp.c#remove_flg, 'N') <> 'Y'
                                     AND nvl(mp.c#storno_flg, 'N') <> 'Y'
                                     AND ( mp.c#acc_id IS NULL
                                           OR mp.c#acc_id = 0 )
                             ) t
                         GROUP BY
                             c#person_id
                     )
                     SELECT
                         o.ostatok,
                         j.*
                     FROM
                         ost o
                         JOIN t#person_j j ON ( o.c#person_id = j.c#person_id );

        RETURN ret;
    END lst_person_j_ostatki;
------------------------------

    FUNCTION lst_person_j_pay_source RETURN SYS_REFCURSOR AS
        ret   SYS_REFCURSOR;
    BEGIN
        OPEN ret FOR SELECT
                         j.c#person_id   person_id,
                         j.c#name        person_name,
                         SUM(ps.c#summa) pay_source_sum
                     FROM
                         t#pay_source ps
                         JOIN v#acc_last2 l ON ( l.c#account_id = coalesce(c#acc_id, c#acc_id_tter, c#acc_id_close) )
                         JOIN t#person_j j ON ( l.c#person_id = j.c#person_id )
                     GROUP BY
                         j.c#person_id,
                         j.c#name
                     HAVING
                         SUM(ps.c#summa) <> 0;

        RETURN ret;
    END lst_person_j_pay_source;

END p#reports2;
/
