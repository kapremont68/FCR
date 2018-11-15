--------------------------------------------------------
--  DDL for View V#ROOMS_SPEC
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ROOMS_SPEC" ("C#ID", "C#ROOMS_ID", "C#DATE", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#LIVING_TAG", "C#OWN_TYPE_TAG", "C#AREA_VAL") AS 
  select T.C#ID
      ,C#ROOMS_ID
      ,C#DATE
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#LIVING_TAG
      ,C#OWN_TYPE_TAG
      ,C#AREA_VAL
  from T#ROOMS_SPEC T, T#ROOMS_SPEC_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#ROOMS_SPEC_VD where C#ID = T_VD.C#ID)


;
