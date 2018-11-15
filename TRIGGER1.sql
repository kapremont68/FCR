--------------------------------------------------------
--  DDL for Trigger TRIGGER1
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TRIGGER1" 
BEFORE INSERT ON T#ARM 
 for each row
   WHEN (new.C#ID is null) begin
 :new.C#ID := S#ARM.nextval;
END;				 
				
/
ALTER TRIGGER "FCR"."TRIGGER1" ENABLE;
