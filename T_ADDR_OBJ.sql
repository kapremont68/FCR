--------------------------------------------------------
--  DDL for Table T#ADDR_OBJ
--------------------------------------------------------

  CREATE TABLE "FCR"."T#ADDR_OBJ" 
   (	"C#ID" NUMBER(*,0), 
	"C#PARENT_ID" NUMBER(*,0), 
	"C#TYPE_ID" NUMBER(*,0), 
	"C#LEVEL_TAG" NUMBER(2,0), 
	"C#CENTER_TAG" NUMBER(1,0), 
	"C#NAME" VARCHAR2(120 BYTE), 
	"C#FIAS_GUID" VARCHAR2(36 BYTE), 
	"C#R_FORM_TAG" VARCHAR2(1 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ"."C#LEVEL_TAG" IS 'Уровень {"1":регион;"2":автономный округ;"3":район;"4":город;"5":внутригородская территория;"6":населенный пункт;"7":улица;"90":дополнительные территории;"91":подчиненные дополнительным территориям объекты}.';
   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ"."C#CENTER_TAG" IS 'Центр {"0":нет;"1":районный;"2":региональный;"3":районный+региональный}.';
   COMMENT ON COLUMN "FCR"."T#ADDR_OBJ"."C#R_FORM_TAG" IS 'Обратная форма (имя-тип) {"N":нет;"1":да}.';
