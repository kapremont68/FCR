--------------------------------------------------------
--  DDL for Trigger TR#OP#INIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OP#INIT" 
 before insert
 on T#OP
 for each row
begin
 P#TR_UTILS.DO#INIT_OBJ(:new.C#ACCOUNT_ID, :new.C#WORK_ID, :new.C#DOER_ID);
end;


/
ALTER TRIGGER "FCR"."TR#OP#INIT" ENABLE;
