--------------------------------------------------------
--  DDL for Index T3_JOBS_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "FCR"."T3_JOBS_UK1" ON "FCR"."T3_JOBS" ("C#JOB_TYPE_ID", "C#CONTRACT_ID", "C#HOUSE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
