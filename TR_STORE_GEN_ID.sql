--------------------------------------------------------
--  DDL for Trigger TR#STORE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#STORE#GEN_ID" 
 before insert
 on T#STORE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#STORE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#STORE#GEN_ID" ENABLE;
