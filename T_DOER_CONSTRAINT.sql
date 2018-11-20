--------------------------------------------------------
--  Constraints for Table T#DOER
--------------------------------------------------------

  ALTER TABLE "FCR"."T#DOER" MODIFY ("C#CHARGE_TAG" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#DOER" MODIFY ("C#NAME" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#DOER" ADD CONSTRAINT "CC#DOER#CT" CHECK (C#CHARGE_TAG in ('N','Y')) ENABLE;
  ALTER TABLE "FCR"."T#DOER" ADD CONSTRAINT "CP#DOER" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#DOER" ADD CONSTRAINT "CU#DOER" UNIQUE ("C#NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;