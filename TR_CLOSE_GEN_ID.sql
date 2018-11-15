--------------------------------------------------------
--  DDL for Trigger TR#CLOSE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CLOSE#GEN_ID" 
 before insert
 on T#CLOSE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#CLOSE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#CLOSE#GEN_ID" ENABLE;
