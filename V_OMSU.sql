--------------------------------------------------------
--  DDL for View V#OMSU
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#OMSU" ("C#ID", "C#REGION", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#NAME_MO") AS 
  select T.C#ID
      ,T.C#REGION
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#NAME_MO
  from T#OMSU T, T#OMSU_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#OMSU_VD where C#ID = T_VD.C#ID)
;
