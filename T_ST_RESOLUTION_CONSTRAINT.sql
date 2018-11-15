--------------------------------------------------------
--  Constraints for Table T_ST_RESOLUTION
--------------------------------------------------------

  ALTER TABLE "FCR"."T_ST_RESOLUTION" ADD CONSTRAINT "T_ST_RESOLUTION_PK" PRIMARY KEY ("C_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T_ST_RESOLUTION" MODIFY ("T_RC_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_ST_RESOLUTION" MODIFY ("T_TYPE_SRC_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_ST_RESOLUTION" MODIFY ("C_ID" NOT NULL ENABLE);
