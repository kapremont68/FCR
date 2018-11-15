--------------------------------------------------------
--  DDL for Function GET_ACC_FOR_PAY_TTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_FOR_PAY_TTER" (A#N varchar2, A#M_DATE date) return NUMBER is
res number;
res3  NUMBER;
res4 number;
begin
    select max(A.C#ID) into res3
      from T#ACCOUNT A, T#ACCOUNT_VD A_VD
          ,T#ACCOUNT_OP OP

     where 1 = 1
       and A.C#DATE <= last_day(A#M_DATE)
       and OP.C#OUT_NUM = 
       
       
       (
          select max((select max(op.c#out_num)
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )) 
            from fcr2.full_pay_4 fp
           where 1 = 1
             and fp.ls = A#N
             and fp.acc_id is null and fp.acc_id_close is null
             and fp.cod_rkc in (51, 52)
             and exists (select 1
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )
             and length(fp.ls) > 8
             and (select count(op.c#out_num)
                    from fcr.t#account_op op
                   where 1 = 1 
                     and op.c#out_num like '%'||fp.ls
                     and op.c#out_proc_id = 2
                  ) = 1
          ) 
       and A_VD.C#ID = A.C#ID
       and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
       and A_VD.C#VALID_TAG = 'Y'
       and OP.C#ACCOUNT_ID = A.C#ID
       and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
       and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)

      ;

if res3 is not null then res:= res3;
else 

    select max(A.C#ID) into res4
      from T#ACCOUNT A, T#ACCOUNT_VD A_VD
          ,T#ACCOUNT_OP OP
         
     where 1 = 1
--       and A.C#DATE <= last_day(A#M_DATE)
       and OP.C#OUT_NUM = 
       
       
       (
          select max((select max(op.c#out_num)
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )) 
            from fcr2.full_pay_4 fp
           where 1 = 1
             and fp.ls = A#N
             and fp.acc_id is null and fp.acc_id_close is null
             and fp.cod_rkc in (51, 52)
             and exists (select 1
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )
             and length(fp.ls) > 8
             and (select count(op.c#out_num)
                    from fcr.t#account_op op
                   where 1 = 1 
                     and op.c#out_num like '%'||fp.ls
                     and op.c#out_proc_id = 2
                  ) = 1
          ) 
       
       and A_VD.C#ID = A.C#ID
       and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
       and A_VD.C#VALID_TAG = 'Y'
       and OP.C#ACCOUNT_ID = A.C#ID
--       and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
--       and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)

      ;
res:= res4;
end if;
 return res;
end;

/
