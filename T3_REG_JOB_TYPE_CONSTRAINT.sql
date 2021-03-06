--------------------------------------------------------
--  Constraints for Table T3_REG_JOB_TYPE
--------------------------------------------------------

  ALTER TABLE "FCR"."T3_REG_JOB_TYPE" MODIFY ("C#ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T3_REG_JOB_TYPE" ADD CONSTRAINT "T3_REG_JOB_TYPE_PK" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
