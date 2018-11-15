--------------------------------------------------------
--  DDL for View V#OPS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#OPS" ("C#ID", "C#VN", "C#VALID_TAG", "C#SIGN_DATE", "C#SIGN_S_ID", "C#KIND_ID", "C#NOTE_TEXT") AS 
  select T.C#ID
      ,C#VN
      ,C#VALID_TAG
      ,C#SIGN_DATE
      ,C#SIGN_S_ID
      ,C#KIND_ID
      ,C#NOTE_TEXT
  from T#OPS T, T#OPS_VD T_VD
 where T_VD.C#ID = T.C#ID
   and T_VD.C#VN = (select max(C#VN) from T#OPS_VD where C#ID = T_VD.C#ID)


;
