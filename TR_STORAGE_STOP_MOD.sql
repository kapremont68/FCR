--------------------------------------------------------
--  DDL for Trigger TR#STORAGE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#STORAGE#STOP_MOD" 
 before update
 on T#STORAGE
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'STORAGE#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена (update on "STORAGE").');
 end if;
end;


/
ALTER TRIGGER "FCR"."TR#STORAGE#STOP_MOD" DISABLE;
