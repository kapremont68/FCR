--------------------------------------------------------
--  DDL for Trigger TR#B_STORE#SIGN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_STORE#SIGN" 
 before insert
 on T#B_STORE
 for each row
begin
 :new.C#SIGN_DATE := sysdate;
 :new.C#SIGN_S_ID := 1;
end;


/
ALTER TRIGGER "FCR"."TR#B_STORE#SIGN" ENABLE;
