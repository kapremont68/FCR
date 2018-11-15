--------------------------------------------------------
--  DDL for Trigger TR#PERSON#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#PERSON#GEN_ID" 
 before insert
 on T#PERSON
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#PERSON.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#PERSON#GEN_ID" ENABLE;
