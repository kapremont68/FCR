--------------------------------------------------------
--  DDL for Table T#PERSON_ADDR
--------------------------------------------------------

  CREATE TABLE "FCR"."T#PERSON_ADDR" 
   (	"C#PERSON_ID" NUMBER(*,0), 
	"C#POST_CODE" VARCHAR2(6 BYTE), 
	"C#1_TEXT" VARCHAR2(250 BYTE), 
	"C#2_TEXT" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
