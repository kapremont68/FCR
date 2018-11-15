--------------------------------------------------------
--  DDL for Trigger TR#B_STORE#INIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_STORE#INIT" 
 before insert
 on T#B_STORE
 for each row
begin
 P#TR_UTILS.DO#INIT_B_OBJ(:new.C#HOUSE_ID, :new.C#SERVICE_ID, :new.C#B_ACCOUNT_ID);
 --null;
end;


/
ALTER TRIGGER "FCR"."TR#B_STORE#INIT" ENABLE;
