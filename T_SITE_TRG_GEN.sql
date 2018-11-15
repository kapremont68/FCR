--------------------------------------------------------
--  DDL for Trigger T_SITE_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_SITE_TRG_GEN" 
before
INSERT
  ON T_SITE FOR EACH row  WHEN (
    new.C_ID IS NULL
  ) BEGIN :new.C_ID := S#SITE.nextval;
END;
/
ALTER TRIGGER "FCR"."T_SITE_TRG_GEN" ENABLE;
