--------------------------------------------------------
--  DDL for Trigger TR#B_OPS_KIND#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OPS_KIND#GEN_ID" 
 before insert
 on T#B_OPS_KIND
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#B_OPS_KIND.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#B_OPS_KIND#GEN_ID" ENABLE;
