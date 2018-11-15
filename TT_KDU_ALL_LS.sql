--------------------------------------------------------
--  DDL for Table TT#KDU_ALL_LS
--------------------------------------------------------

  CREATE TABLE "FCR"."TT#KDU_ALL_LS" 
   (	"ADR" VARCHAR2(200 BYTE), 
	"KV" VARCHAR2(200 BYTE), 
	"SHORT_LS" VARCHAR2(100 BYTE), 
	"FIO" VARCHAR2(200 BYTE), 
	"AREA" VARCHAR2(50 BYTE), 
	"LS" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
