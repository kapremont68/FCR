--------------------------------------------------------
--  DDL for Trigger TR#ADDR_OBJ#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ADDR_OBJ#GEN_ID" 
 before insert
 on T#ADDR_OBJ
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#ADDR_OBJ.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#ADDR_OBJ#GEN_ID" ENABLE;
