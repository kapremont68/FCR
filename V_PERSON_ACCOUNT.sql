--------------------------------------------------------
--  DDL for View V#PERSON_ACCOUNT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#PERSON_ACCOUNT" ("PERSON_ID", "ACCOUNT_ID", "END_DATE") AS 
  select distinct
    SVD.C#PERSON_ID PERSON_ID,
    S.C#ACCOUNT_ID ACCOUNT_ID,
    VD.C#END_DATE END_DATE
from
    T#ACCOUNT_SPEC_VD SVD
    join T#ACCOUNT_SPEC S on (S.C#ID = SVD.C#ID)
    join T#ACCOUNT_VD VD on (S.C#ACCOUNT_ID = VD.C#ID)
;
