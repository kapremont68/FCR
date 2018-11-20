--------------------------------------------------------
--  DDL for Table KAP_OPL
--------------------------------------------------------

  CREATE TABLE "FCR"."KAP_OPL" 
   (	"OUTERLS" NUMBER, 
	"LS" VARCHAR2(56 BYTE), 
	"SUM_PL" NUMBER, 
	"SUM_FINE" NUMBER, 
	"DT_PAY" DATE, 
	"PERIOD" CHAR(4 BYTE), 
	"ABONENT" VARCHAR2(200 BYTE), 
	"BASE" VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;