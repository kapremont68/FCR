--------------------------------------------------------
--  DDL for Index T#TEMP_PAY_STROITEL_INDEX3
--------------------------------------------------------

  CREATE INDEX "FCR"."T#TEMP_PAY_STROITEL_INDEX3" ON "FCR"."T#TEMP_PAY_STROITEL" ("PER2") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
