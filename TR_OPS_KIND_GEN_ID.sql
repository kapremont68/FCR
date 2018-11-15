--------------------------------------------------------
--  DDL for Trigger TR#OPS_KIND#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OPS_KIND#GEN_ID" 
 before insert
 on T#OPS_KIND
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#OPS_KIND.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#OPS_KIND#GEN_ID" ENABLE;
