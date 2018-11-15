--------------------------------------------------------
--  DDL for View V#ACC_ALL_ADDR
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ACC_ALL_ADDR" ("ACCOUNT_ID", "IN_ACC_NUM", "OUT_ACC_NUM", "RKC_ID", "RKC_CODE", "RKC_NAME", "ROOMS_ID", "AREA", "HOUSE_ID", "HOUSE_NUM", "ADDR", "FLAT_NUM", "PERSON_ID") AS 
  select distinct
    VA.C#ID ACCOUNT_ID
    ,VA.C#NUM IN_ACC_NUM
    ,AOP.C#OUT_NUM OUT_ACC_NUM
    ,AOP.C#OUT_PROC_ID RKC_ID
    ,PR.C#CODE RKC_CODE
    ,PR.C#NAME RKC_NAME
    ,R.C#ID ROOMS_ID
    ,VR.C#AREA_VAL AREA
    ,H.C#ID HOUSE_ID
    ,H.C#NUM HOUSE_NUM
    ,HA.ADDR
    ,R.C#FLAT_NUM FLAT_NUM
    ,SVD.C#PERSON_ID PERSON_ID
from
    T#ACCOUNT_OP AOP
    join T#OUT_PROC PR on (AOP.C#OUT_PROC_ID = PR.C#ID)
    join V#ACCOUNT VA on (AOP.C#ACCOUNT_ID = VA.C#ID)
    join T#ROOMS R on (VA.C#ROOMS_ID = R.C#ID)
    join V#ROOMS VR on (VA.C#ROOMS_ID = VR.C#ROOMS_ID)
    join T#HOUSE H on (R.C#HOUSE_ID = H.C#ID)
    join MV_HOUSES_ADRESES HA on (H.C#ID = HA.HOUSE_ID)
    join T#ACCOUNT_SPEC S on (S.C#ACCOUNT_ID = VA.C#ID)
    join t#account_spec_vd SVD on (S.C#ID = SVD.C#ID)
;
