--------------------------------------------------------
--  DDL for View V#ROOMS_LAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ROOMS_LAST" ("C#ID", "C#HOUSE_ID", "C#FLAT_NUM", "C#SPEC_ID", "C#SPEC_ROOMS_ID", "C#DATE", "C#SVD_ID", "C#SIGN_DATE", "C#SIGN_S_ID", "C#LIVING_TAG", "C#OWN_TYPE_TAG", "C#AREA_VAL") AS 
  WITH 
  svd AS (
    SELECT 
      C#ID C#SVD_ID, 
      C#SIGN_DATE, 
      C#SIGN_S_ID, 
      C#LIVING_TAG, 
      C#OWN_TYPE_TAG, 
      C#AREA_VAL
    FROM t#rooms_spec_vd svd1
    WHERE c#valid_tag = 'Y' and c#vn = (SELECT MAX(c#vn) FROM t#rooms_spec_vd svd2 WHERE svd2.c#id = svd1.c#id)
  ),
  spec AS ( 
    SELECT 
      C#ID C#SPEC_ID, 
      C#ROOMS_ID C#SPEC_ROOMS_ID, 
      C#DATE,
      svd.*
    FROM T#ROOMS_SPEC spec1 JOIN svd ON(spec1.C#ID = svd.C#SVD_ID)
    WHERE spec1.c#date = (select max(c#date) from T#ROOMS_SPEC spec2 where spec1.C#ROOMS_ID = spec2.C#ROOMS_ID)
  ),
  rooms AS ( 
    SELECT * FROM t#rooms JOIN spec on (t#rooms.c#id = spec.C#SPEC_ROOMS_ID) 
--    and spec.c#date = (select max(c#date) from T#ROOMS_SPEC spec2 where spec2.C#ROOMS_ID = spec.C#ROOMS_ID)
  )
SELECT 
  "C#ID","C#HOUSE_ID","C#FLAT_NUM","C#SPEC_ID","C#SPEC_ROOMS_ID","C#DATE","C#SVD_ID","C#SIGN_DATE","C#SIGN_S_ID","C#LIVING_TAG","C#OWN_TYPE_TAG","C#AREA_VAL"
FROM rooms;

   COMMENT ON TABLE "FCR"."V#ROOMS_LAST"  IS 'GERA 06.2017
соединение всех 4 таблиц по румс
только активные записи
из вд-шки берутся последние данные
'
;
