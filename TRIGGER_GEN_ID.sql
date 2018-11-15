--------------------------------------------------------
--  DDL for Trigger TRIGGER_GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TRIGGER_GEN_ID" 
BEFORE INSERT ON "REGDOCS_INPUT" 
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#REGDOCS.nextval;
END;
/
ALTER TRIGGER "FCR"."TRIGGER_GEN_ID" ENABLE;
