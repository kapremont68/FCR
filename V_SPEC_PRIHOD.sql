--------------------------------------------------------
--  DDL for View V_SPEC_PRIHOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_SPEC_PRIHOD" ("HOUSE_ID", "SPEC_PRIHOD_SUM") AS 
  select
    ID_HOUSE HOUSE_ID,
    SUM(REPLACE(PAY,'.',',')) SPEC_PRIHOD_SUM
from
    SPEC_PRIHOD
GROUP BY
    ID_HOUSE
;
