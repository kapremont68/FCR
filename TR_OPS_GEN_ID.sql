--------------------------------------------------------
--  DDL for Trigger TR#OPS#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OPS#GEN_ID" 
 before insert
 on T#OPS
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#OPS.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#OPS#GEN_ID" ENABLE;
