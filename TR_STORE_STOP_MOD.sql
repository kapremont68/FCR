--------------------------------------------------------
--  DDL for Trigger TR#STORE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#STORE#STOP_MOD" 
 before update
 on T#STORE
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'STORE#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена (update on "STORE").');
 end if;
end;


/
ALTER TRIGGER "FCR"."TR#STORE#STOP_MOD" DISABLE;
