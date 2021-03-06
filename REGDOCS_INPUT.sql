--------------------------------------------------------
--  DDL for Table REGDOCS_INPUT
--------------------------------------------------------

  CREATE TABLE "FCR"."REGDOCS_INPUT" 
   (	"DATE_INPUT" DATE, 
	"NUM_INPUT" VARCHAR2(40 BYTE), 
	"ON_DATE_OUT" DATE, 
	"ON_NUM_OUT" VARCHAR2(40 BYTE), 
	"FROM_W" VARCHAR2(255 BYTE), 
	"THEME" VARCHAR2(255 BYTE), 
	"ISPOLNITEL" VARCHAR2(40 BYTE), 
	"STATUS" VARCHAR2(40 BYTE), 
	"END_DATE" VARCHAR2(20 BYTE), 
	"C#ID" NUMBER(*,0), 
	"ISPOLNITEL2" VARCHAR2(40 BYTE), 
	"ISPOLNITEL3" VARCHAR2(40 BYTE), 
	"ISPOLNITEL4" VARCHAR2(40 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
