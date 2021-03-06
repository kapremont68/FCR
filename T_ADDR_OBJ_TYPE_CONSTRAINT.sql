--------------------------------------------------------
--  Constraints for Table T#ADDR_OBJ_TYPE
--------------------------------------------------------

  ALTER TABLE "FCR"."T#ADDR_OBJ_TYPE" MODIFY ("C#LEVEL_TAG" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#ADDR_OBJ_TYPE" MODIFY ("C#ABBR_NAME" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#ADDR_OBJ_TYPE" MODIFY ("C#FULL_NAME" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#ADDR_OBJ_TYPE" ADD CONSTRAINT "CC#ADDR_OBJ_TYPE#LT" CHECK (C#LEVEL_TAG in (1,2,3,4,5,6,7,8,9,35,65,75,90,91)) ENABLE;
  ALTER TABLE "FCR"."T#ADDR_OBJ_TYPE" ADD CONSTRAINT "CP#ADDR_OBJ_TYPE" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#ADDR_OBJ_TYPE" ADD CONSTRAINT "CU#ADDR_OBJ_TYPE" UNIQUE ("C#LEVEL_TAG", "C#ABBR_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
