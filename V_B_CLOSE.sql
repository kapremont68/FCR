--------------------------------------------------------
--  DDL for View V#B_CLOSE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#B_CLOSE" ("C#ID", "C#HOUSE_ID", "C#SERVICE_ID", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#MN") AS 
  select T.C#ID
      ,C#HOUSE_ID
      ,C#SERVICE_ID
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#MN
  from T#B_CLOSE T, T#B_CLOSE_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#B_CLOSE_VD where C#ID = T_VD.C#ID)


;
