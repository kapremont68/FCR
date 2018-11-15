--------------------------------------------------------
--  DDL for Trigger TR#B_STORE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_STORE#GEN_ID" 
 before insert
 on T#B_STORE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#B_STORE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#B_STORE#GEN_ID" ENABLE;
