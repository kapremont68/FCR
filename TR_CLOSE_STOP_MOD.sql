--------------------------------------------------------
--  DDL for Trigger TR#CLOSE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CLOSE#STOP_MOD" 
 before update or delete
 on T#CLOSE
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'CLOSE#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена ('||case when UPDATING then 'update' else 'delete' end||' on "CLOSE").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#CLOSE#STOP_MOD" ENABLE;
