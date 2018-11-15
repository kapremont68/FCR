--------------------------------------------------------
--  DDL for Function UPD#RKC_J
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."UPD#RKC_J" 
(
  A_PERSON_ID IN NUMBER 
, A_RKC_ID IN NUMBER 
, A_DATE IN DATE 
)  return number AS 
a_exist number;
a_id number;
BEGIN
  for r in (select va.c#id c_id, va.c#num from fcr.v#account va inner join fcr.v#account_spec vas on (va.c#id = vas.c#account_id) where c#person_id = a_person_id) loop
     a_id := -1;
     select count(*) into a_exist from fcr.t#account_op taop where taop.c#account_id = r.c_id and c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id);
     if (a_exist > 0 ) then
        a_id := r.c_id;
        delete from fcr.t#account_op where c#account_id = r.c_id;
     end if;
     fcr.p#fcr.ins#account_op(r.c_id,a_date,a_rkc_id,r.c#num);
    commit;  
   end loop;       
   return 0;
   exception
   when OTHERS then
       rollback;
       return a_id;
END UPD#RKC_J;

/
