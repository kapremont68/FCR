CREATE OR REPLACE PACKAGE P#UTILS
  IS

  -- адрес
  FUNCTION GET#ADDR_NUM(A#NUM VARCHAR2)
    RETURN NUMBER DETERMINISTIC;
  FUNCTION GET#ADDR_OBJ_PATH(A#AO_ID    NUMBER,
                             A#FORM_TAG NUMBER := NULL)
    RETURN VARCHAR2;

  FUNCTION GET#HOUSE_ADDR(A#H_ID     NUMBER,
                          A#FORM_TAG NUMBER := NULL)
    RETURN VARCHAR2;

  FUNCTION GET#HOUSE_ADDR_SIMPLE(A#H_ID     NUMBER)
    RETURN VARCHAR2;


  FUNCTION GET#ROOMS_ADDR(A#R_ID     NUMBER,
                          A#FORM_TAG NUMBER := NULL)
    RETURN VARCHAR2;

  -- имя персоны
  FUNCTION GET#PERSON_NAME(A#P_ID NUMBER)
    RETURN VARCHAR2;
  -- тип персоны
  FUNCTION GET#TYPE_PERSON(A#P_ID NUMBER)
    RETURN VARCHAR2;

  -- инф. о помещении
  FUNCTION GET_OBJ#ROOMS(A#R_ID NUMBER,
                         A#DATE DATE)
    RETURN TOBJ#I_ROOMS;
  FUNCTION GET_OBJ#ROOMS(A#R_ID NUMBER,
                         A#MN   NUMBER)
    RETURN TOBJ#I_ROOMS;
  -- инф. о лицевом
  FUNCTION GET_OBJ#ACCOUNT(A#A_ID NUMBER,
                           A#DATE DATE)
    RETURN TOBJ#I_ACCOUNT;
  FUNCTION GET_OBJ#ACCOUNT(A#A_ID NUMBER,
                           A#MN   NUMBER)
    RETURN TOBJ#I_ACCOUNT;
  -- инф. о почтампте для индекса
  FUNCTION GET_OBJ#POSTAMT(A#CODE VARCHAR2)
    RETURN TOBJ#I_POSTAMT;
  -- инф. о почтампте для дома
  FUNCTION GET_OBJ#HOUSE_POSTAMT(A#H_ID NUMBER)
    RETURN TOBJ#I_POSTAMT;

  -- открытый период
  FUNCTION GET#OPEN_MN
    RETURN NUMBER;
  FUNCTION GET#OPEN_MN(A#H_ID NUMBER,
                       A#S_ID NUMBER := NULL)
    RETURN NUMBER;
  FUNCTION GET#OPEN_B_MN
    RETURN NUMBER;
  FUNCTION GET#OPEN_B_MN(A#H_ID NUMBER,
                         A#S_ID NUMBER := NULL)
    RETURN NUMBER;

  /**
  *  Действующий тариф для счета на дату
  *  @param a_account_id integer идентификатор счета
  *  @param a_date date дата определения тарифа 
  *  @return значение тарифа 
  */
  FUNCTION GET#TARIF(a_account_id INTEGER,
                     a_date       DATE)
    RETURN NUMBER;
  /**
  *  Долг для владельца по помещению на дату
  *  @param a#person_id integer идентификатор владельца
  *  @param a#rooms_id  integer идентификатор помещения
  *  @param a#date_end  date дата определения долга 
  *  @return сумма долга с начала действия программы на дату
  */
  FUNCTION GET#DOLG(a#person_id INTEGER,
                    a#rooms_id  INTEGER,
                    a#date_end  DATE)
    RETURN NUMBER;

  /**
  *  Количество лицевых счетов с долгом выше заданного порога
  *  @param a_summa number сумма порога
  *  @return number количество лицевых счетов
  */
  FUNCTION GET#COUNT_DOLG(a_summa NUMBER)
    RETURN NUMBER;

  /**
  *  Нераспределенный остаток для юридического лица
  *  @param a#person_id integer идентификатор юр лица
  *  @return сумма нераспределенного остатка
  */
  FUNCTION GET#OSTATOK_J(a#person_id INTEGER)
    RETURN NUMBER;

END;
/


CREATE OR REPLACE package body     P#UTILS is

function GET#OSTATOK_J(a#person_id integer) return number is
ret number;
begin
 select Sum(с#ostatok) into ret
 from 
 (select mp.c#person_id, mp.с#ostatok, mp.c#date, mp.c#living_tag, mp.c#id, mp.c#npd, mp.c#cod_rkc, mp.c#comment
 from t#mass_pay mp
 where 1=1
   and mp.c#person_id = a#person_id
   and nvl(mp.с#ostatok,0) > 0
   and nvl(mp.c#remove_flg, 'N') <> 'Y'
   and nvl(mp.c#storno_flg, 'N') <> 'Y'
   and (mp.C#ACC_ID is null or mp.C#ACC_ID = 0)) t;
   return ret;
end;

function GET#COUNT_DOLG(a_summa number) return number is
ret number ;
begin
select count(*) into ret from 
(select 
    --COUNT(t.c#account_id)
    t.c#account_id AS "Счета"
   ,Sum(nvl(t.c#sum,0)- nvl(t.p#sum,0)) "Долг"
from	 
(select 
vc.tp,vc.c#account_id,nvl(acc.c#id,0) c#id,acc.c#area_val,vc.c#sum,vc.p#sum
from
(select c.c#account_id,c.tp,Sum(nvl(c.c#sum,0)) c#sum,Sum(nvl(v.c#sum,0)) p#sum from
(select tc.c#account_id,pc.tp,SUM(NVL(tc.c#sum,0)) AS c#sum from 
           (select * from fcr.t#charge) tc
inner  join  (select td.c#account_id, td.c#person_id,td.c#date, td.c#next_date
                     , case when pj.c#person_id is not null then  nvl(pj.c#tip_ul,'O') else nvl(pj.c#tip_ul,'F') end  tp
            from (select asp.c#person_id, asp.c#account_id,a.c#num, asp.c#date,
                                                    nvl(lead(asp.c#date)over(partition by asp.c#account_id order by asp.c#date),
                                                    fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                                    from v#account_spec asp
                                                         inner join t#account a
                                                         on (a.c#id =  asp.c#account_id)
                                                          where 1 = 1
                                                          and asp.c#valid_tag = 'Y' ) td
                                                     left join fcr.t#person_j pj on (td.c#person_id = pj.c#person_id)) pc
on(tc.c#account_id = pc.c#account_id and tc.c#a_mn >= fcr.p#mn_utils.GET#MN(pc.c#date) and tc.c#a_mn < fcr.p#mn_utils.GET#MN(pc.c#next_date))                                                       
where tc.c#a_mn >= fcr.p#mn_utils.GET#MN(to_date('01.06.2014','dd.mm.yyyy')) and tc.c#a_mn <= fcr.p#mn_utils.GET#MN(sysdate)                             
group by tc.c#account_id,pc.tp) c 
left join 
(select vop.c#account_id,pv.tp,SUM(NVL(c#sum,0)) AS c#sum from 
           (select * from fcr.v#op) vop
inner  join  (select td.c#account_id, td.c#person_id,td.c#date, td.c#next_date
              , case when pj.c#person_id is not null then  nvl(pj.c#tip_ul,'O') else nvl(pj.c#tip_ul,'F') end  tp
            from (select asp.c#person_id, asp.c#account_id,a.c#num, asp.c#date,
                                                    nvl(lead(asp.c#date)over(partition by asp.c#account_id order by asp.c#date),
                                                    fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                                    from v#account_spec asp
                                                         inner join t#account a
                                                         on (a.c#id =  asp.c#account_id)
                                                          where 1 = 1
                                                          and asp.c#valid_tag = 'Y' ) td
                                                     left join fcr.t#person_j pj on (td.c#person_id = pj.c#person_id)) pv
on(vop.c#account_id = pv.c#account_id and vop.c#real_date >= pv.c#date and vop.c#real_date < pv.c#next_date)
where vop.c#real_date >= to_date('01.06.2014','dd.mm.yyyy') and vop.c#real_date <= sysdate
group by vop.c#account_id,pv.tp) v 
on (c.c#account_id = v.c#account_id and c.tp = v.tp)
group by c.c#account_id,c.tp
) vc,
    (
     select a.c#id,type_Acc.c#acc_type,c#area_val from
     (
		 select c#id,c#rooms_id from fcr.v#account where (c#end_date is null or c#end_date > to_date('01.06.2014','dd.mm.yyyy')
          ) and c#valid_tag = 'Y'
		 ) a
     inner join fcr.t#rooms tr ON (a.c#rooms_id = tr.c#id) 
     inner join (select c#rooms_id, c#area_val from fcr.v#rooms_spec  rs
        where c#date = (select max(c#date) from fcr.v#rooms_spec  where c#rooms_id = rs.c#rooms_id ) 
        group by c#rooms_id, c#area_val) vr on (tr.c#id = vr.C#ROOMS_ID) 
     inner join (select c#house_id , c#acc_type  from fcr.v#banking tbo
                    inner join fcr.t#b_account ba
                       on (tbo.c#b_account_id = ba.c#id)) type_Acc
    on (type_acc.c#house_id = tr.c#house_id)
    where type_Acc.c#acc_type in (1,2) 
    group by a.c#id,type_Acc.c#acc_type,c#area_val
    ) acc 
where 1=1
and vc.c#account_id = acc.c#id(+)
) t
where c#id <> 0
group by t.c#account_id
having Sum(nvl(t.c#sum,0)- nvl(t.p#sum,0)) > a_summa);
return ret;
end;



function GET#DOLG(a#person_id integer, a#rooms_id integer, a#date_end date) return number  is
ret number;
a#date_begin date;
a#exit number;
begin
a#date_begin := to_date('01.06.2014','dd.mm.yyyy'); 
if (a#person_id <> 0 and a#rooms_id <> 0 ) then 
     for rec in (          
             select tall.c#person_id,
             tall.c#rooms_id,
             sum(nach) nach,
             sum(opl) opl,
             sum(dolg) dolg
        from (select ch.c#person_id,
                     ch.m m_date,
                     (select c#rooms_id from fcr.t#account where c#id = ch.c#account_id) c#rooms_id,
                     sum(ch.nach) nach,
                     sum(nvl(op.sum_op, 0)) opl,
                     sum(ch.nach) - sum(nvl(op.sum_op, 0)) dolg
                from (select t1.c#person_id,
                             t1.m,
                             t1.c#account_id,
                             t1.c#tar_val,
                             Sum(nach) nach
                        from (select t.c#person_id,
                                     to_char(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                                             'mm.yyyy') m,
                                     tc.c#account_id,
                                     v.c#tar_val,
                                     sum(tc.c#sum) nach
                                from fcr.t#charge tc
                                     inner join (select *
                                            from (select asp.c#person_id,
                                                         asp.c#account_id,
                                                         a.c#num,
                                                         asp.c#date,
                                                         nvl(lead(asp.c#date)
                                                             over(partition by
                                                                  asp.c#account_id
                                                                  order by
                                                                  asp.c#date),
                                                             fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                                    from v#account_spec asp
                                                   inner join t#account a
                                                      on (a.c#id =
                                                         asp.c#account_id)
                                                   where 1 = 1
                                                     and asp.c#valid_tag = 'Y'
                                                     and asp.c#account_id in
                                                         (select c#account_id
                                                            from v#account_spec
                                                           where 1 = 1
                                                             and c#valid_tag = 'Y'
                                                             and c#person_id =
                                                                 a#person_id)) t2
                                           where c#person_id = a#person_id
                                          
                                          ) t
                                  on (tc.c#account_id = t.c#account_id and
                                     tc.c#a_mn <
                                     fcr.p#mn_utils.GET#MN(t.c#next_date))
                                left join (select vw.C#ID,
                                                 vw.c#date,
                                                 tobj.c#account_id,
                                                 vw.c#tar_val
                                            from fcr.t#obj tobj
                                           inner join fcr.v#work vw
                                              on (tobj.c#work_id = vw.c#id)) v
                                  on (v.c#account_id = tc.c#account_id and
                                     tc.c#work_id = v.c#id)
                               where 1 = 1
                               and tc.c#account_id =  (select t_a.c#id from fcr.v#account t_a inner join fcr.v#account_spec vas on (vas.c#account_id = t_a.c#id) 
                                             where (--c#end_date <> t_a.c#date or 
                                             c#end_date is null) and t_a.c#rooms_id= a#rooms_id and vas.c#person_id = a#person_id group by t_a.c#id)
                               group by t.c#person_id,
                                        to_char(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                                                'mm.yyyy'),
                                        tc.c#account_id,
                                        v.c#tar_val) t1
                       group by t1.c#person_id,
                                t1.m,
                                t1.c#account_id,
                                t1.c#tar_val) ch
                left join (select c#account_id, m, sum(sum_op) sum_op
                            from (select vop.c#account_id,
                                         to_char(case
                                                   when MONTHS_BETWEEN(c#real_date,
                                                                       (select c#end_date
                                                                          from v#account va
                                                                         where va.c#id =
                                                                               vop.c#account_id)) > -1 then
                                                    case
                                                      when (select c#end_date
                                                              from v#account va
                                                             where va.c#id =
                                                                   vop.c#account_id) >
                                                           (select c#date
                                                              from v#account va
                                                             where va.c#id =
                                                                   vop.c#account_id) then
                                                       add_months((select c#end_date
                                                                    from v#account va
                                                                   where va.c#id =
                                                                         vop.c#account_id),
                                                                  -1)
                                                      else
                                                       (select c#end_date
                                                          from v#account va
                                                         where va.c#id = vop.c#account_id)
                                                    end
                                                   else
                                                    case
                                                      when MONTHS_BETWEEN(c#real_date,
                                                                          t.c#next_date) > -1 then
                                                       add_months(t.c#next_date, -1)
                                                      else
                                                       c#real_date
                                                    end
                                                 end,
                                                 'mm.yyyy') m,
                                         sum(c#sum) sum_op
                                    from fcr.v#op vop
                                   inner join (select *
                                                from (select asp.c#person_id,
                                                             asp.c#account_id,
                                                             a.c#num,
                                                             asp.c#date,
                                                             nvl(lead(asp.c#date)
                                                                 over(partition by
                                                                      asp.c#account_id
                                                                      order by
                                                                      asp.c#date),
                                                                 fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                                        from v#account_spec asp
                                                       inner join t#account a
                                                          on (a.c#id =
                                                             asp.c#account_id)
                                                       where 1 = 1
                                                         and asp.c#valid_tag = 'Y'
                                                         and asp.c#account_id in
                                                             (select c#account_id
                                                                from v#account_spec
                                                               where 1 = 1
                                                                 and c#valid_tag = 'Y'
                                                                 and c#person_id =
                                                                     a#person_id)) t2
                                               where c#person_id =
                                                     a#person_id
                                              
                                              ) t
                                      on (vop.c#account_id = t.c#account_id and  vop.c#a_mn < fcr.p#mn_utils.GET#MN(t.c#next_date))
                                   where 1 = 1
                                   and vop.c#type_tag = 'P'
                                   and vop.c#account_id = 
                                            (select t_a.c#id from fcr.v#account t_a inner join fcr.v#account_spec vas on (vas.c#account_id = t_a.c#id) 
                                             where (-- c#end_date <> t_a.c#date or 
                                             c#end_date is null) and t_a.c#rooms_id= a#rooms_id and vas.c#person_id = a#person_id group by t_a.c#id)
                                   group by vop.c#account_id,
                                            c#real_date,
                                            t.c#next_date) t
                           group by c#account_id, m) op
                  on (ch.m = op.m and ch.c#account_id = op.c#account_id)
               group by ch.c#person_id, ch.m,ch.c#account_id
 			         having  to_date('01.'||ch.m,'dd.mm.yyyy') >= a#date_begin
			         and to_date('01.'||ch.m,'dd.mm.yyyy') <= a#date_end ) tall
       group by tall.c#person_id,tall.c#rooms_id
       ) loop
          if (rec.dolg is null) then 
           ret := 0;
         else
           ret := rec.dolg;
         end if; 
       end loop;
   end if;
  return ret;     
  exception 
    when OTHERS then
--        return 111222333;     
        return null;     
end;

function GET#TARIF(a_account_id integer, a_date date ) return number
is
ret number;
begin
select (select t_vw.c#tar_val from fcr.v#work t_vw where 1=1 and t_vw.c#works_id = vd.c#works_id and c#date = (select max(c#date) from fcr.v#work where 1=1 and c#date <=a_date and c#works_id = t_vw.c#works_id)) 
into ret
from fcr.v#account va inner join fcr.t#rooms tr on (va.c#rooms_id = tr.c#id)
left join fcr.v#doing vd on (vd.c#house_id = tr.c#house_id)
where 1=1
and va.c#id = a_account_id
and (vd.c#date <= a_date and (vd.c#end_date  >= a_date or vd.c#end_date is null));
return ret;
end;


 function GET#ADDR_NUM(A#NUM varchar2) return number is
  A#RES number;
 begin
  if A#NUM is not null
  then
   declare
    A#L number := length(A#NUM);
    A#I number := 1;
   begin
    loop
     exit when substr(A#NUM,A#I,1) not in ('0','1','2','3','4','5','6','7','8','9');
     A#I := A#I + 1;
     exit when A#I > A#L;
    end loop;
    A#RES := case when A#I > 1 then to_number(substr(A#NUM,1,A#I - 1)) else -1 end;
    if A#I <= A#L
    then
     declare
      A#RES_ADDON number := 0;
     begin
      loop
       A#RES_ADDON := A#RES_ADDON + ascii(substr(A#NUM,A#I,1))*(A#L - A#I + 1)*256;
       A#I := A#I + 1;
       exit when A#I > A#L;
      end loop;
      A#RES := A#RES + 1 - 1/A#RES_ADDON;
     end;
    end if;
   end;
  end if;
  return A#RES;
 end;

 function GET#ADDR_OBJ_PATH(A#AO_ID number, A#FORM_TAG number) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   select listagg(case when A#FORM_TAG = 1 and nvl(AO.C#R_FORM_TAG,'N') = 'N' then AOT.C#ABBR_NAME||' '||AO.C#NAME else AO.C#NAME||' '||AOT.C#ABBR_NAME end,', ') within group (order by LEVEL desc)
     into A#RESULT
     from T#ADDR_OBJ AO, T#ADDR_OBJ_TYPE AOT
    where AOT.C#ID = AO.C#TYPE_ID
    start with AO.C#ID = A#AO_ID connect by prior AO.C#PARENT_ID = AO.C#ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

 function GET#HOUSE_ADDR(A#H_ID number, A#FORM_TAG number) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   /*
   select GET#ADDR_OBJ_PATH(H.C#ADDR_OBJ_ID)||', '||H.C#NUM||rtrim('-'||H.C#B_NUM||'-'||H.C#S_NUM,'-')
     into A#RESULT
     from T#HOUSE H
    where H.C#ID = A#H_ID
   */
   select (
           select listagg(case when A#FORM_TAG = 1 and nvl(AO.C#R_FORM_TAG,'N') = 'N' then AOT.C#ABBR_NAME||' '||AO.C#NAME else AO.C#NAME||' '||AOT.C#ABBR_NAME end,', ') within group (order by LEVEL desc)
             from T#ADDR_OBJ AO, T#ADDR_OBJ_TYPE AOT
            where AOT.C#ID = AO.C#TYPE_ID
            start with AO.C#ID = H.C#ADDR_OBJ_ID connect by prior AO.C#PARENT_ID = AO.C#ID
          )||', '||case when A#FORM_TAG = 1 then 'д ' end||H.C#NUM||rtrim('-'||H.C#B_NUM||'-'||H.C#S_NUM,'-')
     into A#RESULT
     from T#HOUSE H
    where H.C#ID = A#H_ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

 function GET#ROOMS_ADDR(A#R_ID number, A#FORM_TAG number) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   /*
   select GET#HOUSE_ADDR(R.C#HOUSE_ID)||', '||R.C#FLAT_NUM
     into A#RESULT
     from T#ROOMS R
    where R.C#ID = A#R_ID
   */
   select (
           select listagg(case when A#FORM_TAG = 1 and nvl(AO.C#R_FORM_TAG,'N') = 'N' then AOT.C#ABBR_NAME||' '||AO.C#NAME else AO.C#NAME||' '||AOT.C#ABBR_NAME end,', ') within group (order by LEVEL desc)
             from T#ADDR_OBJ AO, T#ADDR_OBJ_TYPE AOT
            where AOT.C#ID = AO.C#TYPE_ID
            start with AO.C#ID = H.C#ADDR_OBJ_ID connect by prior AO.C#PARENT_ID = AO.C#ID
          )||', '||case when A#FORM_TAG = 1 then 'д ' end||H.C#NUM||rtrim('-'||H.C#B_NUM||'-'||H.C#S_NUM,'-')||', '||case when A#FORM_TAG = 1 then 'кв ' end||R.C#FLAT_NUM
     into A#RESULT
     from T#ROOMS R, T#HOUSE H
    where R.C#ID = A#R_ID and H.C#ID = R.C#HOUSE_ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

 function GET#PERSON_NAME(A#P_ID number) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   select nvl2(PJ.C#PERSON_ID,''||PJ.C#NAME||'','')||nvl2(PP.C#PERSON_ID,nvl2(PJ.C#PERSON_ID,' (','')||PP.C#F_NAME||rtrim(' '||PP.C#I_NAME||' '||PP.C#O_NAME)||nvl2(PJ.C#PERSON_ID,')',''),'')
     into A#RESULT
     from T#PERSON P
         ,T#PERSON_J PJ
         ,T#PERSON_P PP
    where P.C#ID = A#P_ID
      and PJ.C#PERSON_ID(+) = P.C#ID
      and PP.C#PERSON_ID(+) = P.C#ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

 function GET#TYPE_PERSON(A#P_ID number) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   select  case when pj.c#tip_ul is null then 'F'
                   			    else pj.c#tip_ul 
           end type_person	    into A#RESULT			
     from T#PERSON P
         ,T#PERSON_J PJ
         ,T#PERSON_P PP
    where P.C#ID = A#P_ID
      and PJ.C#PERSON_ID(+) = P.C#ID
      and PP.C#PERSON_ID(+) = P.C#ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;





 function GET_OBJ#ROOMS(A#R_ID number, A#DATE date) return TOBJ#I_ROOMS is
  AOBJ#ROOMS TOBJ#I_ROOMS;
 begin
  begin
   select TOBJ#I_ROOMS
           (
            R.C#HOUSE_ID
           ,RSP.C#LIVING_TAG
           ,RSP.C#OWN_TYPE_TAG
           ,RSP.C#AREA_VAL
           )
     into AOBJ#ROOMS
     from T#ROOMS R
         ,(
           select RSP.C#ROOMS_ID
                 ,RSP.C#LIVING_TAG
                 ,RSP.C#OWN_TYPE_TAG
                 ,RSP.C#AREA_VAL
                 ,case when max(RSP.C#DATE) over () = RSP.C#DATE then 'Y' end "C#MAX_TAG"
             from V#ROOMS_SPEC RSP
            where 1 = 1
              and RSP.C#ROOMS_ID = A#R_ID
              and RSP.C#DATE < A#DATE
              and RSP.C#VALID_TAG = 'Y'
          ) RSP
    where 1 = 1
      and R.C#ID = A#R_ID
      and RSP.C#ROOMS_ID(+) = R.C#ID
      and RSP.C#MAX_TAG(+) = 'Y'
   ;
  exception
   when NO_DATA_FOUND then
    null;
   when others then
    raise;
  end;
  return AOBJ#ROOMS;
 end;

 function GET_OBJ#ROOMS(A#R_ID number, A#MN number) return TOBJ#I_ROOMS is
 begin
  return GET_OBJ#ROOMS(A#R_ID, P#MN_UTILS.GET#DATE(A#MN) + 10);
 end;

 function GET_OBJ#ACCOUNT(A#A_ID number, A#DATE date) return TOBJ#I_ACCOUNT is
  AOBJ#ACCOUNT TOBJ#I_ACCOUNT;
 begin
  begin
   select TOBJ#I_ACCOUNT
           (
            case when A.C#VALID_TAG = 'Y'
             and A.C#DATE < A#DATE and (A.C#END_DATE is null or A.C#END_DATE >= A#DATE)
             and RSP.C#ROOMS_ID is not null and ASP.C#ACCOUNT_ID is not null
             then 'Y'
             else 'N'
            end
           ,A.C#NUM
           ,A.C#SN
           ,A.C#DATE
           ,A.C#END_DATE
           ,A.C#ROOMS_ID
           ,A.C#ROOMS_PN
           ,R.C#HOUSE_ID
           ,RSP.C#LIVING_TAG
           ,RSP.C#OWN_TYPE_TAG
           ,RSP.C#AREA_VAL
           ,ASP.C#PART_COEF
           ,ASP.C#PERSON_ID
           ,AOP.C#OUT_PROC_ID
           ,AOP.C#OUT_NUM
           )
     into AOBJ#ACCOUNT
     from V#ACCOUNT A
         ,T#ROOMS R
         ,(
           select RSP.C#ROOMS_ID
                 ,RSP.C#LIVING_TAG
                 ,RSP.C#OWN_TYPE_TAG
                 ,RSP.C#AREA_VAL
                 ,case when max(RSP.C#DATE) over () = RSP.C#DATE then 'Y' end "C#MAX_TAG"
             from T#ACCOUNT A
                 ,V#ROOMS_SPEC RSP
            where 1 = 1
              and A.C#ID = A#A_ID
              and RSP.C#ROOMS_ID = A.C#ROOMS_ID
              and RSP.C#DATE < A#DATE
              and RSP.C#VALID_TAG = 'Y'
          ) RSP
         ,(
           select ASP.C#ACCOUNT_ID
                 ,ASP.C#PART_COEF
                 ,ASP.C#PERSON_ID
                 ,case when max(ASP.C#DATE) over () = ASP.C#DATE then 'Y' end "C#MAX_TAG"
             from V#ACCOUNT_SPEC ASP
            where 1 = 1
              and ASP.C#ACCOUNT_ID = A#A_ID
              and ASP.C#DATE < A#DATE
              and ASP.C#VALID_TAG = 'Y'
          ) ASP
         ,(
           select AOP.C#ACCOUNT_ID
                 ,AOP.C#OUT_PROC_ID
                 ,AOP.C#OUT_NUM
                 ,case when max(AOP.C#DATE) over () = AOP.C#DATE then 'Y' end "C#MAX_TAG"
             from T#ACCOUNT_OP AOP
            where 1 = 1
              and AOP.C#ACCOUNT_ID = A#A_ID
              and AOP.C#DATE < A#DATE
          ) AOP
    where 1 = 1
      and A.C#ID = A#A_ID
      and R.C#ID = A.C#ROOMS_ID
      and RSP.C#ROOMS_ID(+) = R.C#ID
      and RSP.C#MAX_TAG(+) = 'Y'
      and ASP.C#ACCOUNT_ID(+) = A.C#ID
      and ASP.C#MAX_TAG(+) = 'Y'
      and AOP.C#ACCOUNT_ID(+) = A.C#ID
      and AOP.C#MAX_TAG(+) = 'Y'
   ;
  exception
   when NO_DATA_FOUND then
    null;
   when others then
    raise;
  end;
  return AOBJ#ACCOUNT;
 end;

 function GET_OBJ#ACCOUNT(A#A_ID number, A#MN number) return TOBJ#I_ACCOUNT is
 begin
  return GET_OBJ#ACCOUNT(A#A_ID, P#MN_UTILS.GET#DATE(A#MN) + 10);
 end;

 function GET_OBJ#POSTAMT(A#CODE varchar2) return TOBJ#I_POSTAMT is
  AOBJ#POSTAMT TOBJ#I_POSTAMT;
 begin
  begin
   select TOBJ#I_POSTAMT
           (
            P.C#CODE
           ,PP.C#CODE
           ,P.C#NAME
           ,PP.C#NAME
           ,P.C#AREA_NAME
           )
     into AOBJ#POSTAMT
     from T#POSTAMT P, T#POSTAMT PP
    where P.C#CODE = A#CODE
      and PP.C#CODE(+) = P.C#PARENT_CODE
   ;
  exception
   when NO_DATA_FOUND then
    null;
   when others then
    raise;
  end;
  return AOBJ#POSTAMT;
 end;

 function GET_OBJ#HOUSE_POSTAMT(A#H_ID number) return TOBJ#I_POSTAMT is
  AOBJ#POSTAMT TOBJ#I_POSTAMT;
 begin
  begin
   select TOBJ#I_POSTAMT
           (
            P.C#CODE
           ,PP.C#CODE
           ,P.C#NAME
           ,PP.C#NAME
           ,P.C#AREA_NAME
           )
     into AOBJ#POSTAMT
     from T#HOUSE H, T#POSTAMT P, T#POSTAMT PP
    where H.C#ID = A#H_ID
      and P.C#CODE(+) = H.C#POST_CODE
      and PP.C#CODE(+) = P.C#PARENT_CODE
   ;
  exception
   when NO_DATA_FOUND then
    null;
   when others then
    raise;
  end;
  return AOBJ#POSTAMT;
 end;

 function GET#OPEN_MN return number is
  A#RES_MN number;
 begin
  select max(C#MN)
    into A#RES_MN
    from V#CLOSE
   where C#VALID_TAG = 'Y'
  ;
  return A#RES_MN;
 end;

 function GET#OPEN_MN(A#H_ID number, A#S_ID number) return number is
  A#RES_MN number;
 begin
  if A#S_ID is null
  then
   select max(C#MN)
     into A#RES_MN
     from V#CLOSE
    where C#HOUSE_ID = A#H_ID
      and C#VALID_TAG = 'Y'
   ;
  else
   select max(C#MN)
     into A#RES_MN
     from V#CLOSE
    where C#HOUSE_ID = A#H_ID and C#SERVICE_ID = A#S_ID
      and C#VALID_TAG = 'Y'
   ;
  end if;
  return A#RES_MN;
 end;

 function GET#OPEN_B_MN return number is
  A#RES_MN number;
 begin
  select max(C#MN)
    into A#RES_MN
    from V#B_CLOSE
   where C#VALID_TAG = 'Y'
  ;
  return A#RES_MN;
 end;

 function GET#OPEN_B_MN(A#H_ID number, A#S_ID number) return number is
  A#RES_MN number;
 begin
  if A#S_ID is null
  then
   select max(C#MN)
     into A#RES_MN
     from V#B_CLOSE
    where C#HOUSE_ID = A#H_ID
      and C#VALID_TAG = 'Y'
   ;
  else
   select max(C#MN)
     into A#RES_MN
     from V#B_CLOSE
    where C#HOUSE_ID = A#H_ID and C#SERVICE_ID = A#S_ID
      and C#VALID_TAG = 'Y'
   ;
  end if;
  return A#RES_MN;
 end;

  FUNCTION GET#HOUSE_ADDR_SIMPLE(A#H_ID     NUMBER)
    RETURN VARCHAR2 AS
  A#RESULT varchar2(4000);
 begin
  begin
  null;
   select (
           select UPPER(listagg(AO.C#NAME,',') within group (order by LEVEL desc)) 
             from T#ADDR_OBJ AO, T#ADDR_OBJ_TYPE AOT
            where AOT.C#ID = AO.C#TYPE_ID
            start with AO.C#ID = H.C#ADDR_OBJ_ID connect by prior AO.C#PARENT_ID = AO.C#ID
          )||UPPER(','||H.C#NUM||rtrim('-'||H.C#B_NUM||'-'||H.C#S_NUM,'-')) ADDR
        into A#RESULT  
     from T#HOUSE H
    where H.C#ID = A#H_ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
  END GET#HOUSE_ADDR_SIMPLE;

end;
/
