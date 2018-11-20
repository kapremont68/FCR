--------------------------------------------------------
--  DDL for Table TT#GIS_CHARGE_FOR_GIS
--------------------------------------------------------

  CREATE TABLE "FCR"."TT#GIS_CHARGE_FOR_GIS" 
   (	"PERIOD" VARCHAR2(20 BYTE), 
	"ACCOUNT_ID" NUMBER, 
	"GKU_ID" VARCHAR2(20 BYTE), 
	"CHARGE_MN" NUMBER(15,2), 
	"DOLG" NUMBER(15,2), 
	"AVANS" NUMBER(15,2), 
	"BIC_NUM" VARCHAR2(20 BYTE), 
	"BANK_ACC_NUM" VARCHAR2(20 BYTE), 
	"TARIF" NUMBER(15,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;