--------------------------------------------------------
--  DDL for Table T#B_STORE
--------------------------------------------------------

  CREATE TABLE "FCR"."T#B_STORE" 
   (	"C#ID" NUMBER(*,0), 
	"C#HOUSE_ID" NUMBER(*,0), 
	"C#SERVICE_ID" NUMBER(*,0), 
	"C#B_ACCOUNT_ID" NUMBER(*,0), 
	"C#MN" NUMBER(4,0), 
	"C#SIGN_DATE" DATE, 
	"C#SIGN_S_ID" NUMBER(*,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#B_STORE"."C#SIGN_DATE" IS '�������, ����.';
   COMMENT ON COLUMN "FCR"."T#B_STORE"."C#SIGN_S_ID" IS '�������, �� ������.';
