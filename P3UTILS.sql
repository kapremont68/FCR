CREATE OR REPLACE PACKAGE P3UTILS AS 

-- строка с перечнем всех работ по дому 
  FUNCTION get_jobs_txt(p_HOUSE_ID NUMBER DEFAULT NULL, p_DATE_BEG DATE, p_DATE_END DATE) RETURN NVARCHAR2;

-- сумма всех платежей по работе
  FUNCTION get_job_summa(p_JOB_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- сумма всех платежей по дому
  FUNCTION get_house_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- планова€ сумма всех работ по дому
  FUNCTION get_house_plan_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- начислено, оплачено, потрачено, долг, остаток по дому по мес€цам
  FUNCTION LST#HOUSE_BALANCE(p_HOUSE_ID NUMBER) RETURN sys_refcursor;

-- платежи в разрезе по домам за работы, проведенные (или по договорам, заключенным) в заданном диапазоне дат
  FUNCTION LST#HOUSES_PAYS(p_DATE_BEG DATE, p_DATE_END DATE) RETURN sys_refcursor;
  
-- разносит имортированные из 1— платежи
  PROCEDURE DO#IMPORT;

END P3UTILS;
/


CREATE OR REPLACE PACKAGE BODY p3utils AS
-----------------------------------

    FUNCTION get_job_summa (
        p_job_id NUMBER DEFAULT NULL
    ) RETURN NUMBER AS
        r_summa   NUMBER;
    BEGIN
        SELECT
            SUM(c#sum)
        INTO
            r_summa
        FROM
            t3_pay
        WHERE
            c#job_id = p_job_id;

        RETURN r_summa;
    END get_job_summa;
-----------------------------------

    FUNCTION get_house_summa (
        p_house_id NUMBER DEFAULT NULL
    ) RETURN NUMBER AS
        r_summa   NUMBER;
    BEGIN
        SELECT
            SUM(c#sum)
        INTO
            r_summa
        FROM
            t3_pay p
            JOIN t3_jobs j ON ( p.c#job_id = j.c#id )
        WHERE
            c#house_id = p_house_id;

        RETURN r_summa;
    END get_house_summa;
-----------------------------------

    FUNCTION lst#house_balance (
        p_house_id NUMBER
    ) RETURN SYS_REFCURSOR AS
        res   SYS_REFCURSOR;
    BEGIN
        OPEN res FOR WITH tran AS (
            SELECT
                c#house_id house_id,
                SUM(c#sum) transfer_sum_total
            FROM
                t4_transfer p
            WHERE
                c#house_id = p_house_id
            GROUP BY
                c#house_id
        ) SELECT
            v.house_id,
            mn,
            period,
            charge_sum_total,
            pay_sum_total,
            peni_sum_total,
            dolg_sum_total,
            job_sum_total,
            owners_job_sum_total,
            gos_job_sum_total,
            balance_sum_total,
            transfer_sum_total,
            p#tools.get_house_balance_2043(p_house_id) balance_2043
          FROM
            v3_house_balance v
            LEFT JOIN tran ON ( v.house_id = tran.house_id )
          WHERE
            v.house_id = p_house_id
            AND   mn = (
                SELECT
                    MAX(mn)
                FROM
                    v3_house_balance
                WHERE
                    house_id = p_house_id
            );

        RETURN res;
    END lst#house_balance;

--  FUNCTION get_jobs_txt(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NVARCHAR2 AS
--    JOBS_TXT VARCHAR2(500);
--  BEGIN
--    begin
--    select 
--        LISTAGG(JOB_TYPE_NAME,'; ') WITHIN GROUP (ORDER BY JOB_TYPE_NAME)
--    into JOBS_TXT        
--    from 
--        (select distinct
--                JOB_TYPE_NAME,
--                HOUSE_ID
--            from 
--                v3_JOBS 
--            where
--                HOUSE_ID = p_HOUSE_ID
--        )
--    group by
--        HOUSE_ID
--    ;
--    exception 
--        when OTHERS then RETURN '-';    
--    end;    
--    RETURN NVL(JOBS_TXT,'');
--  END get_jobs_txt;
-----------------------------------

    FUNCTION get_jobs_txt (
        p_house_id   NUMBER DEFAULT NULL,
        p_date_beg   DATE,
        p_date_end   DATE
    ) RETURN NVARCHAR2 AS
        jobs_txt   VARCHAR2(5000);
    BEGIN
        SELECT
            LISTAGG(job_type_name,
            '; ') WITHIN GROUP(
            ORDER BY
                job_type_name
            )
        INTO
            jobs_txt
        FROM
            (
                SELECT DISTINCT
                    job_type_name,
                    house_id
                FROM
                    v3_jobs j
                    JOIN t3_pay p ON ( p.c#job_id = j.job_id )
                WHERE
                    house_id = p_house_id
                    AND   p.c#pay_date BETWEEN p_date_beg AND p_date_end
            )
        GROUP BY
            house_id;

        RETURN jobs_txt;
    END get_jobs_txt; 
  
-----------------------------------

    FUNCTION get_house_plan_summa (
        p_house_id NUMBER DEFAULT NULL
    ) RETURN NUMBER AS
        r_summa   NUMBER;
    BEGIN
        SELECT
            SUM(plan_sum)
        INTO
            r_summa
        FROM
            v3_jobs
        WHERE
            house_id = p_house_id;

        RETURN r_summa;
    END get_house_plan_summa;
-----------------------------------

    PROCEDURE do#import AS
        a_note   VARCHAR2(100);
    BEGIN
        a_note := 'P3UTILS.DO#IMPORT: '
        || SYSDATE;
        DELETE FROM t3_pay_import
        WHERE
            ROWID NOT IN (
                SELECT
                    MIN(ROWID) rid
                FROM
                    t3_pay_import
                GROUP BY
                    data_pl,
                    summ_pl,
                    pd_num,
                    inn,
                    id_house,
                    dogovor_da,
                    dogovor_nu
            );

        COMMIT;
        INSERT INTO t3_contractors (
            c#inn,
            c#name
        )
            SELECT DISTINCT
                inn,
                plat
            FROM
                t3_pay_import i
                LEFT JOIN t3_contractors c ON ( i.inn = c.c#inn )
            WHERE
                c.c#id IS NULL;

        COMMIT;
        
        INSERT INTO t3_contracts (
            c#date,
            c#num,
            c#contract_type_id,
            c#contractor_id,
            c#description
        )
            SELECT DISTINCT
                i.dogovor_da,
                i.dogovor_nu,
                68,
                c.c#id,
                a_note
            FROM
                t3_pay_import i
                JOIN t3_contractors c ON ( i.inn = c.c#inn )
                LEFT JOIN t3_contracts d ON ( d.c#contractor_id = c.c#id
                                              AND d.c#num = i.dogovor_nu
                                              AND d.c#date = i.dogovor_da )
            WHERE
                d.c#id IS NULL;

        COMMIT;
        
        INSERT INTO t3_jobs (
            c#job_type_id,
            c#contract_id,
            c#house_id,
            c#note
        )
            SELECT DISTINCT
                i.tip_work,
                d.c#id contract_id,
                i.id_house,
                a_note
            FROM
                t3_pay_import i
                JOIN t3_contractors c ON ( i.inn = c.c#inn )
                JOIN t3_contracts d ON ( d.c#contractor_id = c.c#id
                                         AND d.c#num = i.dogovor_nu
                                         AND d.c#date = i.dogovor_da )
                LEFT JOIN t3_jobs j ON ( j.c#job_type_id = i.tip_work
                                         AND j.c#contract_id = d.c#id
                                         AND j.c#house_id = i.id_house )
            WHERE
                j.c#id IS NULL;

        COMMIT;
        
        INSERT INTO t3_pay (
            c#pay_type_id,
            c#source,
            c#sum,
            c#job_id,
            c#invoice,
            c#pay_date,
            c#note
        )
            SELECT DISTINCT
                i.tip_pl,
                i.source,
                i.summ_pl,
                j.c#id,
                i.pd_num,
                i.data_pl,
                i.prim
                || ' ('
                || a_note
                || ')'
            FROM
                t3_pay_import i
                JOIN t3_contractors c ON ( i.inn = c.c#inn )
                JOIN t3_contracts d ON ( d.c#contractor_id = c.c#id
                                         AND d.c#num = i.dogovor_nu
                                         AND d.c#date = i.dogovor_da )
                JOIN t3_jobs j ON ( j.c#job_type_id = i.tip_work
                                    AND j.c#contract_id = d.c#id
                                    AND j.c#house_id = i.id_house )
                LEFT JOIN t3_pay p ON ( p.c#sum = i.summ_pl
                                        AND p.c#invoice = i.pd_num
                                        AND p.c#pay_date = i.data_pl )
            WHERE
                p.c#id IS NULL;

        COMMIT;
    END do#import;
-----------------------------------

    FUNCTION lst#houses_pays (
        p_date_beg DATE,
        p_date_end DATE
    ) RETURN SYS_REFCURSOR AS
        res   SYS_REFCURSOR;
    BEGIN
        OPEN res FOR WITH pays AS (
            SELECT
                house_id,
                SUM(
                    CASE
                        WHEN pay_source = 'OWNERS' THEN pay_sum
                        ELSE 0
                    END
                ) owners_pay_sum,
                SUM(
                    CASE
                        WHEN pay_source = 'GOS' THEN pay_sum
                        ELSE 0
                    END
                ) gos_pay_sum,
                SUM(pay_sum) total_pay_sum
            FROM
                v3_pay v
            WHERE
--                    (((JOB_DATE_BEGIN is not null and JOB_DATE_END is not null)
--                        and ((p_DATE_BEG BETWEEN JOB_DATE_BEGIN and JOB_DATE_END)
--                                or (p_DATE_END BETWEEN JOB_DATE_BEGIN and JOB_DATE_END)))
--                    or  CONTRACT_DATE BETWEEN p_DATE_BEG AND p_DATE_END)
                nvl(job_date_begin,contract_date) BETWEEN p_date_beg AND p_date_end
                AND   contract_type_name <> '«ачеты'
                AND   pay_type_name <> '«ачеты'
            GROUP BY
                house_id
        ),sel1 AS (
            SELECT
                p.house_id,
                addr,
                owners_pay_sum,
                gos_pay_sum,
                total_pay_sum,
                acc_type,
                regexp_substr(addr,'[^ ]+',1) rn
            FROM
                pays p
                LEFT JOIN fcr.mv_houses_adreses a ON ( a.house_id = p.house_id )
                LEFT JOIN fcr.v#house_acc_type t ON ( a.house_id = t.house_id )
            ORDER BY
                addr
        ),totals AS (
            SELECT
                rn,
                SUM(owners_pay_sum) rn_owners_pay_sum,
                SUM(gos_pay_sum) rn_gos_pay_sum,
                SUM(total_pay_sum) rn_total_pay_sum
            FROM
                sel1
            GROUP BY
                rn
        ) SELECT
            sel1.*,
            rn_owners_pay_sum,
            rn_gos_pay_sum,
            rn_total_pay_sum
          FROM
            sel1
            JOIN totals ON ( sel1.rn = totals.rn );

        RETURN res;
    END lst#houses_pays;

END p3utils;
/
