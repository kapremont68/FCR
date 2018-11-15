--------------------------------------------------------
--  DDL for View V#1C_ABSENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#1C_ABSENT" ("ALL_DATE", "DAY_OF_WEEK") AS 
  with
    alls as (
        SELECT data1 + rownum - 1 ALL_DATE
        FROM all_objects,
            (SELECT
                 (SELECT min(DATA)
                  FROM T#RAW_1C_V101) data1,
                 sysdate              data2
             FROM dual)
        WHERE rownum <= data2 - data1 + 1
    )
    ,exist as (
        SELECT
            distinct DATA
        FROM
            T#RAW_1C_V101
    )
select
    ALL_DATE,
    TO_CHAR (ALL_DATE,'DY','NLS_DATE_LANGUAGE = RUSSIAN') day_of_week
from
    alls a
    left join exist e on (a.ALL_DATE = e.DATA)
where
    e.DATA is null
order by
    ALL_DATE
;
