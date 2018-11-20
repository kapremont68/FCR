--------------------------------------------------------
--  DDL for Table SOTR
--------------------------------------------------------

  CREATE TABLE "FCR"."SOTR" 
   (	"FIO" VARCHAR2(80 BYTE), 
	"IOF_SHORT" VARCHAR2(40 BYTE), 
	"IO" VARCHAR2(20 BYTE), 
	"FIO_DP" VARCHAR2(80 BYTE), 
	"DOLGNOST" VARCHAR2(90 BYTE), 
	"PHONE" VARCHAR2(20 BYTE), 
	"MAIL" VARCHAR2(80 BYTE), 
	"ROOM" VARCHAR2(4 BYTE), 
	"PORT1" VARCHAR2(6 BYTE), 
	"PORT2" VARCHAR2(6 BYTE), 
	"PORT3" VARCHAR2(6 BYTE), 
	"PORT1_DEVICE" VARCHAR2(40 BYTE), 
	"PORT2_DEVICE" VARCHAR2(40 BYTE), 
	"PORT3_DEVICE" VARCHAR2(40 BYTE), 
	"PRIM" VARCHAR2(255 BYTE), 
	"BIRTHDAY" DATE, 
	"OTDEL" VARCHAR2(150 BYTE), 
	"LOGIN_NAME" NVARCHAR2(50), 
	"ACCESS_LAVEL" NUMBER(*,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;