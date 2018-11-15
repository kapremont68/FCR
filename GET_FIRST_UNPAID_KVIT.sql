--------------------------------------------------------
--  DDL for Function GET_FIRST_UNPAID_KVIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_FIRST_UNPAID_KVIT" (A#N number, A#MN_LO number, A#MN_OPEN number :=null) return NUMBER is
res number;
OPEN_MN number;
begin

select max(v.C#MN) into OPEN_MN 
  from v#close v
 where 1 = 1
   and v.C#VALID_TAG = 'Y'
;

select min(c.C#B_MN) into res
  from fcr.v#chop c
 where 1 = 1
   and c.C#ACCOUNT_ID = A#N
   and c.C#B_MN >= A#MN_LO
   and c.C#B_MN <= nvl(A#MN_OPEN, OPEN_MN)
   and fcr.get_paid_kvit(c.C#ACCOUNT_ID, c.C#B_MN, 1) in (2, 3, 4, 5, 6, 7)
;
 return res;
end;

/
