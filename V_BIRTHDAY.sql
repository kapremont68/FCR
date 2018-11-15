--------------------------------------------------------
--  DDL for View V#BIRTHDAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#BIRTHDAY" ("FIO", "BIRTHDAY", "DAYS_TO_BIRTHDAY", "NEW_AGE") AS 
  SELECT
    substr(T.FIO,1,50) FIO,
    TO_CHAR(BIRTHDAY,'dd.mm.yyyy') BIRTHDAY,
    DAYS_TO_BIRTHDAY,
    EXTRACT(YEAR FROM (trunc(sysdate) + DAYS_TO_BIRTHDAY))-EXTRACT(YEAR FROM T.BIRTHDAY) NEW_AGE

from (
select
  FIO,
      BIRTHDAY,
  CASE WHEN TRUNC(TO_DATE(SUBSTR(TO_CHAR(BIRTHDAY),1,6)||TO_CHAR(EXTRACT(YEAR FROM sysdate)),'dd.mm.yyyy')-trunc(SYSDATE)) >= 0 THEN TRUNC(TO_DATE(SUBSTR(TO_CHAR(BIRTHDAY),1,6)||TO_CHAR(EXTRACT(YEAR FROM sysdate)),'dd.mm.yyyy')-trunc(SYSDATE))
  ELSE TRUNC(TO_DATE(SUBSTR(TO_CHAR(BIRTHDAY),1,6)||TO_CHAR(EXTRACT(YEAR FROM sysdate)+1),'dd.mm.yyyy')-trunc(SYSDATE)) END DAYS_TO_BIRTHDAY
from SOTR
      where BIRTHDAY is not null
order BY
  CASE WHEN TRUNC(TO_DATE(SUBSTR(TO_CHAR(BIRTHDAY),1,6)||TO_CHAR(EXTRACT(YEAR FROM sysdate)),'dd.mm.yyyy')-trunc(SYSDATE)) >= 0 THEN TRUNC(TO_DATE(SUBSTR(TO_CHAR(BIRTHDAY),1,6)||TO_CHAR(EXTRACT(YEAR FROM sysdate)),'dd.mm.yyyy')-trunc(SYSDATE))
  ELSE TRUNC(TO_DATE(SUBSTR(TO_CHAR(BIRTHDAY),1,6)||TO_CHAR(EXTRACT(YEAR FROM sysdate)+1),'dd.mm.yyyy')-trunc(SYSDATE)) END) T
;
