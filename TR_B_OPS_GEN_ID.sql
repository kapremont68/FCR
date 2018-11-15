--------------------------------------------------------
--  DDL for Trigger TR#B_OPS#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OPS#GEN_ID" 
 before insert
 on T#B_OPS
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#B_OPS.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#B_OPS#GEN_ID" ENABLE;
