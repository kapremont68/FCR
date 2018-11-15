--------------------------------------------------------
--  DDL for View V_ACCOUNT_BALANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_ACCOUNT_BALANCE" ("HOUSE_ID", "ROOMS_ID", "FLAT_NUM", "ACCOUNT_ID", "END_ACCOUNT_MN", "MN", "PERIOD", "CHARGE_SUM_MN", "CHARGE_SUM_TOTAL", "PAY_SUM_MN", "PAY_SUM_TOTAL", "PENI_SUM_MN", "PENI_SUM_TOTAL", "BARTER_SUM_MN", "BARTER_SUM_TOTAL", "DOLG_SUM_MN", "DOLG_SUM_TOTAL") AS 
  with
    hpay as (
        select distinct
            C#HOUSE_ID HOUSE_ID
            ,A.C#ID ACCOUNT_ID
        from
            T#OP OP
            join T#ACCOUNT A on (OP.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
    )
    ,hcharge as (
        select distinct
            C#HOUSE_ID HOUSE_ID
            ,A.C#ID ACCOUNT_ID
        from
            T#CHARGE CH
            join T#ACCOUNT A on (CH.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
    )
    ,mns as (
        SELECT 162 + LEVEL - 1 mn FROM dual CONNECT BY LEVEL <= MONTHS_BETWEEN(trunc(sysdate,'MM'),date '2000-12-01') - 162 + 1
    )
    ,hs as (
        select HOUSE_ID, ACCOUNT_ID from hpay
        union
        select HOUSE_ID, ACCOUNT_ID from hcharge
    )
    ,hmn as (
        select * from hs cross join mns
    ),
    charge as (
        select
            C#HOUSE_ID HOUSE_ID,
            A.C#ID ACCOUNT_ID,
            c#a_mn MN,
            SUM(C#SUM) CHARGE_SUM_MN
        from
            T#CHARGE CH
            join T#ACCOUNT A on (CH.C#ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
        group by
            C#HOUSE_ID,
            A.C#ID,
            c#a_mn
    ),
    mn_charge as (
        select
            hmn.HOUSE_ID,
            hmn.ACCOUNT_ID,
            hmn.MN,
            NVL(CHARGE_SUM_MN,0) CHARGE_SUM_MN
        from
            hmn
            left join charge on (hmn.HOUSE_ID = charge.HOUSE_ID and hmn.ACCOUNT_ID = charge.ACCOUNT_ID and hmn.MN = charge.MN)
    ),
    mn_pay as (
        select
            C#HOUSE_ID HOUSE_ID,
            A.C#ID ACCOUNT_ID,
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
            A.C#ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01')
    ),
    mn_barter as (
        select
            C#HOUSE_ID HOUSE_ID,
            A.C#ID ACCOUNT_ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01') MN,
            SUM(C#SUMMA) BARTER_SUM_MN
        from
            T#PAY_SOURCE PS
            join T#ACCOUNT A on (coalesce(PS.C#ACC_ID,C#ACC_ID_TTER,C#ACC_ID_CLOSE) = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
        where
             C#COD_RKC = 88
        group by
            C#HOUSE_ID,
            A.C#ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01')
    ),
    mn_peni as (
        select
            C#HOUSE_ID HOUSE_ID,
            A.C#ID ACCOUNT_ID,
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
            A.C#ID,
            MONTHS_BETWEEN(trunc(C#REAL_DATE,'MM'),date '2000-12-01')
    ),
    mn_all as (
        select
            c.HOUSE_ID,
            c.ACCOUNT_ID,
            c.MN,
            CHARGE_SUM_MN,
            NVL(PAY_SUM_MN,0) PAY_SUM_MN,
            NVL(PENI_SUM_MN,0) PENI_SUM_MN,
            NVL(BARTER_SUM_MN,0) BARTER_SUM_MN
        from
            mn_charge c
            left join mn_pay p on(c.house_id = p.house_id and c.account_id = p.account_id and c.mn = p.mn)
            left join mn_peni pn on(c.house_id = pn.house_id and c.account_id = pn.account_id and  c.mn = pn.mn)
            left join mn_barter b on(c.house_id = b.house_id and c.account_id = b.account_id and  c.mn = b.mn)
    ),
    total as (
        select
            HOUSE_ID,
            ACCOUNT_ID,
            MN,
            CHARGE_SUM_MN,
            sum(CHARGE_SUM_MN) over(PARTITION BY HOUSE_ID, ACCOUNT_ID order by MN) CHARGE_SUM_TOTAL,
            PAY_SUM_MN,
            sum(PAY_SUM_MN) over(PARTITION BY HOUSE_ID, ACCOUNT_ID order by MN) PAY_SUM_TOTAL,
            PENI_SUM_MN,
            sum(PENI_SUM_MN) over(PARTITION BY HOUSE_ID, ACCOUNT_ID order by MN) PENI_SUM_TOTAL,
            BARTER_SUM_MN,
            sum(BARTER_SUM_MN) over(PARTITION BY HOUSE_ID, ACCOUNT_ID order by MN) BARTER_SUM_TOTAL
        from
            mn_all
    ),
    alls as (
        select
            HOUSE_ID,
            R.C#ID ROOMS_ID,
            R.C#FLAT_NUM FLAT_NUM,
            ACCOUNT_ID,
            NVL(MONTHS_BETWEEN(trunc(L.C#END_DATE,'MM'),date '2000-12-01'),1000) END_ACCOUNT_MN,
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
            CHARGE_SUM_TOTAL-PAY_SUM_TOTAL DOLG_SUM_TOTAL
        from
            total T
            join T#ACCOUNT A on (T.ACCOUNT_ID = A.C#ID)
            join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
            join V#ACC_LAST_END L on (T.ACCOUNT_ID = L.C#ACCOUNT_ID)
    )
select
  "HOUSE_ID","ROOMS_ID","FLAT_NUM","ACCOUNT_ID","END_ACCOUNT_MN","MN","PERIOD","CHARGE_SUM_MN","CHARGE_SUM_TOTAL","PAY_SUM_MN","PAY_SUM_TOTAL","PENI_SUM_MN","PENI_SUM_TOTAL","BARTER_SUM_MN","BARTER_SUM_TOTAL","DOLG_SUM_MN","DOLG_SUM_TOTAL"
from
    alls
;
