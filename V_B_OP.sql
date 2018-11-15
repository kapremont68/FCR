--------------------------------------------------------
--  DDL for View V#B_OP
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#B_OP" ("C#ID", "C#OPS_ID", "C#HOUSE_ID", "C#SERVICE_ID", "C#B_ACCOUNT_ID", "C#DATE", "C#REAL_DATE", "C#TYPE_TAG", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#SUM") AS 
  select T.C#ID
      ,C#OPS_ID
      ,C#HOUSE_ID
      ,C#SERVICE_ID
      ,C#B_ACCOUNT_ID
      ,C#DATE
      ,C#REAL_DATE
      ,C#TYPE_TAG
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#SUM
  from T#B_OP T, T#B_OP_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#B_OP_VD where C#ID = T_VD.C#ID)


;
