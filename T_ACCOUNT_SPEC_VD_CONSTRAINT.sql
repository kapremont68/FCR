--------------------------------------------------------
--  Constraints for Table T#ACCOUNT_SPEC_VD
--------------------------------------------------------

  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" ADD CONSTRAINT "CP#ACCOUNT_SPEC_VD" PRIMARY KEY ("C#ID", "C#VN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS COMPRESS 1 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" MODIFY ("C#VALID_TAG" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" MODIFY ("C#SIGN_DATE" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" MODIFY ("C#SIGN_S_ID" NOT NULL ENABLE);
  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" ADD CONSTRAINT "CC#ACCOUNT_SPEC_VD#VT" CHECK (C#VALID_TAG in ('N','Y')) ENABLE;
  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" ADD CONSTRAINT "CC#ACCOUNT_SPEC_VD#PC" CHECK (C#PART_COEF >= 0 and C#PART_COEF <= 1) ENABLE;
  ALTER TABLE "FCR"."T#ACCOUNT_SPEC_VD" ADD CONSTRAINT "CC#ACCOUNT_SPEC_VD#VNN" CHECK (C#VALID_TAG = 'N' or (C#PERSON_ID is not null and C#PART_COEF is not null)) ENABLE;
