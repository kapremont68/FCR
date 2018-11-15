--------------------------------------------------------
--  Constraints for Table T#BANK
--------------------------------------------------------

  ALTER TABLE "FCR"."T#BANK" ADD CONSTRAINT "CC#BANK#BIC" CHECK (regexp_like(C#BIC_NUM,'^04[0-9]{7}$')) ENABLE;
  ALTER TABLE "FCR"."T#BANK" ADD CONSTRAINT "CC#BANK#CA" CHECK (regexp_like(C#CA_NUM,'^301[0-9]{17}$')) ENABLE;
  ALTER TABLE "FCR"."T#BANK" MODIFY ("C#NAME" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#BANK" MODIFY ("C#BIC_NUM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#BANK" ADD CONSTRAINT "CP#BANK" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#BANK" ADD CONSTRAINT "CU#BANK#1" UNIQUE ("C#NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#BANK" ADD CONSTRAINT "CU#BANK#2" UNIQUE ("C#BIC_NUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
