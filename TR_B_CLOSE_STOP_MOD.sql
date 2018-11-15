--------------------------------------------------------
--  DDL for Trigger TR#B_CLOSE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_CLOSE#STOP_MOD" 
 before update or delete
 on T#B_CLOSE
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'B_CLOSE#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена ('||case when UPDATING then 'update' else 'delete' end||' on "B_CLOSE").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#B_CLOSE#STOP_MOD" ENABLE;
