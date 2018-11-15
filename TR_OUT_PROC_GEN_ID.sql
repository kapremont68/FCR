--------------------------------------------------------
--  DDL for Trigger TR#OUT_PROC#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OUT_PROC#GEN_ID" 
 before insert
 on T#OUT_PROC
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#OUT_PROC.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#OUT_PROC#GEN_ID" ENABLE;
