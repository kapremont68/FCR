--------------------------------------------------------
--  DDL for Trigger TR#CLOSE_VD#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CLOSE_VD#STOP_MOD" 
 before update or delete
 on T#CLOSE_VD
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'CLOSE_VD#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'�������� ��������� ('||case when UPDATING then 'update' else 'delete' end||' on "CLOSE_VD").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#CLOSE_VD#STOP_MOD" ENABLE;
