--------------------------------------------------------
--  DDL for Table T_DATA_DEFENDANT
--------------------------------------------------------

  CREATE TABLE "FCR"."T_DATA_DEFENDANT" 
   (	"C_ID" NUMBER, 
	"C_DATE_BIRTH" DATE, 
	"C_BIRTHPLACE" VARCHAR2(255 BYTE), 
	"C_RESIDENCE" VARCHAR2(255 BYTE), 
	"C_ID_DEF" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T_DATA_DEFENDANT"."C_ID_DEF" IS 'Ид ответчика
';
