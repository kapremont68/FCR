--------------------------------------------------------
--  DDL for Trigger T#OMSU_VD_TRG1
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T#OMSU_VD_TRG1" 
BEFORE INSERT ON T#OMSU_VD 
FOR EACH ROW 
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    NULL;
  END COLUMN_SEQUENCES;
END;
/
ALTER TRIGGER "FCR"."T#OMSU_VD_TRG1" ENABLE;
