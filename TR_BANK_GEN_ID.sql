--------------------------------------------------------
--  DDL for Trigger TR#BANK#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#BANK#GEN_ID" 
 before insert
 on T#BANK
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#BANK.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#BANK#GEN_ID" ENABLE;
