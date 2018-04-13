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

    FUNCTION get_job_summa ( p_job_id   NUMBER DEFAULT NULL ) RETURN NUMBER AS
        r_summa   NUMBER;
    BEGIN
        SELECT SUM(c#sum)
        INTO r_summa
        FROM t3_pay
        WHERE c#job_id = p_job_id;
        RETURN r_summa;
    END get_job_summa;

  FUNCTION get_house_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER AS
        r_summa   NUMBER;
    BEGIN
        SELECT SUM(c#sum)
            INTO r_summa
        from 
            T3_PAY P
            join T3_JOBS J on (P.C#JOB_ID = J.C#ID)
        where
            c#HOUSE_ID = p_HOUSE_ID;
        RETURN r_summa;
  END get_house_summa;

  FUNCTION LST#HOUSE_BALANCE(p_HOUSE_ID NUMBER) RETURN sys_refcursor AS
    res sys_refcursor;
  BEGIN
    OPEN res FOR
        with
        tran as (
            SELECT
                C#HOUSE_ID HOUSE_ID,
                sum(c#sum) TRANSFER_SUM_TOTAL
            FROM
                T4_TRANSFER P
            where
                C#HOUSE_ID = p_HOUSE_ID
            group by 
                C#HOUSE_ID
        )
        select
            V.HOUSE_ID ,
            MN ,
            PERIOD ,
            CHARGE_SUM_TOTAL ,
            PAY_SUM_TOTAL ,
            PENI_SUM_TOTAL ,
            DOLG_SUM_TOTAL ,
            JOB_SUM_TOTAL ,
            OWNERS_JOB_SUM_TOTAL ,
            GOS_JOB_SUM_TOTAL ,
            BALANCE_SUM_TOTAL,
            TRANSFER_SUM_TOTAL,
            P#TOOLS.GET_HOUSE_BALANCE_2043(p_HOUSE_ID) BALANCE_2043
        from
            V3_HOUSE_BALANCE V
            left join tran on (V.HOUSE_ID = tran.HOUSE_ID)
        where
            V.HOUSE_ID = p_HOUSE_ID
            and MN = (select max(MN) from V3_HOUSE_BALANCE where HOUSE_ID = p_HOUSE_ID)
        ;
    RETURN res;
  END LST#HOUSE_BALANCE;

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

  FUNCTION get_jobs_txt(p_HOUSE_ID NUMBER DEFAULT NULL, p_DATE_BEG DATE, p_DATE_END DATE) RETURN NVARCHAR2 AS
    JOBS_TXT VARCHAR2(5000);
  BEGIN
    select 
        LISTAGG(JOB_TYPE_NAME,'; ') WITHIN GROUP (ORDER BY JOB_TYPE_NAME) 
    into JOBS_TXT        
    from 
        (select distinct
                JOB_TYPE_NAME,
                HOUSE_ID
            from 
                v3_JOBS J
                join T3_PAY P on (P.C#JOB_ID = J.JOB_ID)
            where 
                HOUSE_ID = p_HOUSE_ID
                and P.C#PAY_DATE BETWEEN p_DATE_BEG and p_DATE_END
        )
    group by
        HOUSE_ID
    ;
    RETURN JOBS_TXT;
  END get_jobs_txt; 
  

  FUNCTION get_house_plan_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER AS
        r_summa   NUMBER;
    BEGIN
        SELECT SUM(plan_sum)
            INTO r_summa
        from 
            V3_JOBS
        where
            HOUSE_ID = p_HOUSE_ID;
        RETURN r_summa;
  END get_house_plan_summa;

  PROCEDURE DO#IMPORT AS
    a_NOTE VARCHAR2(100);
  BEGIN
        a_NOTE := 'P3UTILS.DO#IMPORT: '||sysdate;
        
        delete from T3_PAY_IMPORT
        where ROWID not in (
          SELECT MIN(ROWID) RID
          FROM
            T3_PAY_IMPORT
          GROUP BY
            DATA_PL,
            SUMM_PL,
            PD_NUM,
            INN,
            ID_HOUSE,
            DOGOVOR_DA,
            DOGOVOR_NU
        )
        ;
        commit;
  
         insert into T3_CONTRACTORS (C#INN, C#NAME)
         select distinct
           INN,
           PLAT
         from
           T3_PAY_IMPORT I
           left join T3_CONTRACTORS C on (I.INN = C.C#INN)
         WHERE
           C.C#ID is null
         ;
        commit;
        
         insert into T3_CONTRACTS (C#DATE, C#NUM, C#CONTRACT_TYPE_ID, C#CONTRACTOR_ID, C#DESCRIPTION)
         select distinct
           I.DOGOVOR_DA,
           I.DOGOVOR_NU,
           68,
           C.C#ID,
           a_NOTE
         from
           T3_PAY_IMPORT I
           join T3_CONTRACTORS C on (I.INN = C.C#INN)
           left join T3_CONTRACTS D on (D.C#CONTRACTOR_ID = C.C#ID and D.C#NUM = I.DOGOVOR_NU and D.C#DATE = I.DOGOVOR_DA)
         WHERE
           D.C#ID is null
         ;
        commit;
        
         insert into T3_JOBS (C#JOB_TYPE_ID, C#CONTRACT_ID, C#HOUSE_ID, C#NOTE)
         select distinct
           I.TIP_WORK,
           D.C#ID CONTRACT_ID,
           I.ID_HOUSE,
           a_NOTE
         from
           T3_PAY_IMPORT I
           join T3_CONTRACTORS C on (I.INN = C.C#INN)
           join T3_CONTRACTS D on (D.C#CONTRACTOR_ID = C.C#ID and D.C#NUM = I.DOGOVOR_NU and D.C#DATE = I.DOGOVOR_DA)
           left join T3_JOBS J on (J.C#JOB_TYPE_ID = I.TIP_WORK and J.C#CONTRACT_ID = D.C#ID and J.C#HOUSE_ID = I.ID_HOUSE)
         WHERE
           J.C#ID is null
         ;
        commit;
        
         insert into T3_PAY (
           C#PAY_TYPE_ID,
           C#SOURCE,
           C#SUM,
           C#JOB_ID,
           C#INVOICE,
           C#PAY_DATE,
           C#NOTE
         )
        select distinct
          I.TIP_PL,
          I.SOURCE,
          I.SUMM_PL,
          J.C#ID,
          I.PD_NUM,
          I.DATA_PL,
          I.PRIM||' ('||a_NOTE||')'
        from
          T3_PAY_IMPORT I
          join T3_CONTRACTORS C on (I.INN = C.C#INN)
          join T3_CONTRACTS D on (D.C#CONTRACTOR_ID = C.C#ID and D.C#NUM = I.DOGOVOR_NU and D.C#DATE = I.DOGOVOR_DA)
          join T3_JOBS J on (J.C#JOB_TYPE_ID = I.TIP_WORK and J.C#CONTRACT_ID = D.C#ID and J.C#HOUSE_ID = I.ID_HOUSE)
          left join T3_PAY P on (P.C#SUM = I.SUMM_PL and P.C#INVOICE = I.PD_NUM and P.C#PAY_DATE = I.DATA_PL)
        WHERE
          P.C#ID is null
        ;
        commit;
        
    END DO#IMPORT;

  FUNCTION LST#HOUSES_PAYS(p_DATE_BEG DATE, p_DATE_END DATE) RETURN sys_refcursor AS
    res sys_refcursor;
  BEGIN
    OPEN res FOR
        with
            pays as (
                SELECT
                    HOUSE_ID,
                    SUM(CASE WHEN PAY_SOURCE = 'OWNERS' THEN PAY_SUM ELSE 0 END) OWNERS_PAY_SUM,
                    SUM(CASE WHEN PAY_SOURCE = 'GOS' THEN PAY_SUM ELSE 0 END) GOS_PAY_SUM,
                    SUM(PAY_SUM) TOTAL_PAY_SUM
                FROM
                    V3_PAY V
                WHERE
--                    (((JOB_DATE_BEGIN is not null and JOB_DATE_END is not null)
--                        and ((p_DATE_BEG BETWEEN JOB_DATE_BEGIN and JOB_DATE_END)
--                                or (p_DATE_END BETWEEN JOB_DATE_BEGIN and JOB_DATE_END)))
--                    or  CONTRACT_DATE BETWEEN p_DATE_BEG AND p_DATE_END)
                    NVL(JOB_DATE_BEGIN,CONTRACT_DATE) BETWEEN p_DATE_BEG AND p_DATE_END
                    and CONTRACT_TYPE_NAME <> '«ачеты'
                    and PAY_TYPE_NAME <> '«ачеты'
                GROUP BY
                    HOUSE_ID
            )
            ,sel1 as (
                select
                    P.HOUSE_ID,
                    ADDR,
                    OWNERS_PAY_SUM,
                    GOS_PAY_SUM,
                    TOTAL_PAY_SUM,
                    ACC_TYPE,
                    regexp_substr(ADDR, '[^ ]+', 1) RN
                from
                    pays P
                    left join FCR.MV_HOUSES_ADRESES A on (A.HOUSE_ID = P.HOUSE_ID)
                    left join FCR.V#HOUSE_ACC_TYPE T on (A.HOUSE_ID = T.HOUSE_ID)
                order by
                    ADDR
            )
            ,totals as (
                select
                    RN,
                    SUM(OWNERS_PAY_SUM) RN_OWNERS_PAY_SUM,
                    SUM(GOS_PAY_SUM) RN_GOS_PAY_SUM,
                    SUM(TOTAL_PAY_SUM) RN_TOTAL_PAY_SUM
                from
                    sel1
                group by
                    RN
            )
            SELECT
                sel1.*,
                RN_OWNERS_PAY_SUM,
                RN_GOS_PAY_SUM,
                RN_TOTAL_PAY_SUM
            from
                sel1
                join totals on (sel1.RN = totals.RN)
            ;
    RETURN res;
  END LST#HOUSES_PAYS;

END p3utils;
/
