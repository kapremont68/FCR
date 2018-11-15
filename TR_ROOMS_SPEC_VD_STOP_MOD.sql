--------------------------------------------------------
--  DDL for Trigger TR#ROOMS_SPEC_VD#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ROOMS_SPEC_VD#STOP_MOD" 
 before update or delete
 on T#ROOMS_SPEC_VD
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'ROOMS_SPEC_VD#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена ('||case when UPDATING then 'update' else 'delete' end||' on "ROOMS_SPEC_VD").');
 end if;
end;
/
ALTER TRIGGER "FCR"."TR#ROOMS_SPEC_VD#STOP_MOD" ENABLE;
