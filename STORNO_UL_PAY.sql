--------------------------------------------------------
--  DDL for Procedure STORNO#UL#PAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."STORNO#UL#PAY" (A#acc_id in number, A#date in date) is

cursor storno is
select b.*
  from
(
select a.c#ops_id, a.c#account_id, a.c#date, a.c#sum,
sum(a.c#sum) over (partition by a.C#ACCOUNT_ID) as sum_all
  from
(
select o.C#OPS_ID, o.C#ACCOUNT_ID, o.C#DATE, sum(o.C#SUM) as C#SUM
  from fcr.v#op o,
       fcr.v#ops op
 where o.C#ACCOUNT_ID = A#acc_id--532
   and o.C#OPS_ID = op.C#ID
   and op.C#KIND_ID in (32, 118)  -- c#cod in (90,91)
   and o.C#VALID_TAG = 'Y'
   and op.C#VALID_TAG = 'Y'
 group by o.C#OPS_ID, o.C#ACCOUNT_ID, o.C#DATE
) a
) b
where b.sum_all <> 0 and b.c#sum <> 0
;

cursor storno_pay(ops_id in number, acc_id in number) is

select o.C#ACCOUNT_ID, o.C#WORK_ID, o.C#DOER_ID, A#date as c#date, o.C#REAL_DATE,
       o.C#A_MN, o.C#B_MN, o.C#TYPE_TAG, o.C#SUM
  from fcr.v#op o
 where o.C#OPS_ID = ops_id
   and o.C#VALID_TAG = 'Y'
   and o.C#ACCOUNT_ID = acc_id;
   ops_id number;
   op_id number;
   kind_id number;
   mp_id number;
   old_mp_id number;
   person_id number;
   a#err varchar2(4000);
begin
for c in storno loop
begin
  select fcr.s#mass_pay.nextval into mp_id
    from dual;

    select max(m.c#id), max(m.c#person_id) into old_mp_id, person_id
      from fcr.t#mass_pay m
     where m.c#ops_id = c.C#OPS_ID;

   insert into fcr.t#ops(c#id)
    values(fcr.s#ops.nextval)
    returning c#id into ops_id;
    
--dbms_output.put_line('ops_id : '|| c.C#OPS_ID);
--dbms_output.put_line('Person_id : '|| person_id);


insert into fcr.t#mass_pay(c#id, c#person_id, c#sum, c#date, c#living_tag, c#ops_id, ñ#ostatok, c#parent_id, c#npd, c#cod_rkc, c#comment, c#remove_flg, c#acc_id, c#storno_flg)
values(mp_id, person_id, -1*c.c#sum, c.c#date, null, ops_id, null, old_mp_id, '', 91, '', null, c.C#ACCOUNT_ID, 'Y');


select ok.c#id into kind_id
  from fcr.t#ops_kind ok
 where ok.c#cod  = '91';

    insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
    values(ops_id, 1, 'Y', kind_id);


    for d in storno_pay(c.c#ops_id, c.C#ACCOUNT_ID) loop

         insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
         values(fcr.s#op.nextval, ops_id, d.C#ACCOUNT_ID, d.c#work_id, d.c#doer_id, d.c#date, d.C#REAL_DATE, d.c#a_mn, d.c#b_mn, d.C#TYPE_TAG)
         returning c#id into op_id;

         insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
         values(op_id, 1, 'Y', -1*d.C#SUM);

    end loop;
    

commit;
	exception
   when OTHERS then
        rollback;
    a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
--         insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment)
         P#EXCEPTION.LOG#EXCEPTION('PROCEDURE','storno#ul#pay',a#err,to_char(c.c#account_id));
  end;
end loop;

end storno#ul#pay;

/
