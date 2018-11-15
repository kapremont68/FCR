--------------------------------------------------------
--  DDL for View V_TYPE_STATUS_CLAIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_TYPE_STATUS_CLAIM" ("C_ID", "C_TYPE") AS 
  SELECT 
    "C_ID","C_TYPE"
FROM fcr.t_TYPE_STATUS_CLAIM
;
