--------------------------------------------------------
--  DDL for Trigger T_TYPE_ST_RESOLUTION_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_TYPE_ST_RESOLUTION_TRG_GEN" 
before insert
 on T_TYPE_ST_RESOLUTION
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#TYPE_STATUS_CLAIM.nextval;
end;
/
ALTER TRIGGER "FCR"."T_TYPE_ST_RESOLUTION_TRG_GEN" ENABLE;
