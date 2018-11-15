--------------------------------------------------------
--  DDL for Table T3_JOBS_PLAN_BAK
--------------------------------------------------------

  CREATE TABLE "FCR"."T3_JOBS_PLAN_BAK" 
   (	"C#ID" NUMBER(10,0), 
	"C#REG_JOB_TYPE_ID" NUMBER(10,0), 
	"C#REC_DATE" DATE, 
	"C#YEAR_BEG" NUMBER(4,0), 
	"C#NOTE" VARCHAR2(250 BYTE), 
	"C#HOUSE_ID" NUMBER(10,0), 
	"C#SUMM" NUMBER, 
	"C#YEAR_END" NUMBER(4,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
