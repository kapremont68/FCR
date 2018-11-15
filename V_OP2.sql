--------------------------------------------------------
--  DDL for View V#OP2
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#OP2" ("C#ID", "C#OPS_ID", "C#ACCOUNT_ID", "C#WORK_ID", "C#DOER_ID", "C#DATE", "C#REAL_DATE", "C#A_MN", "C#B_MN", "C#TYPE_TAG", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#SUM", "C#ROW_TIME") AS 
  select T.C#ID
      ,C#OPS_ID
      ,C#ACCOUNT_ID
      ,C#WORK_ID
      ,C#DOER_ID
      ,C#DATE
      ,C#REAL_DATE
      ,C#A_MN
      ,C#B_MN
      ,C#TYPE_TAG
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#SUM
      ,T.C#ROW_TIME
  from T#OP T, T#OP_VD T_VD
 where T_VD.C#ID = T.C#ID
;
