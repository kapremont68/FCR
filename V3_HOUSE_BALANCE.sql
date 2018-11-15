--------------------------------------------------------
--  DDL for View V3_HOUSE_BALANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V3_HOUSE_BALANCE" ("HOUSE_ID", "MN", "PERIOD", "CHARGE_SUM_MN", "CHARGE_SUM_TOTAL", "PAY_SUM_MN", "PAY_SUM_TOTAL", "PENI_SUM_MN", "PENI_SUM_TOTAL", "BARTER_SUM_MN", "BARTER_SUM_TOTAL", "DOLG_SUM_MN", "DOLG_SUM_TOTAL", "JOB_SUM_MN", "JOB_SUM_TOTAL", "OWNERS_JOB_SUM_MN", "OWNERS_JOB_SUM_TOTAL", "GOS_JOB_SUM_MN", "GOS_JOB_SUM_TOTAL", "BALANCE_SUM_MN", "BALANCE_SUM_TOTAL") AS 
  with
    hpay as (
        select distinct
            C#HOUSE_ID HOUSE_ID
        from
            T#OP OP
            join T#ACCOUNT A on (OP.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
    ),
    hjob as (
        select distinct
            C#HOUSE_ID HOUSE_ID
        from
            T3_PAY P
            join T3_JOBS J on (P.C#JOB_ID = J.C#ID)
    )
    ,hcharge as (
        select distinct
            C#HOUSE_ID HOUSE_ID
        from
            T#CHARGE CH
            join T#ACCOUNT A on (CH.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
    )
    ,mns as (
        --select distinct c#a_mn mn from t#charge
        SELECT 162 + LEVEL - 1 mn FROM dual CONNECT BY LEVEL <= MONTHS_BETWEEN(trunc(sysdate,'MM'),date '2000-12-01') - 162 + 1
    )
    ,hs as (
        select HOUSE_ID from hpay
        union
        select HOUSE_ID from hjob
        union
        select HOUSE_ID from hcharge
    )
    ,hmn as (
        select * from hs cross join mns
    ),
    charge as (
        select
            C#HOUSE_ID,
            c#a_mn MN,
            SUM(C#SUM) CHARGE_SUM_MN
        from
            T#CHARGE CH
            join T#ACCOUNT A on (CH.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
        group by
            C#HOUSE_ID,
            c#a_mn
    ),
    mn_charge as (
        select
            hmn.HOUSE_ID,
            hmn.MN,
            NVL(CHARGE_SUM_MN,0) CHARGE_SUM_MN
        from
            hmn
            left join charge on (hmn.HOUSE_ID = charge.C#HOUSE_ID and hmn.MN = charge.MN)
    ),
    mn_pay as (
        select
            C#HOUSE_ID HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01') MN,
            SUM(C#SUM) PAY_SUM_MN
        from
            V#OP2 OP
            join T#ACCOUNT A on (OP.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
        where
             C#TYPE_TAG = 'P'
        group by
            C#HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01')
    ),
    mn_peni as (
        select
            C#HOUSE_ID HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01') MN,
            SUM(C#SUM) PENI_SUM_MN
        from
            V#OP2 OP
            join T#ACCOUNT A on (OP.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
        where
            C#TYPE_TAG = 'FP'
        group by
            C#HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01')
    ),
    mn_job as (
        select
            C#HOUSE_ID HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#PAY_DATE,'MM'),date '2000-12-01') MN,
            SUM(CASE WHEN P.C#SOURCE = 'OWNERS' THEN C#SUM ELSE 0 END) OWNERS_JOB_SUM_MN,
            SUM(CASE WHEN P.C#SOURCE = 'GOS' THEN C#SUM ELSE 0 END) GOS_JOB_SUM_MN,
            SUM(C#SUM) JOB_SUM_MN
        from
            T3_PAY P
            join T3_JOBS J on (P.C#JOB_ID = J.C#ID)
        group by
            C#HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#PAY_DATE,'MM'),date '2000-12-01')
    ),
    mn_barter as (
        select
            C#HOUSE_ID HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01') MN,
            SUM(C#SUMMA) BARTER_SUM_MN
        from
            T#PAY_SOURCE PS
            join T#ACCOUNT A on (PS.C#ACC_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
        where
             C#COD_RKC = 88
        group by
            C#HOUSE_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01')
    ),
    mn_all as (
        select
            c.HOUSE_ID,
            c.MN,
            CHARGE_SUM_MN,
            NVL(PAY_SUM_MN,0) PAY_SUM_MN,
            NVL(PENI_SUM_MN,0) PENI_SUM_MN,
            NVL(BARTER_SUM_MN,0) BARTER_SUM_MN,
            NVL(JOB_SUM_MN,0) JOB_SUM_MN,
            NVL(OWNERS_JOB_SUM_MN,0) OWNERS_JOB_SUM_MN,
            NVL(GOS_JOB_SUM_MN,0) GOS_JOB_SUM_MN
        from
            mn_charge c
            left join mn_pay p on(c.house_id = p.house_id and c.mn = p.mn)
            left join mn_peni pn on(c.house_id = pn.house_id and c.mn = pn.mn)
            left join mn_job j on(c.house_id = j.house_id and c.mn = j.mn)
            left join mn_barter b on(c.house_id = b.house_id and  c.mn = b.mn)
    ),
    total as (
        select
            HOUSE_ID,
            MN,
            CHARGE_SUM_MN,
            sum(CHARGE_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) CHARGE_SUM_TOTAL,
            PAY_SUM_MN,
            sum(PAY_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) PAY_SUM_TOTAL,
            PENI_SUM_MN,
            sum(PENI_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) PENI_SUM_TOTAL,
            JOB_SUM_MN,
            sum(JOB_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) JOB_SUM_TOTAL,
            OWNERS_JOB_SUM_MN,
            sum(OWNERS_JOB_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) OWNERS_JOB_SUM_TOTAL,
            GOS_JOB_SUM_MN,
            sum(GOS_JOB_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) GOS_JOB_SUM_TOTAL,
            BARTER_SUM_MN,
            sum(BARTER_SUM_MN) over(PARTITION BY HOUSE_ID order by MN) BARTER_SUM_TOTAL
        from
            mn_all
    ),
    alls as (
        select
            HOUSE_ID,
            MN,
            P#MN_UTILS.GET#PERIOD(MN) PERIOD,
            CHARGE_SUM_MN,
            CHARGE_SUM_TOTAL,
            PAY_SUM_MN,
            PAY_SUM_TOTAL,
            PENI_SUM_MN,
            PENI_SUM_TOTAL,
            BARTER_SUM_MN,
            BARTER_SUM_TOTAL,
            CHARGE_SUM_MN-PAY_SUM_MN DOLG_SUM_MN,
            CHARGE_SUM_TOTAL-PAY_SUM_TOTAL DOLG_SUM_TOTAL,
            JOB_SUM_MN,
            JOB_SUM_TOTAL,
            OWNERS_JOB_SUM_MN,
            OWNERS_JOB_SUM_TOTAL,
            GOS_JOB_SUM_MN,
            GOS_JOB_SUM_TOTAL,
            PAY_SUM_MN-OWNERS_JOB_SUM_MN BALANCE_SUM_MN,
            PAY_SUM_TOTAL-OWNERS_JOB_SUM_TOTAL BALANCE_SUM_TOTAL
        from
            total
    )
select
    "HOUSE_ID","MN","PERIOD","CHARGE_SUM_MN","CHARGE_SUM_TOTAL","PAY_SUM_MN","PAY_SUM_TOTAL","PENI_SUM_MN","PENI_SUM_TOTAL","BARTER_SUM_MN","BARTER_SUM_TOTAL","DOLG_SUM_MN","DOLG_SUM_TOTAL","JOB_SUM_MN","JOB_SUM_TOTAL","OWNERS_JOB_SUM_MN","OWNERS_JOB_SUM_TOTAL","GOS_JOB_SUM_MN","GOS_JOB_SUM_TOTAL","BALANCE_SUM_MN","BALANCE_SUM_TOTAL"
from
    alls
;
