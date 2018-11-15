--------------------------------------------------------
--  DDL for Table TT#PB_ACCOUNT
--------------------------------------------------------

  CREATE GLOBAL TEMPORARY TABLE "FCR"."TT#PB_ACCOUNT" 
   (	"C#ID" NUMBER(*,0), 
	"C#NUM" VARCHAR2(20 BYTE), 
	"C#SN" NUMBER(*,0), 
	"C#ADDR_TEXT" VARCHAR2(1000 BYTE), 
	"C#TOP_ADDR_TEXT" VARCHAR2(100 BYTE), 
	"C#POST_CODE" VARCHAR2(6 BYTE), 
	"C#TOP_POST_CODE" VARCHAR2(6 BYTE), 
	"C#TOP_POST_NAME" VARCHAR2(50 BYTE)
   ) ON COMMIT DELETE ROWS ;
