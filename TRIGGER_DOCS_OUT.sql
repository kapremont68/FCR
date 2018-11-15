--------------------------------------------------------
--  DDL for Trigger TRIGGER_DOCS_OUT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TRIGGER_DOCS_OUT" 
BEFORE INSERT ON REGDOCS_OUTPUT 
 for each row
  WHEN (new.C#KEY is null) begin
 :new.C#KEY := S#REGDOCS_OUTPUT.nextval;
END;				 
				
/
ALTER TRIGGER "FCR"."TRIGGER_DOCS_OUT" ENABLE;
