--------------------------------------------------------
--  Constraints for Table T3_CONTRACTORS
--------------------------------------------------------

  ALTER TABLE "FCR"."T3_CONTRACTORS" MODIFY ("C#ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T3_CONTRACTORS" ADD CONSTRAINT "PK_T3_CONTRACTORS_C#ID" PRIMARY KEY ("C#ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T3_CONTRACTORS" ADD CONSTRAINT "T3_CONTRACTORS_UK1" UNIQUE ("C#INN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
