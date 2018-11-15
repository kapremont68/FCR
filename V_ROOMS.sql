--------------------------------------------------------
--  DDL for View V#ROOMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ROOMS" ("C#ROOMS_ID", "C#VALID_TAG", "C#LIVING_TAG", "C#OWN_TYPE_TAG", "C#AREA_VAL", "C#HOUSE_ID", "C#ROOMS_DATE") AS 
  SELECT
    R.C#ROOMS_ID C#ROOMS_ID,
    VD1.C#VALID_TAG C#VALID_TAG,
    VD1.C#LIVING_TAG C#LIVING_TAG,
    VD1.C#OWN_TYPE_TAG C#OWN_TYPE_TAG,
    VD1.C#AREA_VAL C#AREA_VAL,
    T.C#HOUSE_ID,
    R.C#DATE C#ROOMS_DATE
FROM
    T#ROOMS_SPEC R
    join T#ROOMS_SPEC_VD VD1 on (R.C#ID = VD1.C#ID)
    join T#ROOMS T on (T.C#ID = R.C#ROOMS_ID)
where
    R.C#DATE = (select max(c#DATE) from T#ROOMS_SPEC R2 where R.c#rooms_id = R2.c#rooms_id)
    and VD1.C#VN = (select max(C#VN) from T#ROOMS_SPEC_VD VD2 where VD1.c#id = vd2.c#id)
;
