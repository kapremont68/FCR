--------------------------------------------------------
--  DDL for Table T#TEMP_STROITEL_2018_02
--------------------------------------------------------

  CREATE TABLE "FCR"."T#TEMP_STROITEL_2018_02" 
   (	"PER" VARCHAR2(20 BYTE), 
	"HOST" VARCHAR2(128 BYTE), 
	"CITY" VARCHAR2(50 BYTE), 
	"UL_NAME" VARCHAR2(50 BYTE), 
	"DOM" VARCHAR2(20 BYTE), 
	"DOP_NAME" VARCHAR2(26 BYTE), 
	"KV" VARCHAR2(26 BYTE), 
	"LSO" NUMBER(20,0), 
	"SA_KAPREM" NUMBER(9,2), 
	"OPL_KAPREM" NUMBER(9,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
