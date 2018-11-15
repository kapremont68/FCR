--------------------------------------------------------
--  DDL for View V_COURT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_COURT" ("C_ID", "C_NAME", "C_ID_ADDRESS", "C_ADDRESS", "C_INDEX", "C_REGION", "C_ID_TYPE", "C_TYPE") AS 
  select tc.c_id,tc.c_name,ta.c_id c_id_address, ta.c_address
, ta.c_index
, ta.c_region
, ttc.c_id c_id_type,ttc.c_type 
from fcr.t_court tc inner join fcr.t_address ta on (ta.c_id = tc.t_address_c_id)
inner join fcr.t_type_court ttc on (ttc.c_id = tc.t_type_c_id)
;
