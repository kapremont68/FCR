--------------------------------------------------------
--  DDL for Trigger TR#WORK#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#WORK#STOP_MOD" 
 before update or delete
 on T#WORK
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'WORK#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'�������� ��������� ('||case when UPDATING then 'update' else 'delete' end||' on "WORK").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#WORK#STOP_MOD" ENABLE;
