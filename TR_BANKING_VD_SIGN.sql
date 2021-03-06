--------------------------------------------------------
--  DDL for Trigger TR#BANKING_VD#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#BANKING_VD#SIGN" 
 before insert
 on T#BANKING_VD
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := Get_Current_User;
end;
/
ALTER TRIGGER "FCR"."TR#BANKING_VD#SIGN" ENABLE;
