--------------------------------------------------------
--  DDL for View V4_BANK_VD
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V4_BANK_VD" ("HOUSE_ID", "B_ACCOUNT_ID", "SIGN_DATE", "ACC_NUM", "BANK_NAME", "HOST_NAME", "ACC_TYPE", "VALID_TAG", "PROT_N", "PROT_DATE", "BANK_ID") AS 
  select
    B.C#HOUSE_ID HOUSE_ID,
    BA.C#ID B_ACCOUNT_ID,
    VD.C#SIGN_DATE SIGN_DATE,
    BA.C#NUM ACC_NUM,
    TB.C#NAME BANK_NAME,
    BA.C#NAME HOST_NAME,
    C#ACC_TYPE ACC_TYPE,
    CASE WHEN B.C#B_ACCOUNT_ID = VD.C#B_ACCOUNT_ID and B.C#VN = VD.C#VN THEN 'Y' ELSE 'N' END VALID_TAG,
    PROTS.C#NUM PROT_N,
    PROTS.C#DATE PROT_DATE,
    TB.C#ID BANK_ID
from
    V#BANKING B
    join T#BANKING_VD VD on (B.C#ID = VD.C#ID)
    join T#B_ACCOUNT BA on (VD.C#B_ACCOUNT_ID = BA.C#ID)
    join T#BANK TB on (BA.C#BANK_ID = TB.C#ID)
    left join (
        select * from T4_HOUSE_PROTS T1 where C#VER = (select max(C#VER) from T4_HOUSE_PROTS T2 where T1.C#HOUSE_ID = T2.C#HOUSE_ID)
    ) PROTS on (PROTS.C#HOUSE_ID = B.C#HOUSE_ID)
;
