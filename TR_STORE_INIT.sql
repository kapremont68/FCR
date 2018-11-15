--------------------------------------------------------
--  DDL for Trigger TR#STORE#INIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#STORE#INIT" 
 before insert
 on T#STORE
 for each row
begin
 --P#TR_UTILS.DO#INIT_OBJ(:new.C#ACCOUNT_ID, :new.C#WORK_ID, :new.C#DOER_ID);
 null;
end;


/
ALTER TRIGGER "FCR"."TR#STORE#INIT" ENABLE;
