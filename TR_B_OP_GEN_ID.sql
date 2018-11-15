--------------------------------------------------------
--  DDL for Trigger TR#B_OP#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OP#GEN_ID" 
 before insert
 on T#B_OP
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#B_OP.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#B_OP#GEN_ID" ENABLE;
