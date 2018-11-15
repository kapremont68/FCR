--------------------------------------------------------
--  DDL for View V_HOUSES_WITH_BARTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_HOUSES_WITH_BARTER" ("HOUSE_ID") AS 
  select distinct
    C#HOUSE_ID HOUSE_ID
from
    T#PAY_SOURCE PS
    join T#ACCOUNT A on (PS.C#ACC_ID = A.C#ID)
    join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
where
     C#COD_RKC = 88
;
