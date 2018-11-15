--------------------------------------------------------
--  DDL for Procedure DO#2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#2" AS
cursor old_ostatok is --Собираем строки с недораспределенными остатками и заводим их новой строкой
--для попытки распределения, по старым строкам ставим признак что остаток перенесен в новую строку

select mp.c#person_id, mp.с#ostatok, mp.c#date, mp.c#living_tag, mp.c#id, mp.c#npd, mp.c#cod_rkc, mp.c#comment
  from t#mass_pay mp
 where nvl(mp.с#ostatok,0) > 0
   and nvl(mp.c#remove_flg, 'N') <> 'Y'
   and nvl(mp.c#storno_flg, 'N') <> 'Y'
   and (mp.C#ACC_ID is null or mp.C#ACC_ID = 0)
;
a#err varchar2(4000);
begin
for mp in old_ostatok loop
begin
insert into fcr.t#mass_pay(c#person_id, c#sum, c#date, c#living_tag, c#parent_id, c#npd, c#cod_rkc, c#comment)
values (mp.c#person_id, mp.с#ostatok, mp.c#date, mp.c#living_tag, mp.c#id, mp.c#npd, mp.c#cod_rkc, mp.c#comment);
update fcr.t#mass_pay m
  set m.c#remove_flg = 'Y'
 where m.c#id = mp.c#id;
commit;
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#2',sysdate,a#err,to_char(mp.c#person_id));
end;
end loop;
END DO#2;

/
