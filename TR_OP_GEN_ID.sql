--------------------------------------------------------
--  DDL for Trigger TR#OP#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OP#GEN_ID" 
 before insert
 on T#OP
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#OP.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#OP#GEN_ID" ENABLE;
