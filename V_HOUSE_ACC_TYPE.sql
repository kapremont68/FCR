--------------------------------------------------------
--  DDL for View V#HOUSE_ACC_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#HOUSE_ACC_TYPE" ("HOUSE_ID", "ACC_TYPE", "ACC_TYPE_NAME") AS 
  select
    C#HOUSE_ID HOUSE_ID,
    C#ACC_TYPE ACC_TYPE,
    CASE C#ACC_TYPE WHEN 1 THEN 'Котел' WHEN 2 THEN 'Спецсчет' WHEN 50 THEN 'ТСЖ' END ACC_TYPE_NAME
  from
    T#BANKING B
    join T#BANKING_VD BVD on (B.C#ID = BVD.C#ID and BVD.C#VN = (select max(C#VN) from T#BANKING_VD where C#ID = BVD.C#ID))
    join T#B_ACCOUNT A on (BVD.C#B_ACCOUNT_ID = A.C#ID)
;
