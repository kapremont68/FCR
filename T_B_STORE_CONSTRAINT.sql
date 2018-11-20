--------------------------------------------------------
--  Constraints for Table T#B_STORE
--------------------------------------------------------

  ALTER TABLE "FCR"."T#B_STORE" MODIFY ("C#HOUSE_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORE" MODIFY ("C#SERVICE_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORE" MODIFY ("C#B_ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORE" MODIFY ("C#MN" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORE" MODIFY ("C#SIGN_DATE" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORE" MODIFY ("C#SIGN_S_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#B_STORE" ADD CONSTRAINT "CP#B_STORE" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#B_STORE" ADD CONSTRAINT "CU#B_STORE" UNIQUE ("C#HOUSE_ID", "C#SERVICE_ID", "C#B_ACCOUNT_ID", "C#MN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;