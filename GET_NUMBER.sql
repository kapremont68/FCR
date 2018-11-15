--------------------------------------------------------
--  DDL for Function GET#NUMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#NUMBER" (A#NUM varchar2) return number deterministic is
 A#RES number;
begin
 if A#NUM is not null
 then
  declare
   A#L number := length(A#NUM);
   A#I number := 1;
  begin
   loop
    exit when substr(A#NUM,A#I,1) not in ('0','1','2','3','4','5','6','7','8','9');
    A#I := A#I + 1;
    exit when A#I > A#L;
   end loop;
   A#RES := case when A#I > 1 then to_number(substr(A#NUM,1,A#I - 1)) else -1 end;
   if A#I <= A#L
   then
    declare
     A#RES_ADDON number := 0;
    begin
     loop
      A#RES_ADDON := A#RES_ADDON + ascii(substr(A#NUM,A#I,1))*(A#L - A#I + 1)*256;
      A#I := A#I + 1;
      exit when A#I > A#L;
     end loop;
     A#RES := A#RES + 1 - 1/A#RES_ADDON;
    end;
   end if;
  end;
 end if;
 return A#RES;
end;

/
