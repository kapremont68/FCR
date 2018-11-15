--------------------------------------------------------
--  DDL for View V_JUDGE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_JUDGE" ("C_ID", "C_FIRST_NAME", "C_MIDDLE_NAME", "C_LAST_NAME", "C_PHONE", "C_MAIL", "C_ID_COURT", "NAME_COURT", "C_ID_SITE", "NAME_SITE", "C_ADDRESS", "C_INDEX", "C_REGION") AS 
  select tj.c_id
      ,tp.C_FIRST_NAME
      ,tp.C_MIDDLE_NAME
      ,tp.C_LAST_NAME
      ,tp.c_phone
      ,tp.c_mail
      ,tc.c_id C_ID_COURT
      ,tc.c_name name_court
      ,ts.c_id c_id_site
      ,ts.c_site name_site
      ,ta.c_address
      ,ta.c_index
      ,ta.c_region
      from fcr.t_judge tj 
      inner join fcr.t_person tp on (tj.t_person_c_id = tp.c_id) 
      inner join fcr.t_site ts on (tj.t_site_c_id = ts.c_id)
      inner join fcr.t_court tc on (ts.c_id_court = tc.c_id)
      inner join fcr.t_address ta on (ta.c_id = tc.t_address_c_id)
;
