--------------------------------------------------------
--  DDL for Function LST#DEBT_OMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#DEBT_OMS" (a#begin date, a#end date) return sys_refcursor is
  Result sys_refcursor;
begin
 open  Result for 
 select 
   p.c#name as "Юридическое лицо",
   COUNT(r.c#id) AS "Счета",
   SUM(NVL(vrs.c#area_val,0)) AS "Площадь",
   SUM(NVL(c.c#Sum,0)) AS "Начислено", 
   SUM(NVL(op.p#Sum,0)) AS "Оплачено",
   SUM(NVL(c.c#Sum,0)) - SUM(NVL(op.p#Sum,0))AS "Долг"
 FROM 
   (select * from fcr.v#account where c#end_date is null and c#valid_tag = 'Y') acc 
    inner join ( select c#account_id,pj.c#name from fcr.v#account_spec a inner join fcr.t#person_j pj on (a.c#person_id = pj.c#person_id) where pj.c#tip_ul = 'OMS') p
    on (p.c#account_id = acc.c#id) 
    INNER JOIN fcr.t#rooms r ON (acc.c#rooms_id = r.c#id) INNER JOIN fcr.v#rooms_spec vrs ON (r.c#id = vrs.c#rooms_id) 
    INNER JOIN fcr.t#house h ON (r.c#house_id = h.c#id) 
    inner join (select c#house_id , c#acc_type  from fcr.v#banking tbo
                    inner join fcr.t#b_account ba
                       on (tbo.c#b_account_id = ba.c#id)) type_Acc
 on (type_acc.c#house_id = h.c#id)
    LEFT Join (SELECT c#account_id,SUM(NVL(c#sum,0)) AS c#sum FROM fcr.t#charge 
       where c#a_mn between fcr.p#mn_utils.GET#MN(a#begin) 
       and fcr.p#mn_utils.GET#MN(a#end) GROUP BY c#account_id ) c ON (acc.c#id = c.c#account_id) 
    LEFT Join (SELECT c#account_id,sum(case when C#TYPE_TAG = 'P' then C#SUM end) AS p#sum FROM fcr.v#op 
       where C#VALID_TAG = 'Y' 
         and c#real_date >= a#begin
         and c#real_date <= a#end
    GROUP BY c#account_id) op ON (acc.c#id = op.c#account_id) 
    WHERE vrs.c#valid_tag = 'Y' and type_acc.c#acc_type in (1,2) 
   group by    p.c#name;
    return(Result);
end LST#DEBT_OMS;

/
