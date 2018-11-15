--------------------------------------------------------
--  DDL for View V#ACCOUNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ACCOUNT" ("C#ID", "C#ROOMS_ID", "C#ROOMS_PN", "C#DATE", "C#NUM", "C#SN", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#END_DATE") AS 
  select T.C#ID
      ,C#ROOMS_ID
      ,C#ROOMS_PN
      ,C#DATE
      ,C#NUM
      ,C#SN
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#END_DATE
  from T#ACCOUNT T, T#ACCOUNT_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = T_VD.C#ID)


;
