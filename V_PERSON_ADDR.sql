--------------------------------------------------------
--  DDL for View V#PERSON_ADDR
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#PERSON_ADDR" ("PERSON_ID", "ADDR") AS 
  select 
    c#person_id person_id,
    trim(nvl2(c#post_code,c#post_code || ', ','') || c#1_text || ' ' || c#2_text) addr
from 
    t#person_addr
;
