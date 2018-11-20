--------------------------------------------------------
--  DDL for Index I_T#GIS_FIAS
--------------------------------------------------------

  CREATE INDEX "FCR"."I_T#GIS_FIAS" ON "FCR"."T#GIS_ADRESES_FROM_GIS" ("HOUSE_ID_FIAS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;