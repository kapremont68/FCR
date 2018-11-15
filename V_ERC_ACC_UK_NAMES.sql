--------------------------------------------------------
--  DDL for View V#ERC_ACC_UK_NAMES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ERC_ACC_UK_NAMES" ("ACCAUNT_NUM", "UK_NAME") AS 
  select 
    LSO ACCAUNT_NUM,
    MAX(HOST) UK_NAME
from
    t#erc_nach
group by
    LSO
;
