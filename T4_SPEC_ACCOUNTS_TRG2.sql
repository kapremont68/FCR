--------------------------------------------------------
--  DDL for Trigger T4_SPEC_ACCOUNTS_TRG2
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T4_SPEC_ACCOUNTS_TRG2" 
BEFORE INSERT ON T4_SPEC_ACCOUNTS 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FCR"."T4_SPEC_ACCOUNTS_TRG2" ENABLE;
