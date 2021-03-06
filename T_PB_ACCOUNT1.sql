--------------------------------------------------------
--  DDL for Table T#PB_ACCOUNT1
--------------------------------------------------------

  CREATE TABLE "FCR"."T#PB_ACCOUNT1" 
   (	"C#ID" NUMBER(*,0), 
	"C#NUM" VARCHAR2(20 BYTE), 
	"C#SN" NUMBER(*,0), 
	"C#ADDR" VARCHAR2(4000 BYTE), 
	"C#TOP_ADDR" VARCHAR2(4000 BYTE), 
	"C#P_CODE" VARCHAR2(6 BYTE), 
	"C#PP_CODE" VARCHAR2(6 BYTE), 
	"C#PP_NAME" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
