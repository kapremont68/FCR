--------------------------------------------------------
--  DDL for Trigger TR#HOSTS_VD#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#HOSTS_VD#SIGN" 
  before insert
	on hosts_vd  
  for each row
declare
  -- local variables here
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := Get_Current_User;
end TR#HOSTS_VD#SIGN;

/
ALTER TRIGGER "FCR"."TR#HOSTS_VD#SIGN" ENABLE;
