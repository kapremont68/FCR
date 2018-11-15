--------------------------------------------------------
--  DDL for View V#CHOP1
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#CHOP1" ("C#REAL_DATE", "C#ACCOUNT_ID", "C#WORK_ID", "C#DOER_ID", "C#MN", "C#A_MN", "C#B_MN", "C#C_VOL", "C#C_SUM", "C#MC_SUM", "C#M_SUM", "C#MP_SUM", "C#P_SUM", "C#FC_SUM", "C#FP_SUM") AS 
  select c#real_date, C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,C#MN,C#A_MN,C#B_MN
      ,sum(C#C_VOL) "C#C_VOL"
      ,sum(C#C_SUM) "C#C_SUM"
      ,sum(C#MC_SUM) "C#MC_SUM"
      ,sum(C#M_SUM) "C#M_SUM"
      ,sum(C#MP_SUM) "C#MP_SUM"
      ,sum(C#P_SUM) "C#P_SUM"
      ,sum(C#FC_SUM) "C#FC_SUM"
      ,sum(C#FP_SUM) "C#FP_SUM"
  from (

        select C#REAL_DATE, C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,P#MN_UTILS.GET#MN(C#DATE) as C#MN, C#A_MN,C#B_MN
              ,null as C#C_VOL
              ,null as C#C_SUM
              ,case when C#TYPE_TAG = 'MC' then C#SUM end as C#MC_SUM
              ,case when C#TYPE_TAG = 'M' then C#SUM end as C#M_SUM
              ,case when C#TYPE_TAG = 'MP' then C#SUM end as C#MP_SUM
              ,case when C#TYPE_TAG = 'P' then C#SUM end as C#P_SUM
              ,case when C#TYPE_TAG = 'FC' then C#SUM end as C#FC_SUM
              ,case when C#TYPE_TAG = 'FP' then C#SUM end as C#FP_SUM
          from V#OP
         where C#VALID_TAG = 'Y'
       )
 group by C#REAL_DATE, C#ACCOUNT_ID,C#WORK_ID,C#DOER_ID,C#MN,C#A_MN,C#B_MN

;
