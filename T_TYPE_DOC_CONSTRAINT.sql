--------------------------------------------------------
--  Constraints for Table T_TYPE_DOC
--------------------------------------------------------

  ALTER TABLE "FCR"."T_TYPE_DOC" ADD CONSTRAINT "T_TYPE_DOC_PK" PRIMARY KEY ("C_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T_TYPE_DOC" MODIFY ("C_ID" NOT NULL ENABLE);
