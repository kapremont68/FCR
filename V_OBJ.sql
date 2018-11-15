--------------------------------------------------------
--  DDL for View V#OBJ
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#OBJ" ("C#ACCOUNT_ID", "C#WORK_ID", "C#DOER_ID") AS 
  select
    o."C#ACCOUNT_ID",o."C#WORK_ID",o."C#DOER_ID"
from
    t#obj o
    join T#DOER d on (o.C#DOER_ID = d.C#ID and C#CHARGE_TAG = 'Y')
;
