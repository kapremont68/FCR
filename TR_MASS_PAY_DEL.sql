--------------------------------------------------------
--  DDL for Trigger TR#MASS_PAY_DEL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#MASS_PAY_DEL" 
    BEFORE DELETE
    ON T#MASS_PAY
    FOR EACH ROW
    BEGIN
 if :OLD.C#OPS_ID is not NULL then
  fcr.del#op2(:OLD.C#OPS_ID);
 end if;
END;
/
ALTER TRIGGER "FCR"."TR#MASS_PAY_DEL" ENABLE;
