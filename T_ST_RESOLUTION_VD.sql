--------------------------------------------------------
--  DDL for Table T_ST_RESOLUTION_VD
--------------------------------------------------------

  CREATE TABLE "FCR"."T_ST_RESOLUTION_VD" 
   (	"C_ID" NUMBER(10,0), 
	"C_DATE" DATE, 
	"C_VN" NUMBER(10,0), 
	"C_VALID_TAG" VARCHAR2(1 BYTE), 
	"C_SIGN_S_ID" NUMBER(10,0), 
	"C_SIGN_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
