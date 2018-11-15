--------------------------------------------------------
--  DDL for View V#ACC_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ACC_ALL" ("C#ACCOUNT_ID", "C#ROOMS_ID", "C#ROOMS_PN", "C#ACC_DATE", "C#ACC_NUM", "C#SN", "C#VD_VN", "C#VD_VALID_TAG", "C#VD_SIGN_DATE", "C#VD_SIGN_S_ID", "C#END_DATE", "C#SPEC_DATE", "C#SPEC_VN", "C#SPEC_VALID_TAG", "C#SPEC_SIGN_DATE", "C#SPEC_SIGN_S_ID", "C#PERSON_ID", "C#PART_COEF", "C#OP_DATE", "C#OUT_PROC_ID", "C#OUT_NUM") AS 
  with 
  vd as(SELECT * FROM t#account_vd),
  op as (SELECT * FROM t#account_op op1),
  svd as(SELECT * FROM t#account_spec_vd svd1),
  spec as (SELECT * FROM T#ACCOUNT_SPEC spec1 JOIN svd ON(spec1.C#ID = svd.C#ID))  

SELECT 
  acc.C#ID C#ACCOUNT_ID
  ,acc.C#ROOMS_ID C#ROOMS_ID
  ,acc.C#ROOMS_PN C#ROOMS_PN
  ,acc.C#DATE C#ACC_DATE
  ,acc.C#NUM C#ACC_NUM
  ,acc.C#SN C#SN
  ,vd.C#VN C#VD_VN
  ,vd.C#VALID_TAG C#VD_VALID_TAG
  ,vd.C#SIGN_DATE C#VD_SIGN_DATE
  ,vd.C#SIGN_S_ID C#VD_SIGN_S_ID
  ,vd.C#END_DATE C#END_DATE
  ,spec.C#DATE C#SPEC_DATE
  ,spec.C#VN C#SPEC_VN
  ,spec.C#VALID_TAG C#SPEC_VALID_TAG
  ,spec.C#SIGN_DATE C#SPEC_SIGN_DATE
  ,spec.C#SIGN_S_ID C#SPEC_SIGN_S_ID
  ,spec.C#PERSON_ID C#PERSON_ID
  ,spec.C#PART_COEF C#PART_COEF
  ,op.C#DATE C#OP_DATE
  ,op.C#OUT_PROC_ID C#OUT_PROC_ID
  ,op.C#OUT_NUM C#OUT_NUM
FROM 
  T#ACCOUNT acc
  JOIN vd ON (acc.c#id = vd.c#id)
  JOIN spec ON (acc.c#id = spec.c#account_id)
  LEFT JOIN op ON (acc.c#id = op.c#account_id) WITH READ ONLY;

   COMMENT ON TABLE "FCR"."V#ACC_ALL"  IS 'GERA 06.2017
объединенная информация (избыточная) по счетам из всех 5 таблиц'
;
