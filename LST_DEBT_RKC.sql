--------------------------------------------------------
--  DDL for Function LST#DEBT_RKC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#DEBT_RKC" 
(
 a#date date,
 a#rkc number  --1 ÌÓÏ ÅÐÖ ,2 ÒÒÝÐ, 8 ÒÎÑÊ, 9 Öíèíñêèé
) return sys_refcursor is
  Result sys_refcursor;
begin
  open Result for
  Select * from 
 ( select
       t.c#id account_id
      ,t.c#date
      ,t.c#end_date
      ,t.C#LIVING_TAG
      ,t.C#OWN_TYPE_TAG
      ,t.c#area_val
      ,t.oa.f#house_id house_id
      ,t.oa.f#person_id person_id
      ,t.c#out_num out_account_num
      ,t.oa.f#num account_num
      ,p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path 
      ,t.c#house_num
      ,t.c#flat_num
      ,t.room_id
      , p#utils.get#person_name(t.oa.f#person_id) person
      , (select max('Ñ÷åò þð ëèöà')
           from fcr.t#person_j p
          where p.c#person_id = t.oa.f#person_id
        ) as URFIZ,    
--        case when 
--                 fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) > 0
--             and fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) > se.dolg 
--              then  fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) 
--            when  se.dolg > 0 
--              and fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) <= se.dolg 
--              then  se.dolg 
--            else 0    
--        end 
        fcr.p#web.GET#DOLG(t.c#id) dolg,
        fcr.p#tools.get#count_88(t.c#id) count_88
  from 
(
select a.C#ID
      ,rs.C#LIVING_TAG, rs.C#OWN_TYPE_TAG, rs.C#AREA_VAL, a.c#num
      ,p#utils.get_obj#account(op.c#account_id, a#date) oa
      ,h.c#addr_obj_id
      ,a.c#date
      ,a.C#END_DATE
      ,h.c#num || rtrim('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num
      ,r.c#id as room_id
      ,r.c#flat_num
      ,op.c#out_num
      ,op.c#out_proc_id
      ,oo.c#code
  from fcr.t#account_op op,
       fcr.v#account a,
       fcr.v#rooms_spec rs,
       fcr.t#rooms r, 
       fcr.t#house h,
       fcr.t#out_proc oo
 where
   1=1
   and (a.c#end_date is null or a.c#end_date > a#date)
   and op.c#date = (select max(o.c#date)
                      from fcr.t#account_op o
                     where 1 = 1
                       and o.c#account_id = op.c#account_id
                       and o.c#date < a#date
                   )
   and a.c#id = op.c#account_id
   and a.c#date = (select max(a1.c#date)
                      from fcr.v#account a1
                     where 1 = 1
                       and a1.c#id = a.c#id
                       and a1.c#date < a#date
                       and a1.C#VALID_TAG = 'Y'
                   )
   and op.c#out_proc_id in (a#rkc)
   and oo.c#id = op.c#out_proc_id
   and rs.C#ROOMS_ID = a.c#rooms_id
   and rs.C#VALID_TAG = 'Y'
   and a.C#VALID_TAG = 'Y'
   and r.c#id = rs.C#ROOMS_ID
   and r.c#house_id = h.c#id   
   and rs.C#DATE =  (
                     select max(rs1.C#DATE)
                       from fcr.v#rooms_spec rs1
                      where rs1.C#ROOMS_ID = rs.C#ROOMS_ID
                        and rs1.C#DATE < a#date
                    )
) t
--,
-- (
--    select T.C#ACCOUNT_ID
--          ,sum(TT.C#C_SUM) "C#0_C_SUM"
--          ,sum(TT.C#MC_SUM) "C#0_MC_SUM"
--          ,sum(TT.C#M_SUM) "C#0_M_SUM"
--          ,sum(TT.C#MP_SUM) "C#0_MP_SUM"
--          ,sum(TT.C#P_SUM) "C#0_P_SUM"
--          ,SUM(TT.C#FC_SUM) "C#FC_SUM"
--          ,SUM(TT.C#FP_SUM) "C#FP_SUM"
--          ,nvl(sum(TT.C#C_SUM),0)+nvl(sum(TT.C#MC_SUM),0)+nvl(sum(TT.C#M_SUM),0)-nvl(sum(TT.C#MP_SUM),0)-
--           nvl(sum(TT.C#P_SUM),0) as dolg
--      from FCR.T#STORE T, FCR.T#STORAGE TT, FCR.T#ACCOUNT A, FCR.T#ROOMS R
--     where 1 = 1
--       and T.C#MN = FCR.P#MN_UTILS.GET#MN(trunc(add_months(a#date,1),'MM'))
--       and TT.C#ACCOUNT_ID = T.C#ACCOUNT_ID
--       and TT.C#WORK_ID = T.C#WORK_ID
--       and TT.C#DOER_ID = T.C#DOER_ID
--       and TT.C#MN = (select max(C#MN) from FCR.T#STORAGE where C#ACCOUNT_ID = T.C#ACCOUNT_ID and C#WORK_ID = T.C#WORK_ID and C#DOER_ID = T.C#DOER_ID and C#MN <= T.C#MN)
--       and A.C#ID = T.C#ACCOUNT_ID
--       and R.C#ID = A.C#ROOMS_ID
--     group by T.C#ACCOUNT_ID
--     having nvl(sum(TT.C#C_SUM),0)+nvl(sum(TT.C#MC_SUM),0)+nvl(sum(TT.C#M_SUM),0)-nvl(sum(TT.C#MP_SUM),0)-
--            nvl(sum(TT.C#P_SUM),0) < 0
--            
-- ) SE -- ñàëüäî (èñõîäÿùåå) 
-- where t.c#id = se.c#account_id ) tbl 
-- where tbl.dolg > 0;
) tbl
 where tbl.dolg < 0;

  return(Result);
end LST#DEBT_RKC;

/
