--------------------------------------------------------
--  DDL for View V#CHOP
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#CHOP" ("C#ACCOUNT_ID", "C#WORK_ID", "C#DOER_ID", "C#MN", "C#A_MN", "C#B_MN", "C#C_VOL", "C#C_SUM", "C#MC_SUM", "C#M_SUM", "C#MP_SUM", "C#P_SUM", "C#FC_SUM", "C#FP_SUM") AS 
  select C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,C#MN,C#A_MN,C#B_MN
      ,sum(C#C_VOL) "C#C_VOL"
      ,sum(C#C_SUM) "C#C_SUM"
      ,sum(C#MC_SUM) "C#MC_SUM"
      ,sum(C#M_SUM) "C#M_SUM"
      ,sum(C#MP_SUM) "C#MP_SUM"
      ,sum(C#P_SUM) "C#P_SUM"
      ,sum(C#FC_SUM) "C#FC_SUM"
      ,sum(C#FP_SUM) "C#FP_SUM"
  from (
        select C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,C#MN,C#A_MN,C#B_MN
              ,C#VOL "C#C_VOL"
              ,C#SUM "C#C_SUM"
              ,null "C#MC_SUM"
              ,null "C#M_SUM"
              ,null "C#MP_SUM"
              ,null "C#P_SUM"
              ,null "C#FC_SUM"
              ,null "C#FP_SUM"
          from T#CHARGE
        union all
        select C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,P#MN_UTILS.GET#MN(C#DATE),C#A_MN,C#B_MN
              ,null
              ,null
              ,case when C#TYPE_TAG = 'MC' then C#SUM end
              ,case when C#TYPE_TAG = 'M' then C#SUM end
              ,case when C#TYPE_TAG = 'MP' then C#SUM end
              ,case when C#TYPE_TAG = 'P' then C#SUM end
              ,case when C#TYPE_TAG = 'FC' then C#SUM end
              ,case when C#TYPE_TAG = 'FP' then C#SUM end
          from V#OP
         where C#VALID_TAG = 'Y'
       )
 group by C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,C#MN,C#A_MN,C#B_MN
;
