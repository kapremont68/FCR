--------------------------------------------------------
--  DDL for View V_STATUS_RESOLUTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_STATUS_RESOLUTION" ("C_ID_RESOLUTION", "C_TYPE") AS 
  select tsc.t_rc_id c_id_resolution, ttsc.c_type from fcr.t_st_resolution tsc inner join fcr.t_st_resolution_vd tscv on (tsc.c_id = tscv.c_id)
inner join fcr.t_type_st_resolution ttsc on (ttsc.c_id = tsc.t_type_src_id)
WHERE   1=1 AND tscv.C_VN =  ( SELECT  MAX(C_VN)  from fcr.t_st_resolution tsc1 inner join fcr.t_st_resolution_vd tscv1 on (tsc1.c_id = tscv1.c_id) WHERE tsc1.c_id = tsc.c_id )
;
