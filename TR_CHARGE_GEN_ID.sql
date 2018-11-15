--------------------------------------------------------
--  DDL for Trigger TR#CHARGE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CHARGE#GEN_ID" 
 before insert
 on T#CHARGE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#CHARGE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#CHARGE#GEN_ID" ENABLE;
