--------------------------------------------------------
--  DDL for Trigger TR#B_OPS#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OPS#STOP_MOD" 
 before update or delete
 on T#B_OPS
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'B_OPS#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена ('||case when UPDATING then 'update' else 'delete' end||' on "B_OPS").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#B_OPS#STOP_MOD" ENABLE;
