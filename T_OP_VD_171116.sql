--------------------------------------------------------
--  DDL for Table T#OP_VD_171116
--------------------------------------------------------

  CREATE TABLE "FCR"."T#OP_VD_171116" 
   (	"C#ID" NUMBER(*,0), 
	"C#VN" NUMBER(*,0), 
	"C#VALID_TAG" VARCHAR2(1 BYTE), 
	"C#SIGN_DATE" DATE, 
	"C#SIGN_S_ID" NUMBER(*,0), 
	"C#SUM" NUMBER(38,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 16384 NEXT 8192 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#OP_VD_171116"."C#ID" IS '�� �����.';
   COMMENT ON COLUMN "FCR"."T#OP_VD_171116"."C#VN" IS '����� ������.';
   COMMENT ON COLUMN "FCR"."T#OP_VD_171116"."C#VALID_TAG" IS '����������� {"N":���;"Y":��}.';
   COMMENT ON COLUMN "FCR"."T#OP_VD_171116"."C#SIGN_DATE" IS '�������, ����.';
   COMMENT ON COLUMN "FCR"."T#OP_VD_171116"."C#SIGN_S_ID" IS '�������, �� ������.';
