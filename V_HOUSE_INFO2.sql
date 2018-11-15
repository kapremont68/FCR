--------------------------------------------------------
--  DDL for View V_HOUSE_INFO2
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_HOUSE_INFO2" ("HOUSE_ID", "ADDR", "AREA_VAL", "ACC_COUNT", "ACC_TYPE", "PROT_EXIST", "PROT_WORD", "POST_WORD") AS 
  select
    VD.HOUSE_ID,
    ADDR,
    NVL(C#AREA_VAL,0) AREA_VAL,
    (select count(distinct C#ACCOUNT_ID) from V#ACC_LAST where C#HOUSE_ID = VD.HOUSE_ID) ACC_COUNT,
    CASE ACC_TYPE WHEN 1 THEN 'K' ELSE 'S' END ACC_TYPE,
    CASE WHEN PROT_N is not null or PROT_DATE is not null THEN 'Y' ELSE 'N' END PROT_EXIST,
    CASE WHEN LOWER(C#VOTE_TEXT) like '%протокол%' THEN 'Y' ELSE 'N' END PROT_WORD,
    CASE WHEN LOWER(C#VOTE_TEXT) like '%постан%' THEN 'Y' ELSE 'N' END POST_WORD
from
    V4_BANK_VD VD
    join T#HOUSE_INFO HI on (VD.HOUSE_ID = HI.C#HOUSE_ID)
    join MV_HOUSES_ADRESES A on (VD.HOUSE_ID = A.HOUSE_ID)
where
    ACC_TYPE in (1,2)
    and VALID_TAG = 'Y'
    and HI.C#END_DATE is null
;
