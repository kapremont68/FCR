--------------------------------------------------------
--  DDL for Table TT#GIS_FOND_SIZE_FOR_GIS
--------------------------------------------------------

  CREATE TABLE "FCR"."TT#GIS_FOND_SIZE_FOR_GIS" 
   (	"HOUSE_ID" NUMBER, 
	"ACCOUNT_ID" NUMBER, 
	"MIN_MN" NUMBER, 
	"MAX_MN" NUMBER, 
	"ADDR" VARCHAR2(100 BYTE), 
	"FIAS_GUID" VARCHAR2(100 BYTE), 
	"OKTMO" NUMBER(10,0), 
	"PERIOD" VARCHAR2(20 BYTE), 
	"BEGIN_PAY_SUM_HOUSE" NUMBER(15,2), 
	"END_PAY_SUM_HOUSE" NUMBER(15,2), 
	"PERIOD_JOB_SUM_HOUSE" NUMBER(15,2), 
	"DOLG_JOB_SUM_HOUSE" NUMBER(15,2), 
	"GKU_ID" VARCHAR2(20 BYTE), 
	"BEGIN_PAY_SUM_ACC" NUMBER(15,2), 
	"PERIOD_CHARGE_SUM_ACC" NUMBER(15,2), 
	"PERIOD_CHARGE_PENI_SUM_ACC" NUMBER(15,2), 
	"PERIOD_PAY_SUM_ACC" NUMBER(15,2), 
	"PERIOD_PAY_PENI_SUM_ACC" NUMBER(15,2), 
	"END_PAY_SUM_ACC" NUMBER(15,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
