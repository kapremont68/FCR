--------------------------------------------------------
--  DDL for Trigger T4_SPEC_ACCOUNTS_OWNERS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T4_SPEC_ACCOUNTS_OWNERS_TRG" 
BEFORE INSERT ON "T4_HOSTS" 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FCR"."T4_SPEC_ACCOUNTS_OWNERS_TRG" ENABLE;
