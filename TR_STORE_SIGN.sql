--------------------------------------------------------
--  DDL for Trigger TR#STORE#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#STORE#SIGN" 
 before insert
 on T#STORE
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := 1;
end;


/
ALTER TRIGGER "FCR"."TR#STORE#SIGN" ENABLE;
