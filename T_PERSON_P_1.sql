--------------------------------------------------------
--  DDL for Table T#PERSON_P
--------------------------------------------------------

  CREATE TABLE "FCR"."T#PERSON_P" 
   (	"C#PERSON_ID" NUMBER(*,0), 
	"C#F_NAME" VARCHAR2(50 BYTE), 
	"C#I_NAME" VARCHAR2(50 BYTE), 
	"C#O_NAME" VARCHAR2(50 BYTE), 
	"C#PHONE" VARCHAR2(12 BYTE), 
	"C#CONTACT" VARCHAR2(250 BYTE), 
	"C#NOTE" VARCHAR2(250 BYTE), 
	"C#MAIL" VARCHAR2(120 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
