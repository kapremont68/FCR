--------------------------------------------------------
--  DDL for View V4_BALANCE_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V4_BALANCE_ALL" ("HOUSE_ID", "ADDR", "PAY_SUM_TOTAL", "OWNERS_JOB_SUM_TOTAL", "TRANSFER_SUM_TOTAL", "BALANCE") AS 
  with
    tran as (
        SELECT
            C#HOUSE_ID HOUSE_ID,
            sum(c#sum) TRANSFER_SUM_TOTAL
        FROM
            T4_TRANSFER P
        GROUP BY
            C#HOUSE_ID
    )
    ,pays as (
        select
            HOUSE_ID,
            PAY_SUM_TOTAL,
            OWNERS_JOB_SUM_TOTAL
        from
            V3_HOUSE_BALANCE
        where
            MN = (select max(MN) from T#TOTAL_HOUSE where CHARGE_SUM_MN > 0)
    )
    ,alls as (
        SELECT
            I.C#HOUSE_ID HOUSE_ID,
            ADDR,
            PAY_SUM_TOTAL,
            OWNERS_JOB_SUM_TOTAL,
            TRANSFER_SUM_TOTAL,
            PAY_SUM_TOTAL-TRANSFER_SUM_TOTAL-OWNERS_JOB_SUM_TOTAL BALANCE
        from
            T#HOUSE_INFO I
            left join tran on (I.C#HOUSE_ID = tran.HOUSE_ID)
            left join pays on (I.C#HOUSE_ID = pays.HOUSE_ID)
            LEFT JOIN FCR.MV_HOUSES_ADRESES HA on (I.C#HOUSE_ID = HA.HOUSE_ID)
    )
select
    "HOUSE_ID","ADDR","PAY_SUM_TOTAL","OWNERS_JOB_SUM_TOTAL","TRANSFER_SUM_TOTAL","BALANCE"
from
    alls
;
