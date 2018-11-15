--------------------------------------------------------
--  DDL for Trigger TR#ROOMS_SPEC#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ROOMS_SPEC#GEN_ID" 
 before insert
 on T#ROOMS_SPEC
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#ROOMS_SPEC.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#ROOMS_SPEC#GEN_ID" ENABLE;
