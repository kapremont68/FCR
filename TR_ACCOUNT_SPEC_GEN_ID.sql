--------------------------------------------------------
--  DDL for Trigger TR#ACCOUNT_SPEC#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ACCOUNT_SPEC#GEN_ID" 
 before insert
 on T#ACCOUNT_SPEC
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#ACCOUNT_SPEC.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#ACCOUNT_SPEC#GEN_ID" ENABLE;
