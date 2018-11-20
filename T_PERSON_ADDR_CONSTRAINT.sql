--------------------------------------------------------
--  Constraints for Table T#PERSON_ADDR
--------------------------------------------------------

  ALTER TABLE "FCR"."T#PERSON_ADDR" ADD CONSTRAINT "CP#PERSON_ADDR" PRIMARY KEY ("C#PERSON_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#PERSON_ADDR" ADD CONSTRAINT "CC#PERSON_ADDR#PC" CHECK (regexp_like(C#POST_CODE,'^[0-9]{6}$')) ENABLE;