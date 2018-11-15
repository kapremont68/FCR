--------------------------------------------------------
--  DDL for Trigger TR#CHARGE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CHARGE#STOP_MOD" 
 before update
 on T#CHARGE
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'CHARGE#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена (update on "CHARGE").');
 end if;
end;


/
ALTER TRIGGER "FCR"."TR#CHARGE#STOP_MOD" ENABLE;
