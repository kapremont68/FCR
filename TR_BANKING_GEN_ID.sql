--------------------------------------------------------
--  DDL for Trigger TR#BANKING#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#BANKING#GEN_ID" 
 before insert
 on T#BANKING
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#BANKING.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#BANKING#GEN_ID" ENABLE;
