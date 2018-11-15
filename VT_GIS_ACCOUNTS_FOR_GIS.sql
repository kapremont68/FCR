--------------------------------------------------------
--  DDL for View VT#GIS_ACCOUNTS_FOR_GIS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."VT#GIS_ACCOUNTS_FOR_GIS" ("ACCOUNT_ID", "ACCOUNT_NUM", "FAM", "IM", "OTCH", "ROOM_NUM", "LIVING_TAG", "FLAT_NUM", "AREA_VAL", "FIAS_GUID", "ROW_NUM") AS 
  select
    ACCOUNT_ID,
    ACCOUNT_NUM,
    FAM,
    IM,
    OTCH,
    REGEXP_REPLACE(TRIM(ROOM_NUM), ', 0*', ', ') ROOM_NUM,
    LIVING_TAG,
    REGEXP_REPLACE(TRIM(FLAT_NUM), '^0*', '') FLAT_NUM,
    AREA_VAL,
    FIAS_GUID,
    ROWNUM ROW_NUM
from
    TT#GIS_ACCLIST_FOR_GIS
-- where
--     ROOM_NUM like '%Марта%'
--     and FLAT_NUM like '0%'
ORDER BY
    ROW_NUM
;
