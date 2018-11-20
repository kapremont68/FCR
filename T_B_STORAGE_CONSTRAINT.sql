--------------------------------------------------------
--  Constraints for Table T#B_STORAGE
--------------------------------------------------------

  ALTER TABLE "FCR"."T#B_STORAGE" MODIFY ("C#C_SUM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORAGE" MODIFY ("C#M_SUM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORAGE" MODIFY ("C#P_SUM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORAGE" MODIFY ("C#T_SUM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORAGE" ADD CONSTRAINT "CP#B_STORAGE" PRIMARY KEY ("C#HOUSE_ID", "C#SERVICE_ID", "C#B_ACCOUNT_ID", "C#MN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;