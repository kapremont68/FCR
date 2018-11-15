--------------------------------------------------------
--  DDL for Trigger TR#B_OP#INIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OP#INIT" 
 before insert
 on T#B_OP
 for each row
begin
 P#TR_UTILS.DO#INIT_B_OBJ(:new.C#HOUSE_ID, :new.C#SERVICE_ID, :new.C#B_ACCOUNT_ID);
end;


/
ALTER TRIGGER "FCR"."TR#B_OP#INIT" ENABLE;
