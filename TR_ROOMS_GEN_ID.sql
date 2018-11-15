--------------------------------------------------------
--  DDL for Trigger TR#ROOMS#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ROOMS#GEN_ID" 
 before insert
 on T#ROOMS
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#ROOMS.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#ROOMS#GEN_ID" ENABLE;
