--------------------------------------------------------
--  DDL for Trigger T4_PAY_TO_HOSTS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T4_PAY_TO_HOSTS_TRG" 
BEFORE INSERT ON "T4_TRANSFER" 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FCR"."T4_PAY_TO_HOSTS_TRG" ENABLE;
