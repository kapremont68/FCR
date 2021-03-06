--------------------------------------------------------
--  DDL for Table TEMP_DEL
--------------------------------------------------------

  CREATE TABLE "FCR"."TEMP_DEL" 
   (	"C#ID" NUMBER(*,0), 
	"C#OPS_ID" NUMBER(*,0), 
	"C#ACCOUNT_ID" NUMBER(*,0), 
	"C#WORK_ID" NUMBER(*,0), 
	"C#DOER_ID" NUMBER(*,0), 
	"C#DATE" DATE, 
	"C#REAL_DATE" DATE, 
	"C#A_MN" NUMBER(4,0), 
	"C#B_MN" NUMBER(4,0), 
	"C#TYPE_TAG" VARCHAR2(2 BYTE), 
	"C#VN" NUMBER(*,0), 
	"C#VALID_TAG" VARCHAR2(1 BYTE), 
	"C#SIGN_DATE" DATE, 
	"C#SIGN_S_ID" NUMBER(*,0), 
	"C#SUM" NUMBER(38,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
