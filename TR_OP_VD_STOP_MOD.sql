--------------------------------------------------------
--  DDL for Trigger TR#OP_VD#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OP_VD#STOP_MOD" 
 before update or delete
 on T#OP_VD
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'OP_VD#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена ('||case when UPDATING then 'update' else 'delete' end||' on "OP_VD").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#OP_VD#STOP_MOD" ENABLE;
