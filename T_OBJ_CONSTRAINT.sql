--------------------------------------------------------
--  Constraints for Table T#OBJ
--------------------------------------------------------

  ALTER TABLE "FCR"."T#OBJ" ADD CONSTRAINT "CP#OBJ" PRIMARY KEY ("C#ACCOUNT_ID", "C#WORK_ID", "C#DOER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;