--------------------------------------------------------
--  DDL for Procedure TRANSFER#PAY_OTHER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."TRANSFER#PAY_OTHER" (A#OP_ID in number, A#acc_id in number, A#DATE in date, A#MN in number) is

 
cursor opl is
select v.C#ACCOUNT_ID, v.C#WORK_ID, v.C#DOER_ID, v.C#DATE, v.C#REAL_DATE, v.C#A_MN, v.C#B_MN, v.C#TYPE_TAG, v.C#SUM
  from v#op v
 where v.C#VALID_TAG = 'Y'
   and v.C#ID = A#OP_ID
;

cursor nach(ls in number) is
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN, A.TO_PAY

  from 
(
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN,
       SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) TO_PAY
  from fcr.v#chop  a
where a.C#A_MN <= A#MN
  and a.C#ACCOUNT_ID = ls
GROUP BY A.C#A_MN, A.C#B_MN, A.C#WORK_ID, A.C#DOER_ID
having SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) <> 0
) A
order by case when a.to_pay < 0 then 0 else 1 end, a.c#a_mn, a.c#b_mn, a.c#work_id, a.c#doer_id
;

ops_id number;
op_id number;
pay_date date;
w_id number;
w1_id number;
d1_id number;
d_id number;
ostatok number;


kind_id number := 36;


begin
    insert into fcr.t#ops(c#id)
    values(fcr.s#ops.nextval)
    returning c#id into ops_id;

    insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
    values(ops_id, 1, 'Y', kind_id);
 
      for c in opl loop
         insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
         values(fcr.s#op.nextval, ops_id, c.C#ACCOUNT_ID, c.c#work_id, c.c#doer_id, A#DATE, c.C#REAL_DATE, c.c#a_mn, c.c#b_mn, c.C#TYPE_TAG)
         returning c#id into op_id;
                 
         insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
         values(op_id, 1, 'Y', -1*c.C#SUM);          

         PAY_DATE := A#DATE;

select max(a.C#WORK_ID), max(a.C#DOER_ID) into w_id, d_id
  from 
(
select WS.C#SERVICE_ID
     -- ,W.C#WORKS_ID
      ,W.C#ID as c#WORK_ID
--      ,W_VD.C#TAR_TYPE_TAG
--      ,W_VD.C#TAR_VAL
      ,D_VD.C#DOER_ID      
      ,row_number() over (partition by D.C#house_Id order by d.c#date desc , nvl(d_vd.c#end_date, to_date('01.01.2222','dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
            from T#DOING D,
                 T#DOING_VD D_VD,
                 T#WORK W,
                 T#WORK_VD W_VD,
                 T#WORKS WS
           where 1 = 1
             and D.C#HOUSE_ID = (select R.C#HOUSE_ID
                                   from T#ACCOUNT A, T#ROOMS R
                                  where A.C#ID =a#acc_id 
                                    and R.C#ID = A.C#ROOMS_ID
                                )
             and D.C#DATE = (select max(C#DATE) from T#DOING where C#HOUSE_ID = D.C#HOUSE_ID and C#WORKS_ID = D.C#WORKS_ID and C#DATE <= A#DATE)
             and D_VD.C#ID = D.C#ID
             and D_VD.C#VN = (select max(C#VN) from T#DOING_VD where C#ID = D_VD.C#ID)
             and D_VD.C#VALID_TAG = 'Y'
--             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
             and W.C#WORKS_ID = D.C#WORKS_ID
             and W.C#DATE = (select max(C#DATE) from T#WORK where C#WORKS_ID = W.C#WORKS_ID and C#DATE < A#DATE)
             and W_VD.C#ID = W.C#ID
             and W_VD.C#VN = (select max(C#VN) from T#WORK_VD where C#ID = W_VD.C#ID)
             and W_VD.C#VALID_TAG = 'Y'
             and WS.C#ID = W.C#WORKS_ID             
) a
   where a.sort_order = 1
;
--dbms_output.put_line('w_id = '||w_id);
if w_id is not null then

--dbms_output.put_line('ops_id = '||ops_id);

ostatok := c.c#sum;
if ostatok > 0 then

--dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

  for d in nach(c.c#account_id) loop
  
  if ostatok > 0 then
  
        if d.to_pay < ostatok then                  
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, a#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P')
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', d.to_pay);
           ostatok := ostatok - d.to_pay;
        else 
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, a#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, c.c#type_tag)
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', ostatok);
           ostatok := 0; 
       end if;
  end if;
  end loop;
  
  if ostatok > 0 then --Если остались деньги после всех распределений
--dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = a#acc_id
     and ch.C#A_MN = a#mn+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, a#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, c.c#type_tag)
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
  
   end if;

 

else --Отрицательная оплата  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = a#acc_id
     and ch.C#A_MN = A#MN+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;  

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, a#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, c.c#type_tag)
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
end if;
end if;
  end loop; 
  
end TRANSFER#PAY_OTHER;

/
