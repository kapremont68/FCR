--------------------------------------------------------
--  DDL for Trigger T_SC_VD_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_SC_VD_TRG_GEN" 
BEFORE INSERT ON T_STATUS_CLAIM_VD 
for each row
BEGIN
  :NEW.C_SIGN_S_ID := fcr.GET_CURRENT_USER();
  :NEW.C_SIGN_DATE := sysdate;
END;
/
ALTER TRIGGER "FCR"."T_SC_VD_TRG_GEN" ENABLE;
