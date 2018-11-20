--------------------------------------------------------
--  Constraints for Table T#OP
--------------------------------------------------------

  ALTER TABLE "FCR"."T#OP" MODIFY ("C#OPS_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#ACCOUNT_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#WORK_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#DOER_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#DATE" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#A_MN" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#B_MN" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" MODIFY ("C#TYPE_TAG" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#OP" ADD CONSTRAINT "CC#OP#TT" CHECK (C#TYPE_TAG in ('MC','M','MP','P','FC','FP')) ENABLE;
  ALTER TABLE "FCR"."T#OP" ADD CONSTRAINT "CP#OP" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#OP" ADD CONSTRAINT "T#OP_CHK1" CHECK (C#REAL_DATE >= TO_DATE('01.06.2014','dd.mm.yyyy')) ENABLE;