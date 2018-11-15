--------------------------------------------------------
--  DDL for View V3_JOBS_PLAN_KR
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V3_JOBS_PLAN_KR" ("HOUSE_ID", "JOB_TYPE_ID", "JOB_TYPE_ID2", "REG_JOB_TYPE_ID", "ELEM_CODE", "YEAR_BEG", "YEAR_END", "JOB_TYPE_NAME") AS 
  with
    plan as (
        SELECT
            C#HOUSE_ID          HOUSE_ID,
            T.C#ID              JOB_TYPE_ID,
            T.C#ID              JOB_TYPE_ID2,
            t.C#REG_JOB_TYPE_ID REG_JOB_TYPE_ID,
            C#ELEM_CODE         ELEM_CODE,
            C#YEAR_BEG YEAR_BEG,
            C#YEAR_END YEAR_END,
            T.C#NAME            JOB_TYPE_NAME
        --     R.C#NAME REG_JOB_TYPE_NAME
        FROM
            T3_JOB_TYPE T
            JOIN T3_REG_JOB_TYPE R ON (T.C#REG_JOB_TYPE_ID = R.C#ID)
            LEFT JOIN T3_JOBS_PLAN P ON (R.C#ID = P.C#REG_JOB_TYPE_ID)
        WHERE
            T.C#ID IN (1, 2, 3, 4, 5, 6, 8, 9, 10, 11)
            AND P.C#REG_JOB_TYPE_ID <> 1075
    )
    ,doc as (
        SELECT
            HOUSE_ID,
            T.C#ID              JOB_TYPE_ID,
            P.JOB_TYPE_ID              JOB_TYPE_ID2,
            t.C#REG_JOB_TYPE_ID REG_JOB_TYPE_ID,
            C#ELEM_CODE         ELEM_CODE,
            YEAR_BEG,
            YEAR_END,
            T.C#NAME||' ('||P.JOB_TYPE_NAME||')' JOB_TYPE_NAME
        FROM
            T3_JOB_TYPE T
            join plan P on (T.C#ID IN (21,64))
    )
    ,alls as (
        SELECT * from plan
        union all
        SELECT * from doc

    )
select
    "HOUSE_ID","JOB_TYPE_ID","JOB_TYPE_ID2","REG_JOB_TYPE_ID","ELEM_CODE","YEAR_BEG","YEAR_END","JOB_TYPE_NAME"
from
    alls
where
    JOB_TYPE_ID2 not in (select JOB_TYPE_ID from V3_JOBS where HOUSE_ID = alls.HOUSE_ID)
;
