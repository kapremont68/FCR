--------------------------------------------------------
--  DDL for Table T#B_OBJ
--------------------------------------------------------

  CREATE TABLE "FCR"."T#B_OBJ" 
   (	"C#HOUSE_ID" NUMBER(*,0), 
	"C#SERVICE_ID" NUMBER(*,0), 
	"C#B_ACCOUNT_ID" NUMBER(*,0), 
	 CONSTRAINT "CP#B_OBJ" PRIMARY KEY ("C#HOUSE_ID", "C#SERVICE_ID", "C#B_ACCOUNT_ID") ENABLE
   ) ORGANIZATION INDEX NOCOMPRESS PCTFREE 10 INITRANS 2 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" 
 PCTTHRESHOLD 50;
