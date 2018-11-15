--------------------------------------------------------
--  DDL for View V#B_OPS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#B_OPS" ("C#ID", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#KIND_ID", "C#NOTE_TEXT") AS 
  select T.C#ID
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#KIND_ID
      ,C#NOTE_TEXT
  from T#B_OPS T, T#B_OPS_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#B_OPS_VD where C#ID = T_VD.C#ID)


;
