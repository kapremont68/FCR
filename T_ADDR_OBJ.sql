--------------------------------------------------------
--  DDL for Table T#ADDR_OBJ
--------------------------------------------------------

  CREATE TABLE "FCR"."T#ADDR_OBJ" 
   (	"C#ID" NUMBER(*,0), 
	"C#PARENT_ID" NUMBER(*,0), 
	"C#TYPE_ID" NUMBER(*,0), 
	"C#LEVEL_TAG" NUMBER(2,0), 
	"C#CENTER_TAG" NUMBER(1,0), 
	"C#NAME" VARCHAR2(120 BYTE), 
	"C#FIAS_GUID" VARCHAR2(36 BYTE), 
	"C#R_FORM_TAG" VARCHAR2(1 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ"."C#LEVEL_TAG" IS '������� {"1":������;"2":���������� �����;"3":�����;"4":�����;"5":��������������� ����������;"6":���������� �����;"7":�����;"90":�������������� ����������;"91":����������� �������������� ����������� �������}.';
   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ"."C#CENTER_TAG" IS '����� {"0":���;"1":��������;"2":������������;"3":��������+������������}.';
   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ"."C#R_FORM_TAG" IS '�������� ����� (���-���) {"N":���;"1":��}.';
