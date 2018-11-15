--------------------------------------------------------
--  DDL for Function GET#SUBSTR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#SUBSTR" 
 (
  A#S varchar2 --source
 ,A#D varchar2 --delim
 ,A#I integer --index (zero-based, negative from right)
 ) return varchar2 deterministic is
 A#P1 integer;
 A#P2 integer;
begin
 case
  when A#I = 0 then
  begin
   A#P1 := 1;
   A#P2 := instr(A#S,A#D,1,1);
   if A#P2 = 0
   then
    A#P2 := length(A#S) + 1;
   end if;
  end;
  when A#I > 0 then
  begin
   A#P1 := instr(A#S,A#D,1,A#I);
   A#P1 := case when A#P1 > 0 then A#P1+length(A#D) end;
   A#P2 := case when A#P1 > 0 then instr(A#S,A#D,A#P1,1) end;
   if A#P2 = 0
   then
    A#P2 := length(A#S) + 1;
   end if;
  end;
  when A#I = -1 then
  begin
   A#P1 := instr(A#S,A#D,-1,1);
   A#P1 := case when A#P1 > 0 then A#P1+length(A#D) else case when A#P1 = 0 then 1 end end;
   A#P2 := length(A#S) + 1;
  end;
  when A#I < -1 then
  begin
   A#P2 := instr(A#S,A#D,-1,abs(A#I)-1);
   A#P1 := case when A#P2 > 0 then instr(A#S,A#D,A#P2-length(A#S)-2,1) end;
   A#P1 := case when A#P1 > 0 then A#P1+length(A#D) else case when A#P1 = 0 then 1 end end;
  end;
  else
   null;
 end case;
 return substr(A#S,A#P1,A#P2-A#P1);
end;

/
