--------------------------------------------------------
--  DDL for Trigger TR#OMSU#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OMSU#GEN_ID" 
 before insert
 on T#OMSU
 for each row
   WHEN (new.C#ID is null) begin
 :new.C#ID := S#OMSU.nextval;
end;
/
ALTER TRIGGER "FCR"."TR#OMSU#GEN_ID" ENABLE;
