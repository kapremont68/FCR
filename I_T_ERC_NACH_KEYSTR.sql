--------------------------------------------------------
--  DDL for Index I#T#ERC_NACH_KEYSTR
--------------------------------------------------------

  CREATE INDEX "FCR"."I#T#ERC_NACH_KEYSTR" ON "FCR"."T#ERC_NACH" ("CITY"||','||"UL_NAME"||','||"DOM"||','||"DOP_NAME"||','||"KV") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
