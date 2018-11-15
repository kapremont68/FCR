--------------------------------------------------------
--  DDL for Trigger TR#OP_VD#WARD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OP_VD#WARD" 
 for insert
 on T#OP_VD
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
  A#A_ID number;
  A#W_ID number;
  A#MN number;
  A#I_I varchar2(200);
 begin
  select C#ACCOUNT_ID, C#WORK_ID, P#MN_UTILS.GET#MN(C#DATE)
    into A#A_ID, A#W_ID, A#MN
    from T#OP
   where C#ID = :new.C#ID
  ;
  if A#OPEN_MN > A#MN
  then
   A#I_I := A#A_ID||'&'||A#W_ID;
   if not ATAB#I.exists(A#I_I)
   then
    ATAB#A_W_MN.extend;
    ATAB#A_W_MN(ATAB#A_W_MN.count) := TOBJ#TR_A_W_MN(A#A_ID, A#W_ID, A#MN);
    ATAB#I(A#I_I) := ATAB#A_W_MN.count;
   elsif nvl(ATAB#A_W_MN(ATAB#I(A#I_I)).F#MN, A#MN + 1) > A#MN
   then
    ATAB#A_W_MN(ATAB#I(A#I_I)).F#MN := A#MN;
   end if;
  end if;
 end after each row;
 after statement is
 begin
  P#TR_UTILS.DO#WARD_CLOSE(ATAB#A_W_MN, 'I', 'OP_VD');
 end after statement;
end;
/
ALTER TRIGGER "FCR"."TR#OP_VD#WARD" ENABLE;
