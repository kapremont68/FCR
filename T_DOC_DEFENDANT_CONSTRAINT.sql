--------------------------------------------------------
--  Constraints for Table T_DOC_DEFENDANT
--------------------------------------------------------

  ALTER TABLE "FCR"."T_DOC_DEFENDANT" MODIFY ("C_ID_DEF" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_DOC_DEFENDANT" ADD CONSTRAINT "T_DOC_DEFENDANT_PK" PRIMARY KEY ("C_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T_DOC_DEFENDANT" MODIFY ("T_TYPE_DOCC_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T_DOC_DEFENDANT" MODIFY ("C_ID" NOT NULL ENABLE);
