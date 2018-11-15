--------------------------------------------------------
--  DDL for Trigger TR#FILE_PAY#DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#FILE_PAY#DELETE" 
  before delete on t#file_pay  
  for each row
declare
begin
    delete from fcr.t#pay_source where c#file_id = :old.c#id;
end TR#FILE_PAY#DELETE;

/
ALTER TRIGGER "FCR"."TR#FILE_PAY#DELETE" ENABLE;
