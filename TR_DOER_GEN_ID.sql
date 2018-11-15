--------------------------------------------------------
--  DDL for Trigger TR#DOER#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#DOER#GEN_ID" 
 before insert
 on T#DOER
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#DOER.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#DOER#GEN_ID" ENABLE;
