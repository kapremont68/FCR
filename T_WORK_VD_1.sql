--------------------------------------------------------
--  DDL for Table T#WORK_VD
--------------------------------------------------------

  CREATE TABLE "FCR"."T#WORK_VD" 
   (	"C#ID" NUMBER(*,0), 
	"C#VN" NUMBER(*,0), 
	"C#VALID_TAG" VARCHAR2(1 BYTE), 
	"C#SIGN_DATE" DATE, 
	"C#SIGN_S_ID" NUMBER, 
	"C#TAR_TYPE_TAG" VARCHAR2(2 BYTE), 
	"C#TAR_VAL" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#ID" IS '�� �����.';
   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#VN" IS '����� ������.';
   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#VALID_TAG" IS '����������� {"N":���;"Y":��}.';
   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#SIGN_DATE" IS '�������, ����.';
   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#SIGN_S_ID" IS '�������, �� ������.';
   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#TAR_TYPE_TAG" IS '��� ������ (����������� ������) {"1":��������� (������� �� ������� ����);"A":���������.}';
   COMMENT ON COLUMN "FCR"."T#WORK_VD"."C#TAR_VAL" IS '�������� ������ (���� ������� ������).';
