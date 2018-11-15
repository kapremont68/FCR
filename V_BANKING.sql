--------------------------------------------------------
--  DDL for View V#BANKING
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#BANKING" ("C#ID", "C#HOUSE_ID", "C#SERVICE_ID", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#B_ACCOUNT_ID") AS 
  select T.C#ID
      ,C#HOUSE_ID
      ,C#SERVICE_ID
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#B_ACCOUNT_ID
  from T#BANKING T, T#BANKING_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#BANKING_VD where C#ID = T_VD.C#ID)


;
