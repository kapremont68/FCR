--------------------------------------------------------
--  DDL for View V_DEFENDANT
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_DEFENDANT" ("C_ID", "C_ROOMS_ID", "C_PERSON_ID", "PERSON_NAME", "ADDRESS", "ID_DATA_DEF", "C_BIRTHPLACE", "C_DATE_BIRTH", "C_RESIDENCE", "ID_DOC_DEF", "C_ADDITIONAL", "C_COMMENT", "C_DATE", "C_GIVE", "C_NUMBER", "C_SERIES", "T_TYPE_DOCC_ID") AS 
  SELECT
    td.c_id
    ,tdr.c_rooms_id
    ,td.c_person_id
    ,fcr.p#utils.get#person_name(td.c_person_id) person_name
    ,fcr.p#utils.get#rooms_addr(tdr.c_rooms_id) address
    ,tdd.c_id id_data_def
    ,tdd.C_BIRTHPLACE
    ,tdd.C_DATE_BIRTH
    ,tdd.C_RESIDENCE
    ,tdocd.c_id id_doc_def
    ,tdocd.C_ADDITIONAL
    ,tdocd.C_COMMENT
    ,tdocd.C_DATE
    ,tdocd.C_GIVE
    ,tdocd.C_NUMBER
    ,tdocd.C_SERIES
    ,tdocd.T_TYPE_DOCC_ID
  FROM
    fcr.t_defendant td
    left join fcr.t_def_rooms tdr on (td.c_id = tdr.c_id_def)
    LEFT JOIN fcr.t_DATA_DEFENDANT tdd
  ON
    (
      td.c_id = tdd.c_id_def
    )
  LEFT JOIN fcr.t_DOC_DEFENDANT tdocd
  ON
    (
      td.c_id = tdocd.c_id_def
    )
;
