--------------------------------------------------------
--  DDL for View V#ACC_LAST_END
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ACC_LAST_END" ("C#ACCOUNT_ID", "C#HOUSE_ID", "C#ROOMS_ID", "C#ROOMS_PN", "C#ACC_DATE", "C#ACC_NUM", "C#SN", "C#VD_VN", "C#VD_SIGN_DATE", "C#VD_SIGN_S_ID", "C#END_DATE", "C#SPEC_DATE", "C#SPEC_VN", "C#SPEC_SIGN_DATE", "C#SPEC_SIGN_S_ID", "C#PERSON_ID", "C#PART_COEF", "C#OP_DATE", "C#OUT_PROC_ID", "C#OUT_NUM", "C#RKC_CODE", "C#RKC_NAME") AS 
  with
  vd as(
    SELECT *
    FROM t#account_vd vd1
    WHERE /*C#VALID_TAG = 'Y' and C#END_DATE is null and */ c#vn = (SELECT MAX(c#vn) FROM t#account_vd vd2 WHERE vd2.c#id = vd1.c#id)),
  op as (
    SELECT *
    FROM t#account_op op1
    WHERE c#date = (SELECT MAX(c#date) FROM t#account_op op2 WHERE op2.c#account_id = op1.c#account_id)),
  svd as (
    SELECT *
    FROM
        T#ACCOUNT_SPEC spec1
        JOIN t#account_spec_vd svd ON(spec1.C#ID = svd.C#ID)
  ),
  spec as(
    SELECT *
    FROM svd svd1
    WHERE
      c#vn = (SELECT MAX(c#vn) FROM svd svd2 WHERE svd2.C#ACCOUNT_ID = svd1.C#ACCOUNT_ID)
      and  C#SIGN_DATE = (SELECT MAX(C#SIGN_DATE) FROM svd svd3 WHERE svd3.C#ACCOUNT_ID = svd1.C#ACCOUNT_ID)
  )

SELECT
  acc.C#ID C#ACCOUNT_ID
  ,T#ROOMS.C#HOUSE_ID C#HOUSE_ID
  ,acc.C#ROOMS_ID C#ROOMS_ID
  ,acc.C#ROOMS_PN C#ROOMS_PN
  ,acc.C#DATE C#ACC_DATE
  ,acc.C#NUM C#ACC_NUM
  ,acc.C#SN C#SN
  ,vd.C#VN C#VD_VN
  ,vd.C#SIGN_DATE C#VD_SIGN_DATE
  ,vd.C#SIGN_S_ID C#VD_SIGN_S_ID
  ,vd.C#END_DATE C#END_DATE
  ,spec.C#DATE C#SPEC_DATE
  ,spec.C#VN C#SPEC_VN
  ,spec.C#SIGN_DATE C#SPEC_SIGN_DATE
  ,spec.C#SIGN_S_ID C#SPEC_SIGN_S_ID
  ,spec.C#PERSON_ID C#PERSON_ID
  ,spec.C#PART_COEF C#PART_COEF
  ,op.C#DATE C#OP_DATE
  ,op.C#OUT_PROC_ID C#OUT_PROC_ID
  ,op.C#OUT_NUM C#OUT_NUM
  ,top.C#CODE C#RKC_CODE
  ,top.C#NAME C#RKC_NAME
FROM
  T#ACCOUNT acc
  JOIN T#ROOMS ON (acc.C#ROOMS_ID = T#ROOMS.C#ID)
  JOIN vd ON (acc.c#id = vd.c#id)
  JOIN spec ON (acc.c#id = spec.c#account_id)
  JOIN op ON (acc.c#id = op.c#account_id)
  JOIN T#OUT_PROC top on (top.c#id = op.C#OUT_PROC_ID)
;
