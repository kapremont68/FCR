--------------------------------------------------------
--  DDL for View V#WORK
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#WORK" ("C#ID", "C#WORKS_ID", "C#DATE", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#TAR_TYPE_TAG", "C#TAR_VAL") AS 
  select T.C#ID
      ,C#WORKS_ID
      ,C#DATE
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#TAR_TYPE_TAG
      ,C#TAR_VAL
  from T#WORK T, T#WORK_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#WORK_VD where C#ID = T_VD.C#ID)


;
