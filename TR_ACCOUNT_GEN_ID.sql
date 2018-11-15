--------------------------------------------------------
--  DDL for Trigger TR#ACCOUNT#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ACCOUNT#GEN_ID" 
 before insert
 on T#ACCOUNT
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#ACCOUNT.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#ACCOUNT#GEN_ID" ENABLE;
