--------------------------------------------------------
--  Constraints for Table T_JUDGE
--------------------------------------------------------

  ALTER TABLE "FCR"."T_JUDGE" MODIFY ("C_ID" CONSTRAINT "NNC_T_JUDGE_C_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_JUDGE" MODIFY ("T_PERSON_C_ID" CONSTRAINT "NNC_T_JUDGE_T_PERSON_C_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_JUDGE" MODIFY ("T_SITE_C_ID" CONSTRAINT "NNC_T_JUDGE_T_COURT_C_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_JUDGE" ADD CONSTRAINT "T_JUDGE_PK" PRIMARY KEY ("C_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
