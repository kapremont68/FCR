--------------------------------------------------------
--  DDL for Trigger TR#SERVICE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#SERVICE#GEN_ID" 
 before insert
 on T#SERVICE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#SERVICE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#SERVICE#GEN_ID" ENABLE;
