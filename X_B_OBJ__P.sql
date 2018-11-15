--------------------------------------------------------
--  DDL for Index X#B_OBJ##P
--------------------------------------------------------

  CREATE UNIQUE INDEX "FCR"."X#B_OBJ##P" ON "FCR"."T#B_OBJ" ("C#HOUSE_ID", "C#SERVICE_ID", "C#B_ACCOUNT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
