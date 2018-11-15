--------------------------------------------------------
--  DDL for Table T#CHARGE
--------------------------------------------------------

  CREATE TABLE "FCR"."T#CHARGE" 
   (	"C#ID" NUMBER(*,0), 
	"C#ACCOUNT_ID" NUMBER(*,0), 
	"C#WORK_ID" NUMBER(*,0), 
	"C#DOER_ID" NUMBER(*,0), 
	"C#MN" NUMBER(4,0), 
	"C#A_MN" NUMBER(4,0), 
	"C#B_MN" NUMBER(4,0), 
	"C#VOL" NUMBER, 
	"C#SUM" NUMBER(38,2), 
	"C#SIGN_DATE" DATE, 
	"C#SIGN_S_ID" NUMBER(*,0), 
	"C#ROW_TIME" TIMESTAMP (6) DEFAULT sysdate
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#CHARGE"."C#SIGN_DATE" IS '�������, ����.';
   COMMENT ON COLUMN "FCR"."T#CHARGE"."C#SIGN_S_ID" IS '�������, �� ������.';
