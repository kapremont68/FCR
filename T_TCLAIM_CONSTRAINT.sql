--------------------------------------------------------
--  Constraints for Table T_TCLAIM
--------------------------------------------------------

  ALTER TABLE "FCR"."T_TCLAIM" MODIFY ("C_ID_TC" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_TCLAIM" MODIFY ("C_ID_CLAIM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_TCLAIM" ADD CONSTRAINT "T_TEMP_CLAIM_PK" PRIMARY KEY ("C_ID_TC", "C_ID_CLAIM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
