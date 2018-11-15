--------------------------------------------------------
--  DDL for Trigger T#ARM_OBJ
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T#ARM_OBJ" 
BEFORE INSERT ON T#ARM_OBJEKTS 
for each row
   WHEN (new.C#KEY is null) begin
 :new.C#KEY := S#ARM_OBJEKTS.nextval;
END;
/
ALTER TRIGGER "FCR"."T#ARM_OBJ" ENABLE;
