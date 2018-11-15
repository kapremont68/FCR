--------------------------------------------------------
--  DDL for Procedure DO#PAY_SOURCE_RKC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#PAY_SOURCE_RKC" 
(
  a#rkc  number,
  a#date date 
)
AS 

-- TYPE type_rkc is VARRAY(4) OF number;

cursor upload(p#date date, p#rkc number) is
select f.c#id
      ,t.c#id account_id
      ,t.c#date
      ,t.c#end_date
      ,t.C#LIVING_TAG
      ,t.C#OWN_TYPE_TAG
      ,t.c#area_val
      ,t.oa.f#house_id house_id
      ,t.oa.f#person_id person_id
      ,t.c#out_num out_account_num
      ,t.oa.f#num account_num
      ,p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path -- rooms_addr(t.oa.f#rooms_id) address
      ,t.c#house_num
      ,t.c#flat_num
      ,t.room_id
      , p#utils.get#person_name(t.oa.f#person_id) person
      , (select max('—чет юр лица')
           from fcr.t#person_j p
          where p.c#person_id = t.oa.f#person_id
        ) as URFIZ
     ,c#out_proc_id
     ,c#code     
     ,f.c#real_date, f.c#summa, f.c#account, f.c#period, f.c#cod_rkc, f.c#file_id, ok.c#name, ok.c#cod
  from 
(
select a.C#ID
      ,rs.C#LIVING_TAG, rs.C#OWN_TYPE_TAG, rs.C#AREA_VAL, a.c#num
      ,p#utils.get_obj#account(op.c#account_id, sysdate) oa
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
 where op.c#date = (select max(o.c#date)
                      from fcr.t#account_op o
                     where 1 = 1
                       and o.c#account_id = op.c#account_id
                       and o.c#date < p#date
                   )
   and a.c#id = op.c#account_id
   and a.c#date = (select max(a1.c#date)
                      from fcr.v#account a1
                     where 1 = 1
                       and a1.c#id = a.c#id
                       and a1.c#date < p#date
                       and a1.C#VALID_TAG = 'Y'
                   )
   and op.c#out_proc_id in (p#rkc)
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
                        and rs1.C#DATE < p#date
                    )
) t,
fcr.t#pay_source f,
fcr.t#ops_kind ok                
where coalesce(f.c#acc_id, f.c#acc_id_close, f.c#acc_id_tter) = t.c#id
  and to_char(t.c#code,'00') <> to_char(f.c#cod_rkc,'00')
  and f.c#kind_id = ok.c#id
  and ok.c#cod <> '88'
  and f.c#upload_flg is null
;
-- a#rkc type_rkc;
BEGIN

--   a#rkc := type_rkc(1,2,8,9);
--   for i in 1..4 loop 
--     DBMS_OUTPUT.PUT_LINE(a#rkc(i));
      for c in upload(a#date,a#rkc) loop
         update fcr.t#pay_source ff
           set ff.c#upload_flg = a#rkc
         where ff.c#id = c.c#id;
      end loop;
      commit;
--   end loop; 
END DO#PAY_SOURCE_RKC;

/
