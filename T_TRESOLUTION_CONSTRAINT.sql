--------------------------------------------------------
--  Constraints for Table T_TRESOLUTION
--------------------------------------------------------

  ALTER TABLE "FCR"."T_TRESOLUTION" MODIFY ("C_ID_TR" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_TRESOLUTION" MODIFY ("C_ID_RES" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_TRESOLUTION" ADD CONSTRAINT "T_TRESOLUTION_PK" PRIMARY KEY ("C_ID_TR", "C_ID_RES")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;