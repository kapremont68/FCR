--------------------------------------------------------
--  DDL for Trigger TR#HOUSE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#HOUSE#GEN_ID" 
 before insert
 on T#HOUSE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#HOUSE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#HOUSE#GEN_ID" ENABLE;
