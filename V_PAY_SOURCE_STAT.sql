--------------------------------------------------------
--  DDL for View V#PAY_SOURCE_STAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#PAY_SOURCE_STAT" ("REAL_PER", "RKC_CODE", "FILE_ID", "TOTAL_ACC_COUNT", "OPS_ACC_COUNT", "NOT_OPS_ACC_COUNT", "TOTAL_PAY_COUNT", "OPS_PAY_COUNT", "NOT_OPS_PAY_COUNT", "TOTAL_SUMM", "OPS_SUMM", "NOT_OPS_SUMM") AS 
  with
    erc as (
        select 
            TO_CHAR(PS.C#REAL_DATE,'yyyymm') REAL_PER
            ,PS.*
        from 
            T#PAY_SOURCE PS
        where
            C#COD_RKC is not null
--            and C#COD_RKC  in (0,1,3,4,5,51,52,53,55)
    )
    ,ops_acc_count as (
        select
            REAL_PER
            ,C#COD_RKC RKC_CODE
            ,C#FILE_ID FILE_ID
            ,count(distinct c#account) OPS_ACC_COUNT
        from
            erc
        where
            C#OPS_ID is not null
        group by
            REAL_PER
            ,C#FILE_ID
            ,C#COD_RKC
    )
    ,not_ops_acc_count as (
        select
            REAL_PER
            ,C#COD_RKC RKC_CODE
            ,C#FILE_ID FILE_ID
            ,count(distinct c#account) NOT_OPS_ACC_COUNT
        from
            erc
        where
            C#OPS_ID is null
        group by
            REAL_PER
            ,C#FILE_ID
            ,C#COD_RKC
    )
    ,summ as (
        select
            REAL_PER
            ,C#COD_RKC RKC_CODE
            ,C#FILE_ID FILE_ID
            ,count(distinct c#account) TOTAL_ACC_COUNT
            ,count(*) TOTAL_PAY_COUNT
            ,sum(CASE WHEN C#OPS_ID is null then 0 else 1 END) OPS_PAY_COUNT
            ,sum(CASE WHEN C#OPS_ID is null then 1 else 0 END) NOT_OPS_PAY_COUNT
            ,sum(c#summa) TOTAL_SUMM
            ,sum(CASE WHEN C#OPS_ID is null then 0 else c#summa END) OPS_SUMM
            ,sum(CASE WHEN C#OPS_ID is null then c#summa else 0 END) NOT_OPS_SUMM
        from
            erc
        group by
            REAL_PER
            ,C#FILE_ID
            ,C#COD_RKC
    )
    ,alls as (
        select
            s.REAL_PER,
            s.RKC_CODE,
            s.FILE_ID,
            TOTAL_ACC_COUNT,
            OPS_ACC_COUNT,
            NOT_OPS_ACC_COUNT,
            TOTAL_PAY_COUNT,
            OPS_PAY_COUNT,
            NOT_OPS_PAY_COUNT,
            TOTAL_SUMM,
            OPS_SUMM,
            NOT_OPS_SUMM
        from
            summ s
            join ops_acc_count ops on (s.REAL_PER = ops.REAL_PER and s.RKC_CODE = ops.RKC_CODE and s.FILE_ID = ops.FILE_ID)
            join not_ops_acc_count nops on (s.REAL_PER = nops.REAL_PER and s.RKC_CODE = nops.RKC_CODE and s.FILE_ID = nops.FILE_ID)
    )
select
    "REAL_PER","RKC_CODE","FILE_ID","TOTAL_ACC_COUNT","OPS_ACC_COUNT","NOT_OPS_ACC_COUNT","TOTAL_PAY_COUNT","OPS_PAY_COUNT","NOT_OPS_PAY_COUNT","TOTAL_SUMM","OPS_SUMM","NOT_OPS_SUMM"
from
    alls
;
