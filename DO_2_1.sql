--------------------------------------------------------
--  DDL for Procedure DO#2_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#2_1" AS
cursor ins_storno is
select t.c#person_id,  --to_date('01.09.2016','dd.mm.yyyy') 
fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN)
as c#date, -1*sum(t.c#sum) c#sum
  from T#MASS_PAY t
 where 1 = 1
   and  t.c#acc_id is not null
   and nvl(t.c#storno_flg,'N') = 'Y'
   and nvl(t.c#remove_flg, 'N') = 'N'
group by t.c#person_id;
a#err varchar2(4000);
BEGIN

for mp in ins_storno loop
begin	
insert into fcr.t#mass_pay(c#person_id, c#sum, c#date, c#cod_rkc, c#comment, c#acc_id)
values (mp.c#person_id, mp.c#sum, mp.c#date, 91, 'Сторно по ЛС', 0);

update fcr.t#mass_pay m
  set m.c#remove_flg = 'Y'
 where m.c#acc_id is not null
  and nvl(m.c#storno_flg, 'N') = 'Y'
  and nvl(m.c#remove_flg, 'N') = 'N'
  and m.c#person_id = mp.c#person_id
  ;
commit;  
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#2_1',sysdate,a#err,to_char(mp.c#person_id));

end;
end loop;  

END DO#2_1;

/
