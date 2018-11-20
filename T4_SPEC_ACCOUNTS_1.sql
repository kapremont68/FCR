--------------------------------------------------------
--  DDL for Table T4_SPEC_ACCOUNTS
--------------------------------------------------------

  CREATE TABLE "FCR"."T4_SPEC_ACCOUNTS" 
   (	"C#ID" NUMBER, 
	"C#ACC_NUM" VARCHAR2(20 BYTE), 
	"C#ACC_HOST_ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON TABLE "FCR"."T4_SPEC_ACCOUNTS"  IS '���������';