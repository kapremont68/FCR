--------------------------------------------------------
--  DDL for Table TEMP_ALL_OP
--------------------------------------------------------

  CREATE TABLE "FCR"."TEMP_ALL_OP" 
   (	"DATA_PL" VARCHAR2(26 BYTE), 
	"SUMM_PL" NUMBER(10,2), 
	"PENALTY" NUMBER(3,0), 
	"LS" VARCHAR2(26 BYTE), 
	"PERIOD" VARCHAR2(26 BYTE), 
	"COD_RKC" NUMBER(4,0), 
	"PD_NUM" NUMBER(8,0), 
	"INN" NUMBER(14,0), 
	"KPP" NUMBER(11,0), 
	"PLAT" VARCHAR2(256 BYTE), 
	"PRIM" VARCHAR2(1024 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
