--------------------------------------------------------
--  DDL for Trigger T_DATA_DEFENDANT_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_DATA_DEFENDANT_TRG_GEN" 
before insert
 on T_DATA_DEFENDANT
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#DATA_DEFENDANT.nextval;
end;
/
ALTER TRIGGER "FCR"."T_DATA_DEFENDANT_TRG_GEN" ENABLE;
