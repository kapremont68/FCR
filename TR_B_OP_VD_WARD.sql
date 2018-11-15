--------------------------------------------------------
--  DDL for Trigger TR#B_OP_VD#WARD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_OP_VD#WARD" 
 for insert
 on T#B_OP_VD
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
  A#H_ID number;
  A#S_ID number;
  A#MN number;
  A#I_I varchar2(200);
 begin
  select C#HOUSE_ID, C#SERVICE_ID, P#MN_UTILS.GET#MN(C#DATE)
    into A#H_ID, A#S_ID, A#MN
    from T#B_OP
   where C#ID = :new.C#ID
  ;
  if A#OPEN_MN > A#MN
  then
   A#I_I := A#H_ID||'&'||A#S_ID;
   if not ATAB#I.exists(A#I_I)
   then
    ATAB#H_S_MN.extend;
    ATAB#H_S_MN(ATAB#H_S_MN.count) := TOBJ#TR_H_S_MN(A#H_ID, A#S_ID, A#MN);
    ATAB#I(A#I_I) := ATAB#H_S_MN.count;
   elsif nvl(ATAB#H_S_MN(ATAB#I(A#I_I)).F#MN, A#MN + 1) > A#MN
   then
    ATAB#H_S_MN(ATAB#I(A#I_I)).F#MN := A#MN;
   end if;
  end if;
 end after each row;
 after statement is
 begin
  P#TR_UTILS.DO#WARD_B_CLOSE(ATAB#H_S_MN, 'I', 'B_OP_VD');
 end after statement;
end;
/
ALTER TRIGGER "FCR"."TR#B_OP_VD#WARD" ENABLE;
