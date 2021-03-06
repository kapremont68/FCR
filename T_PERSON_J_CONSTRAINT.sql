--------------------------------------------------------
--  Constraints for Table T#PERSON_J
--------------------------------------------------------

  ALTER TABLE "FCR"."T#PERSON_J" MODIFY ("C#NAME" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#PERSON_J" MODIFY ("C#INN_NUM" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#PERSON_J" ADD CONSTRAINT "CP#PERSON_J" PRIMARY KEY ("C#PERSON_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#PERSON_J" ADD CONSTRAINT "CU#PERSON_J" UNIQUE ("C#INN_NUM", "C#KPP_NUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#PERSON_J" ADD CONSTRAINT "CC#PERSON_J#INN" CHECK (regexp_like(C#INN_NUM,'^[0-9]{10}([0-9]{2})?$')) ENABLE;
  ALTER TABLE "FCR"."T#PERSON_J" ADD CONSTRAINT "CC#PERSON_J#KPP" CHECK (regexp_like(C#KPP_NUM,'^[0-9]{9}$')) ENABLE;
