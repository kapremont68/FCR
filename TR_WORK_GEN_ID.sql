--------------------------------------------------------
--  DDL for Trigger TR#WORK#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#WORK#GEN_ID" 
 before insert
 on T#WORK
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#WORK.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#WORK#GEN_ID" ENABLE;
