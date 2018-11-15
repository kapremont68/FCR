--------------------------------------------------------
--  DDL for Trigger TR#ACCOUNT#STOP_MOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#ACCOUNT#STOP_MOD" 
 before update or delete
 on T#ACCOUNT
declare
 A#I number;
begin
 select count(*)
   into A#I
   from TT#TR_FLAG
  where C#VAL = 'ACCOUNT#PASS_MOD'
 ;
 if A#I = 0
 then
  raise_application_error(-20000,'Операция запрещена ('||case when UPDATING then 'update' else 'delete' end||' on "ACCOUNT").');
 end if;
end;

/
ALTER TRIGGER "FCR"."TR#ACCOUNT#STOP_MOD" DISABLE;
