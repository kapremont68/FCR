--------------------------------------------------------
--  DDL for Table T#TEMP_99
--------------------------------------------------------

  CREATE TABLE "FCR"."T#TEMP_99" 
   (	"C#ID" NUMBER, 
	"C#ACCOUNT" VARCHAR2(30 BYTE), 
	"C#REAL_DATE" DATE, 
	"C#SUMMA" NUMBER, 
	"C#FINE" NUMBER, 
	"C#PERIOD" VARCHAR2(4 BYTE), 
	"C#COD_RKC" VARCHAR2(4 BYTE), 
	"C#PAY_NUM" NUMBER, 
	"C#FILE_ID" NUMBER, 
	"C#TRANSFER_FLG" NUMBER, 
	"C#ACC_ID" NUMBER, 
	"C#ACC_ID_CLOSE" NUMBER, 
	"C#ACC_ID_TTER" NUMBER, 
	"C#OPS_ID" NUMBER, 
	"C#KIND_ID" NUMBER, 
	"C#UPLOAD_FLG" NUMBER, 
	"C#STORNO_ID" NUMBER, 
	"C#DATE" DATE, 
	"C#COMMENT" VARCHAR2(250 BYTE), 
	"C#INN" VARCHAR2(12 BYTE), 
	"C#KPP" VARCHAR2(9 BYTE), 
	"C#PLAT" VARCHAR2(254 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
