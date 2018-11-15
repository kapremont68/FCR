--------------------------------------------------------
--  DDL for Trigger TR#OMSU_VD#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OMSU_VD#SIGN" 
 before insert
 on T#OMSU_VD
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := Get_Current_User;
end;
/
ALTER TRIGGER "FCR"."TR#OMSU_VD#SIGN" ENABLE;
