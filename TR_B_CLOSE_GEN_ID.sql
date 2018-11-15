--------------------------------------------------------
--  DDL for Trigger TR#B_CLOSE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_CLOSE#GEN_ID" 
 before insert
 on T#B_CLOSE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#B_CLOSE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#B_CLOSE#GEN_ID" ENABLE;
