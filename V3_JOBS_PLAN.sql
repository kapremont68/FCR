--------------------------------------------------------
--  DDL for View V3_JOBS_PLAN
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V3_JOBS_PLAN" ("ID", "JOB_TYPE_ID", "REC_DATE", "YEAR_BEG", "YEAR_END", "NOTE", "HOUSE_ID", "SUMM", "IS_FIRST", "IS_LAST") AS 
  with
    minmax as (
        select
            C#HOUSE_ID,
            C#REG_JOB_TYPE_ID,
            MIN(C#REC_DATE) FIRST_DATE,
            MAX(C#REC_DATE) LAST_DATE
        from
            T3_JOBS_PLAN
        group by
            C#HOUSE_ID,
            C#REG_JOB_TYPE_ID
            
    )
    ,fl as (
        select
            JP.*
            ,CASE WHEN C#REC_DATE = MM.FIRST_DATE THEN 'Y' ELSE 'N' END IS_FIRST
            ,CASE WHEN C#REC_DATE = MM.LAST_DATE THEN 'Y' ELSE 'N' END IS_LAST
        from            
            T3_JOBS_PLAN JP
            join minmax MM on (JP.C#HOUSE_ID = MM.C#HOUSE_ID and JP.C#REG_JOB_TYPE_ID = MM.C#REG_JOB_TYPE_ID)
    )
select 
    C#ID ID,
    C#REG_JOB_TYPE_ID JOB_TYPE_ID,
    C#REC_DATE REC_DATE,
    C#YEAR_BEG YEAR_BEG,
    C#YEAR_END YEAR_END,
    C#NOTE NOTE,
    C#HOUSE_ID HOUSE_ID,
    C#SUMM SUMM,
    IS_FIRST,
    IS_LAST
from 
    fl
;
