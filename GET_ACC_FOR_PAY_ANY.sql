--------------------------------------------------------
--  DDL for Function GET_ACC_FOR_PAY_ANY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_FOR_PAY_ANY" (A#N varchar2, A#M_DATE date) return NUMBER is
flg number;
res number;
res1  NUMBER;
res2  NUMBER;
res3  NUMBER;

begin
if substr(upper(trim(A#N)),1,3) = '444' then flg := 1; else flg:= 0; end if;

select max(A.C#ID) into res1
  from T#ACCOUNT A, T#ACCOUNT_VD A_VD
      ,T#ACCOUNT_OP OP
 where 1 = 1
   and ((A.C#NUM = A#N and flg = 1)
     or (OP.C#OUT_NUM = A#N and flg = 0)
       )
   and A.C#DATE <= last_day(A#M_DATE)
   and A_VD.C#ID = A.C#ID
   and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
   and A_VD.C#VALID_TAG = 'Y'
--   and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
   and OP.C#ACCOUNT_ID = A.C#ID
   and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)
  ;

if res1 is not null then res:= res1;
else 

    select max(A.C#ID) into res2
      from T#ACCOUNT A, T#ACCOUNT_VD A_VD
          ,T#ACCOUNT_OP OP
     where 1 = 1
       and ((A.C#NUM = A#N and flg = 1)
         or (OP.C#OUT_NUM = A#N and flg = 0)
           )
 --      and A.C#DATE <= last_day(A#M_DATE)
       and A_VD.C#ID = A.C#ID
       and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
       and A_VD.C#VALID_TAG = 'Y'
    --   and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
       and OP.C#ACCOUNT_ID = A.C#ID
--       and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)
      ;
res := res2;
end if;
 return res;
end;

/
