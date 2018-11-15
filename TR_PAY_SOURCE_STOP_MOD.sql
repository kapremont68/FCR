--------------------------------------------------------
--  DDL for Trigger TR#PAY_SOURCE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#PAY_SOURCE#STOP_MOD" 
BEFORE DELETE
    ON T#PAY_SOURCE
FOR EACH ROW
--     declare
--     pragma autonomous_transaction;
begin
 if NOT :OLD.C#OPS_ID is NULL
 then
  fcr.del#op(:OLD.C#OPS_ID); 
  --raise_application_error(-20000,'Операция запрещена delete on "PAY_SOURCE").');
 end if;
end;
/
ALTER TRIGGER "FCR"."TR#PAY_SOURCE#STOP_MOD" ENABLE;
