--------------------------------------------------------
--  DDL for View V#DOING
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#DOING" ("C#ID", "C#HOUSE_ID", "C#WORKS_ID", "C#DATE", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#DOER_ID", "C#END_DATE") AS 
  select T.C#ID
      ,C#HOUSE_ID
      ,C#WORKS_ID
      ,C#DATE
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#DOER_ID
      ,C#END_DATE
  from T#DOING T, T#DOING_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#DOING_VD where C#ID = T_VD.C#ID)


;
