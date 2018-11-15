--------------------------------------------------------
--  DDL for Trigger T_ADDRESS_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_ADDRESS_TRG_GEN" 
before insert
 on T_ADDRESS
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#ADDRESS.nextval;
end;
/
ALTER TRIGGER "FCR"."T_ADDRESS_TRG_GEN" ENABLE;
