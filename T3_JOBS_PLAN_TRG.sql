--------------------------------------------------------
--  DDL for Trigger T3_JOBS_PLAN_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T3_JOBS_PLAN_TRG" 
BEFORE INSERT ON T3_JOBS_PLAN 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FCR"."T3_JOBS_PLAN_TRG" ENABLE;
