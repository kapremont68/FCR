--------------------------------------------------------
--  DDL for Trigger T_PERSON_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_PERSON_TRG_GEN" 
before insert
 on T_PERSON
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#JPERSON.nextval;
end;
/
ALTER TRIGGER "FCR"."T_PERSON_TRG_GEN" ENABLE;
