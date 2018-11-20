--------------------------------------------------------
--  DDL for Table T#GIS_ADRESES_FROM_GIS
--------------------------------------------------------

  CREATE TABLE "FCR"."T#GIS_ADRESES_FROM_GIS" 
   (	"ADDR" NVARCHAR2(130), 
	"HOUSE_ID_GIS" NVARCHAR2(50), 
	"HOUSE_ID_FIAS" NVARCHAR2(50), 
	"PARENT_ID_FIAS" NVARCHAR2(50), 
	"HOUSE_NUM" NVARCHAR2(50), 
	"KORP_NUM" NVARCHAR2(50), 
	"STROENIE_NUM" NVARCHAR2(50), 
	"PRIZN_VLAD" NVARCHAR2(50), 
	"PRIZN_STROEN" NVARCHAR2(50), 
	"GIL_POM_NUM" NVARCHAR2(50), 
	"NEGIL_POM_NUM" NVARCHAR2(50), 
	"KOM_NUM" NVARCHAR2(50), 
	"UNIQ_DOM_NUM" NVARCHAR2(50), 
	"UNIQ_POM_NUM" NVARCHAR2(50), 
	"UNIQ_KOM_NUM" NVARCHAR2(50), 
	"KADASTR_NUM" NVARCHAR2(50)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON TABLE "FCR"."T#GIS_ADRESES_FROM_GIS"  IS '�������� �� ��� ��� � ������� �����';