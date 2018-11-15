--------------------------------------------------------
--  DDL for Trigger TR#STORAGE#WARD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#STORAGE#WARD" 
 for insert or delete
 on T#STORAGE
 compound trigger
 type TTAB#I
  is table of number
  index by varchar2(200)
 ;
 ATAB#I TTAB#I;
 ATAB#A_W_MN TTAB#TR_A_W_MN := TTAB#TR_A_W_MN();
 A#OPEN_MN number;
 before statement is
 begin
  A#OPEN_MN := P#UTILS.GET#OPEN_MN;
 end before statement;
 after each row is
  procedure DO#PROC(A#A_ID number, A#W_ID number, A#MN number) is
   A#I_I varchar2(200) := A#A_ID||'&'||A#W_ID;
  begin
   if not ATAB#I.exists(A#I_I)
   then
    ATAB#A_W_MN.extend;
    ATAB#A_W_MN(ATAB#A_W_MN.count) := TOBJ#TR_A_W_MN(A#A_ID, A#W_ID, A#MN);
    ATAB#I(A#I_I) := ATAB#A_W_MN.count;
   elsif nvl(ATAB#A_W_MN(ATAB#I(A#I_I)).F#MN, A#MN + 1) > A#MN
   then
    ATAB#A_W_MN(ATAB#I(A#I_I)).F#MN := A#MN;
   end if;
  end;
 begin
  if INSERTING
  then
   if A#OPEN_MN > :new.C#MN - 1
   then
    DO#PROC(:new.C#ACCOUNT_ID, :new.C#WORK_ID, :new.C#MN - 1);
   end if;
  else
   if A#OPEN_MN > :old.C#MN - 1
   then
    DO#PROC(:old.C#ACCOUNT_ID, :old.C#WORK_ID, :old.C#MN - 1);
   end if;
  end if;
 end after each row;
 after statement is
 begin
  P#TR_UTILS.DO#WARD_CLOSE(ATAB#A_W_MN, case when INSERTING then 'I' else 'D' end, 'STORAGE');
 end after statement;
end;
/
ALTER TRIGGER "FCR"."TR#STORAGE#WARD" ENABLE;
