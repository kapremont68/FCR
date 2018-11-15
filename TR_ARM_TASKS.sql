--------------------------------------------------------
--  DDL for Trigger TR#ARM_TASKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ARM_TASKS" 
BEFORE INSERT ON T#ARM_TASKS 
for each row
   WHEN (new.C#KEY is null) begin
 :new.C#KEY := S#ARM_TASKS.nextval;
END;
/
ALTER TRIGGER "FCR"."TR#ARM_TASKS" ENABLE;
