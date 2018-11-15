--------------------------------------------------------
--  DDL for View V#CLOSE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#CLOSE" ("C#ID", "C#HOUSE_ID", "C#SERVICE_ID", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#MN") AS 
  select T.C#ID
      ,C#HOUSE_ID
      ,C#SERVICE_ID
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#MN
  from T#CLOSE T, T#CLOSE_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#CLOSE_VD where C#ID = T_VD.C#ID)


;
