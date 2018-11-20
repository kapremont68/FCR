--------------------------------------------------------
--  Constraints for Table T#STORE
--------------------------------------------------------

  ALTER TABLE "FCR"."T#STORE" MODIFY ("C#ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#STORE" MODIFY ("C#WORK_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#STORE" MODIFY ("C#DOER_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#STORE" MODIFY ("C#MN" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#STORE" MODIFY ("C#SIGN_DATE" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#STORE" MODIFY ("C#SIGN_S_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#STORE" ADD CONSTRAINT "CP#STORE" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#STORE" ADD CONSTRAINT "CU#STORE" UNIQUE ("C#ACCOUNT_ID", "C#WORK_ID", "C#DOER_ID", "C#MN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;