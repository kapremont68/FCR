--------------------------------------------------------
--  DDL for Table T#TEMP_IV
--------------------------------------------------------

  CREATE TABLE "FCR"."T#TEMP_IV" 
   (	"COLUMN1" VARCHAR2(128 BYTE), 
	"COLUMN2" NUMBER(27,18)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;