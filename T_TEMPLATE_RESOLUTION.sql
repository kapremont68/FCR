--------------------------------------------------------
--  DDL for Table T_TEMPLATE_RESOLUTION
--------------------------------------------------------

  CREATE TABLE "FCR"."T_TEMPLATE_RESOLUTION" 
   (	"C_ID" NUMBER(10,0), 
	"C_PATH" VARCHAR2(255 BYTE), 
	"C_TEMPLATE" BLOB
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS#DATA1" 
 LOB ("C_TEMPLATE") STORE AS SECUREFILE (
  TABLESPACE "TS#DATA1" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES ) ;