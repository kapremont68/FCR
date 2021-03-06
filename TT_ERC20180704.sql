--------------------------------------------------------
--  DDL for Table TT#ERC20180704
--------------------------------------------------------

  CREATE TABLE "FCR"."TT#ERC20180704" 
   (	"NN" NUMBER(10,0), 
	"YYYY" NUMBER(6,0), 
	"MM" NUMBER(3,0), 
	"LS" VARCHAR2(20 BYTE), 
	"ZAYYYY" NUMBER(6,0), 
	"ZAMM" NUMBER(3,0), 
	"DATA" DATE, 
	"SUMMA" NUMBER(7,2), 
	"UK" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
