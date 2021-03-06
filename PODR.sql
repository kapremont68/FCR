--------------------------------------------------------
--  DDL for Table PODR
--------------------------------------------------------

  CREATE TABLE "FCR"."PODR" 
   (	"C#ID" VARCHAR2(20 BYTE), 
	"C#ID_1C" VARCHAR2(20 BYTE), 
	"C#SHORT_NAME" VARCHAR2(150 BYTE), 
	"C#FULL_NAME" VARCHAR2(255 BYTE), 
	"C#INN" VARCHAR2(12 BYTE), 
	"VKEY" VARCHAR2(8 BYTE), 
	"C#UR_ADR" VARCHAR2(255 BYTE), 
	"C#MAIL" VARCHAR2(30 BYTE), 
	"C#PHONE" VARCHAR2(15 BYTE), 
	"C#PRIM" VARCHAR2(255 BYTE), 
	"C#FIO_RUK" VARCHAR2(200 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."PODR"."VKEY" IS 'идентификатор банка';
