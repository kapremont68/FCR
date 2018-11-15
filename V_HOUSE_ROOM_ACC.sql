--------------------------------------------------------
--  DDL for View V_HOUSE_ROOM_ACC
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_HOUSE_ROOM_ACC" ("HOUSE_ID", "ROOMS_ID", "ACCOUNT_ID") AS 
  select
    C#HOUSE_ID HOUSE_ID,
    C#ROOMS_ID ROOMS_ID,
    A.C#ID ACCOUNT_ID
from
    V#ACCOUNT A
    join T#ROOMS R ON (A.C#ROOMS_ID = R.C#ID)
;
