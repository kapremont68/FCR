--------------------------------------------------------
--  DDL for Table T3_CONTRACTS
--------------------------------------------------------

  CREATE TABLE "FCR"."T3_CONTRACTS" 
   (	"C#ID" NUMBER(10,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE , 
	"C#DATE" DATE, 
	"C#NUM" VARCHAR2(50 BYTE), 
	"C#CONTRACT_TYPE_ID" NUMBER(10,0), 
	"C#CONTRACTOR_ID" NUMBER(10,0), 
	"C#DESCRIPTION" VARCHAR2(500 BYTE), 
	"C#DATE_BEGIN" DATE, 
	"C#DATE_END" DATE, 
	"C#SUM" NUMBER(*,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#DATE" IS '���� ���������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#NUM" IS '����� ���������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#CONTRACT_TYPE_ID" IS '��� ���������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#CONTRACTOR_ID" IS '���������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#DESCRIPTION" IS '��������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#DATE_BEGIN" IS '���� ������ ����� �� ��������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#DATE_END" IS '���� ��������� ����� �� ��������';
   COMMENT ON COLUMN "FCR"."T3_CONTRACTS"."C#SUM" IS '����� �� ��������';
   COMMENT ON TABLE "FCR"."T3_CONTRACTS"  IS '��������� (��������) �� ������ �� ����������';