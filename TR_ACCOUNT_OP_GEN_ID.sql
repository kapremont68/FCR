--------------------------------------------------------
--  DDL for Trigger TR#ACCOUNT_OP#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ACCOUNT_OP#GEN_ID" 
 before insert
 on T#ACCOUNT_OP
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#ACCOUNT_OP.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#ACCOUNT_OP#GEN_ID" ENABLE;
