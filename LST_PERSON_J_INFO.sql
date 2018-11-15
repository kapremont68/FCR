--------------------------------------------------------
--  DDL for Function LST#PERSON_J_INFO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#PERSON_J_INFO" (A#PERSON_ID integer) return sys_refcursor is
  Result sys_refcursor;
begin
  open Result for 
	select 
   pj.c#name
  ,pj.c#inn_num
  ,pj.c#kpp_num
  ,pj.c#mail
  ,pj.c#tip_ul
  ,pj.c#rayon 
  ,va.c#id acc_id
  ,va.c#num
  ,aop.c#out_num
  ,va.c#date date_begin
  ,va.C#END_DATE date_end
  ,va.c#rooms_id
  ,r.c#house_id
  ,rs.C#LIVING_TAG
  ,rs.C#OWN_TYPE_TAG
  ,rs.C#AREA_VAL
  ,fcr.p#utils.GET#ROOMS_ADDR(va.c#rooms_id) address
  from fcr.v#account va
 inner join fcr.t#account_op aop on (va.c#id = aop.c#account_id)
 inner join fcr.t#rooms r on (r.c#id = va.c#rooms_id)
 inner join fcr.v#rooms_spec rs on (va.c#rooms_id = rs.c#rooms_id)
 inner join fcr.v#account_spec vas on (va.c#id = vas.c#account_id)
 inner join fcr.t#person_j pj on (pj.c#person_id = vas.C#PERSON_ID)
 where pj.c#person_id = a#person_id;

  return(Result);
end LST#PERSON_J_INFO;

/
