--------------------------------------------------------
--  DDL for Trigger TR#B_OP_VD#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OP_VD#SIGN" 
 before insert
 on T#B_OP_VD
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := Get_Current_User;
end;
/
ALTER TRIGGER "FCR"."TR#B_OP_VD#SIGN" ENABLE;
