--------------------------------------------------------
--  DDL for Trigger TR#WORKS#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#WORKS#GEN_ID" 
 before insert
 on T#WORKS
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#WORKS.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#WORKS#GEN_ID" ENABLE;
