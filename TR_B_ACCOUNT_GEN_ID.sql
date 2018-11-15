--------------------------------------------------------
--  DDL for Trigger TR#B_ACCOUNT#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_ACCOUNT#GEN_ID" 
 before insert
 on T#B_ACCOUNT
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#B_ACCOUNT.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#B_ACCOUNT#GEN_ID" ENABLE;
