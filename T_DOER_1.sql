--------------------------------------------------------
--  DDL for Table T#DOER
--------------------------------------------------------

  CREATE TABLE "FCR"."T#DOER" 
   (	"C#ID" NUMBER(*,0), 
	"C#CHARGE_TAG" VARCHAR2(1 BYTE), 
	"C#NAME" VARCHAR2(50 BYTE), 
	"C#CODE" VARCHAR2(3 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
