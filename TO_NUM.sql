--------------------------------------------------------
--  DDL for Function TO_NUM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."TO_NUM" (A$VALUE in varchar2) return number deterministic is
 V$R number;
begin
 if A$VALUE is not null
 then
  declare
   V$L number := LENGTH(A$VALUE);
   V$I number := 1;
  begin
   loop
    exit when V$I > V$L or SUBSTR(A$VALUE, V$I, 1) not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
    V$I := V$I + 1;
   end loop;
   if V$I > 1
   then
    V$R := TO_NUMBER(SUBSTR(A$VALUE, 1, V$I - 1));
   else
    V$R := 0;
   end if;
   if V$I <= V$L
   then
    declare
     V$RE number := 0;
    begin
     loop
      exit when V$I > V$L;
      V$RE := V$RE + ASCII(SUBSTR(A$VALUE, V$I, 1));
      V$I := V$I + 1;
     end loop;
     V$R := V$R + 1 - (1 / V$RE);
    end;
   end if;
  end;
 end if;
 return V$R;
end;

/
