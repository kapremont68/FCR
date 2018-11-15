--------------------------------------------------------
--  DDL for Trigger TR#DOING#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#DOING#GEN_ID" 
 before insert
 on T#DOING
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#DOING.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#DOING#GEN_ID" ENABLE;
