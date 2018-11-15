--------------------------------------------------------
--  DDL for Table T4_TRANSFER_TEMP
--------------------------------------------------------

  CREATE TABLE "FCR"."T4_TRANSFER_TEMP" 
   (	"HOUSE_ID" NUMBER(6,0), 
	"ADDR" VARCHAR2(256 BYTE), 
	"PROT_DATE" VARCHAR2(128 BYTE), 
	"SPOSOB" VARCHAR2(128 BYTE), 
	"SPOS_DATE" VARCHAR2(26 BYTE), 
	"SUMMA" VARCHAR2(26 BYTE), 
	"ACC_NUM" VARCHAR2(128 BYTE), 
	"NOTE" VARCHAR2(128 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
