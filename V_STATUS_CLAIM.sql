--------------------------------------------------------
--  DDL for View V_STATUS_CLAIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_STATUS_CLAIM" ("C_ID_CLAIM", "C_TYPE") AS 
  select tsc.t_claimc_id c_id_claim, ttsc.c_type from fcr.t_status_claim tsc inner join fcr.t_status_claim_vd tscv on (tsc.c_id = tscv.t_sclaimc_id)
inner join fcr.t_type_status_claim ttsc on (ttsc.c_id = tsc.T_TSTATUSC_ID)
WHERE   1=1 AND tscv.C_VN =  (SELECT  MAX(C_VN) from fcr.t_status_claim tsc1 inner join fcr.t_status_claim_vd tscv1 on (tsc1.c_id = tscv1.t_sclaimc_id) WHERE t_claimc_id = tsc.t_claimc_id )
;
