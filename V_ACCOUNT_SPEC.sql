--------------------------------------------------------
--  DDL for View V#ACCOUNT_SPEC
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ACCOUNT_SPEC" ("C#ID", "C#ACCOUNT_ID", "C#DATE", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#PERSON_ID", "C#PART_COEF") AS 
  select T.C#ID
      ,C#ACCOUNT_ID
      ,C#DATE
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#PERSON_ID
      ,C#PART_COEF
  from T#ACCOUNT_SPEC T, T#ACCOUNT_SPEC_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#ACCOUNT_SPEC_VD where C#ID = T_VD.C#ID)


;
