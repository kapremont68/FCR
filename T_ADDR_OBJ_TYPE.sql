--------------------------------------------------------
--  DDL for Table T#ADDR_OBJ_TYPE
--------------------------------------------------------

  CREATE TABLE "FCR"."T#ADDR_OBJ_TYPE" 
   (	"C#ID" NUMBER(*,0), 
	"C#LEVEL_TAG" NUMBER(2,0), 
	"C#ABBR_NAME" VARCHAR2(10 BYTE), 
	"C#FULL_NAME" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ_TYPE"."C#LEVEL_TAG" IS 'Уровень {"1":регион;"2":автономный округ;"3":район;"4":город;"5":внутригородская территория;"6":населенный пункт;"7":улица;"90":дополнительные территории;"91":подчиненные дополнительным территориям объекты}.';
