--------------------------------------------------------
--  DDL for Trigger TR#B_STORE#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_STORE#STOP_MOD" 
 before update
 on T#B_STORE
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'B_STORE#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена (update on "B_STORE").');
 end if;
end;


/
ALTER TRIGGER "FCR"."TR#B_STORE#STOP_MOD" ENABLE;
