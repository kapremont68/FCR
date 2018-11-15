--------------------------------------------------------
--  DDL for Trigger T_DEFENDANT_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_DEFENDANT_TRG_GEN" 
before insert
 on T_DEFENDANT
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#DEFENDANT.nextval;
end;
/
ALTER TRIGGER "FCR"."T_DEFENDANT_TRG_GEN" ENABLE;
