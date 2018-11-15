--------------------------------------------------------
--  DDL for View V_ACCOUNTS_WITH_BARTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_ACCOUNTS_WITH_BARTER" ("ACCOUNTS_ID") AS 
  select distinct
    C#ACC_ID ACCOUNTS_ID
from
    T#PAY_SOURCE PS
    join T#ACCOUNT A on (PS.C#ACC_ID = A.C#ID)
    join T#ROOMS R on (R.C#ID = A.C#ROOMS_ID)
where
     C#COD_RKC = 88
;
