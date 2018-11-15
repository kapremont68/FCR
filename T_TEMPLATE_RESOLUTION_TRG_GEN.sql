--------------------------------------------------------
--  DDL for Trigger T_TEMPLATE_RESOLUTION_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_TEMPLATE_RESOLUTION_TRG_GEN" 
before insert
 on T_TEMPLATE_RESOLUTION
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#TEMPLATE_RESOLUTION.nextval;
end;
/
ALTER TRIGGER "FCR"."T_TEMPLATE_RESOLUTION_TRG_GEN" ENABLE;
