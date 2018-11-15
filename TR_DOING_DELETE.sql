--------------------------------------------------------
--  DDL for Trigger TR#DOING#DELETE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#DOING#DELETE" 
  before delete on t#doing  
  for each row
declare
begin
   insert into TT#TR_FLAG (C#VAL) values ('DOING_VD#PASS_MOD');
    delete from fcr.t#doing_vd where c#id = :old.c#id;  
   commit;
exception 
   when OTHERS then 
     rollback;   
end TR#DOING#DELETE;

/
ALTER TRIGGER "FCR"."TR#DOING#DELETE" DISABLE;
