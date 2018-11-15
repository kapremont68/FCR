--------------------------------------------------------
--  DDL for Trigger TR#HOUSE_WALL_TYPE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#HOUSE_WALL_TYPE#GEN_ID" 
 before insert
 on T#HOUSE_WALL_TYPE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#HOUSE_WALL_TYPE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#HOUSE_WALL_TYPE#GEN_ID" ENABLE;
