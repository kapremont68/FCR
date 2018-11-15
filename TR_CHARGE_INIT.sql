--------------------------------------------------------
--  DDL for Trigger TR#CHARGE#INIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CHARGE#INIT" 
 before insert
 on T#CHARGE
 for each row
begin
 P#TR_UTILS.DO#INIT_OBJ(:new.C#ACCOUNT_ID, :new.C#WORK_ID, :new.C#DOER_ID);
end;


/
ALTER TRIGGER "FCR"."TR#CHARGE#INIT" ENABLE;
