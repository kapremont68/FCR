--------------------------------------------------------
--  DDL for Table TT#GIS_ACCLIST_FOR_GIS
--------------------------------------------------------

  CREATE TABLE "FCR"."TT#GIS_ACCLIST_FOR_GIS" 
   (	"ACCOUNT_ID" NUMBER(*,0), 
	"ACCOUNT_NUM" VARCHAR2(20 BYTE), 
	"FAM" VARCHAR2(4000 BYTE), 
	"IM" VARCHAR2(4000 BYTE), 
	"OTCH" VARCHAR2(4000 BYTE), 
	"ROOM_NUM" VARCHAR2(4000 BYTE), 
	"LIVING_TAG" VARCHAR2(1 BYTE), 
	"FLAT_NUM" VARCHAR2(50 BYTE), 
	"AREA_VAL" NUMBER, 
	"FIAS_GUID" VARCHAR2(36 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
