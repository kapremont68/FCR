--------------------------------------------------------
--  DDL for Trigger TR#LOG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#LOG" 
BEFORE INSERT ON T#LOG 
for each row
   WHEN (new.C#ID is null) begin
 :new.C#ID := S#LOG.NEXTVAL;
END;
/
ALTER TRIGGER "FCR"."TR#LOG" ENABLE;
