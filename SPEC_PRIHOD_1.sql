--------------------------------------------------------
--  DDL for Table SPEC_PRIHOD
--------------------------------------------------------

  CREATE TABLE "FCR"."SPEC_PRIHOD" 
   (	"ID_HOUSE" VARCHAR2(6 BYTE), 
	"TIP_TOWN" VARCHAR2(6 BYTE), 
	"TOWN" VARCHAR2(42 BYTE), 
	"TIP_UL" VARCHAR2(6 BYTE), 
	"N_UL" VARCHAR2(100 BYTE), 
	"N_HOUSE" VARCHAR2(7 BYTE), 
	"KORP" VARCHAR2(6 BYTE), 
	"PAY" VARCHAR2(12 BYTE), 
	"DT_PAY" DATE, 
	"HINDEX" VARCHAR2(6 BYTE), 
	"C#OPS_ID" NUMBER, 
	"C#ID" NUMBER, 
	"C#COMMENT" VARCHAR2(500 BYTE), 
	"ROW_TIME" TIMESTAMP (6) DEFAULT sysdate
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 8192 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON TABLE "FCR"."SPEC_PRIHOD"  IS '������� ������� ���������� ��������������� �������� ( (�) ����������), loc_dbf2ora.exe, 16.12.2015 11:06:39';
