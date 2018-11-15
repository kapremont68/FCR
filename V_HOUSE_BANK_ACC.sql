--------------------------------------------------------
--  DDL for View V#HOUSE_BANK_ACC
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#HOUSE_BANK_ACC" ("HOUSE_ID", "BANK_ACC", "BIC", "KPP", "OGRN", "ACC_TYPE", "ACC_OWNER", "PROT_N", "PROT_DATE") AS 
  select
    B.C#HOUSE_ID HOUSE_ID,
    A.C#NUM BANK_ACC,
    B2.C#BIC_NUM BIC,
    B2.C#KPP KPP,
    B2.C#OGRN OGRN, 
    ACC_TYPE,
    A.C#NAME ACC_OWNER,
    A.C#PROT_N PROT_N,
    A.C#PROT_DATE PROT_DATE
from
    V#BANKING B
    join T#B_ACCOUNT A on (B.C#B_ACCOUNT_ID = A.C#ID)
    join T#BANK B2 on (A.C#BANK_ID = B2.C#ID)
    join V#HOUSE_ACC_TYPE T on (T.HOUSE_ID = B.C#HOUSE_ID)
;
