--------------------------------------------------------
--  DDL for Trigger T_STR_VD_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_STR_VD_TRG" 
BEFORE INSERT ON T_ST_RESOLUTION_VD 
for each ROW  
BEGIN
   :NEW.C_SIGN_S_ID := FCR.GET_CURRENT_USER();
   :NEW.C_SIGN_DATE := SYSDATE; 
END;
/
ALTER TRIGGER "FCR"."T_STR_VD_TRG" ENABLE;
