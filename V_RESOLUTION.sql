--------------------------------------------------------
--  DDL for View V_RESOLUTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_RESOLUTION" ("C_ID", "C_DATE", "C_NUMBER", "T_RC_ID", "C_ID_RESOLUTION", "C_TYPE") AS 
  select "C_ID","C_DATE","C_NUMBER","T_RC_ID","C_ID_RESOLUTION","C_TYPE" from 
    fcr.t_resolution tr
  left JOIN 
  (SELECT
    tsc.t_rc_id,
    tsc.t_rc_id c_id_resolution,
    ttsc.c_type
  FROM 
  fcr.t_st_resolution tsc
  INNER JOIN fcr.t_st_resolution_vd tscv
  ON
    (
      tsc.c_id = tscv.c_id
    )
  INNER JOIN fcr.t_type_st_resolution ttsc
  ON
    (
      ttsc.c_id = tsc.t_type_src_id
    )
  WHERE
    1           =1
  AND tscv.C_VN =
    (
      SELECT
        MAX(C_VN)
      FROM
        fcr.t_st_resolution tsc1
      INNER JOIN fcr.t_st_resolution_vd tscv1
      ON
        (
          tsc1.c_id = tscv1.c_id
        )
      WHERE
        tsc1.c_id = tsc.c_id
    )) ts
     ON
    (
      ts.t_rc_id = tr.c_id
    )
;
