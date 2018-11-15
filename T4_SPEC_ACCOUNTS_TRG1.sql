--------------------------------------------------------
--  DDL for Trigger T4_SPEC_ACCOUNTS_TRG1
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T4_SPEC_ACCOUNTS_TRG1" 
BEFORE INSERT ON T4_SPEC_ACCOUNTS 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FCR"."T4_SPEC_ACCOUNTS_TRG1" ENABLE;
