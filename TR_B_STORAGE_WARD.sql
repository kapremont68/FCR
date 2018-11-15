--------------------------------------------------------
--  DDL for Trigger TR#B_STORAGE#WARD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_STORAGE#WARD" 
 for insert or delete
 on T#B_STORAGE
 compound trigger
 type TTAB#I
  is table of number
  index by varchar2(200)
 ;
 ATAB#I TTAB#I;
 ATAB#H_S_MN TTAB#TR_H_S_MN := TTAB#TR_H_S_MN();
 A#OPEN_MN number;
 before statement is
 begin
  A#OPEN_MN := P#UTILS.GET#OPEN_B_MN;
 end before statement;
 after each row is
  procedure DO#PROC(A#H_ID number, A#S_ID number, A#MN number) is
   A#I_I varchar2(200) := A#H_ID||'&'||A#S_ID;
  begin
   if not ATAB#I.exists(A#I_I)
   then
    ATAB#H_S_MN.extend;
    ATAB#H_S_MN(ATAB#H_S_MN.count) := TOBJ#TR_H_S_MN(A#H_ID, A#S_ID, A#MN);
    ATAB#I(A#I_I) := ATAB#H_S_MN.count;
   elsif nvl(ATAB#H_S_MN(ATAB#I(A#I_I)).F#MN, A#MN + 1) > A#MN
   then
    ATAB#H_S_MN(ATAB#I(A#I_I)).F#MN := A#MN;
   end if;
  end;
 begin
  if INSERTING
  then
   if A#OPEN_MN > :new.C#MN - 1
   then
    DO#PROC(:new.C#HOUSE_ID, :new.C#SERVICE_ID, :new.C#MN - 1);
   end if;
  else
   if A#OPEN_MN > :old.C#MN - 1
   then
    DO#PROC(:old.C#HOUSE_ID, :old.C#SERVICE_ID, :old.C#MN - 1);
   end if;
  end if;
 end after each row;
 after statement is
 begin
  P#TR_UTILS.DO#WARD_B_CLOSE(ATAB#H_S_MN, case when INSERTING then 'I' else 'D' end, 'B_STORAGE');
 end after statement;
end;
/
ALTER TRIGGER "FCR"."TR#B_STORAGE#WARD" ENABLE;
