--------------------------------------------------------
--  DDL for Trigger TR#CHARGE#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CHARGE#SIGN" 
 before insert
 on T#CHARGE
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := 1;
end;


/
ALTER TRIGGER "FCR"."TR#CHARGE#SIGN" ENABLE;
