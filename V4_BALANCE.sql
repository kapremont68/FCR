--------------------------------------------------------
--  DDL for View V4_BALANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V4_BALANCE" ("HOUSE_ID", "ADDR", "CHARGE_SUM_TOTAL", "PAY_SUM_TOTAL", "OWNERS_JOB_SUM_TOTAL", "TRANSFER_SUM_TOTAL", "BALANCE") AS 
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
            CHARGE_SUM_TOTAL,
            PAY_SUM_TOTAL,
            OWNERS_JOB_SUM_TOTAL
        from
--             MV_HOUSE_BALANCE
            T#TOTAL_HOUSE
        where
            MN = (select max(MN) from T#TOTAL_HOUSE where CHARGE_SUM_MN > 0)
    )
    ,alls as (
        SELECT
            I.C#HOUSE_ID HOUSE_ID,
            ADDR,
            NVL(CHARGE_SUM_TOTAL,0) CHARGE_SUM_TOTAL,
            NVL(PAY_SUM_TOTAL,0) PAY_SUM_TOTAL,
            NVL(OWNERS_JOB_SUM_TOTAL,0) OWNERS_JOB_SUM_TOTAL,
            NVL(TRANSFER_SUM_TOTAL,0) TRANSFER_SUM_TOTAL,
            NVL(PAY_SUM_TOTAL,0)-NVL(TRANSFER_SUM_TOTAL,0)-NVL(OWNERS_JOB_SUM_TOTAL,0) BALANCE
        from
            T#HOUSE_INFO I
            left join tran on (I.C#HOUSE_ID = tran.HOUSE_ID)
            left join pays on (I.C#HOUSE_ID = pays.HOUSE_ID)
            LEFT JOIN FCR.MV_HOUSES_ADRESES HA on (I.C#HOUSE_ID = HA.HOUSE_ID)
        where
            I.C#END_DATE is not null
            and NVL(CHARGE_SUM_TOTAL,0) > 0
            and C#VOTE_TEXT not like '%не в программе%'
            and LOWER(C#VOTE_TEXT) not like '%исключен%'
            and (LOWER(C#ORG_NAME) not like '%исключен%' or C#ORG_NAME is null)
            and LOWER(C#VOTE_TEXT) not like '%блокирован%'
            and LOWER(C#VOTE_TEXT) not like '%аварий%'
            and exists (select * from V#ROOMS where C#HOUSE_ID = I.C#HOUSE_ID)
    )
select
    "HOUSE_ID","ADDR","CHARGE_SUM_TOTAL","PAY_SUM_TOTAL","OWNERS_JOB_SUM_TOTAL","TRANSFER_SUM_TOTAL","BALANCE"
from
    alls
;
