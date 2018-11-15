--------------------------------------------------------
--  DDL for Trigger TR#ACCOUNT_SPEC_VD#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ACCOUNT_SPEC_VD#SIGN" 
 before insert
 on T#ACCOUNT_SPEC_VD
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := Get_Current_User;
end;
/
ALTER TRIGGER "FCR"."TR#ACCOUNT_SPEC_VD#SIGN" ENABLE;
