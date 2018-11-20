--------------------------------------------------------
--  DDL for Table T#TOTAL_ACCOUNT_TMP
--------------------------------------------------------

  CREATE GLOBAL TEMPORARY TABLE "FCR"."T#TOTAL_ACCOUNT_TMP" 
   (	"HOUSE_ID" NUMBER(*,0), 
	"ROOMS_ID" NUMBER(*,0), 
	"FLAT_NUM" VARCHAR2(50 BYTE), 
	"ACCOUNT_ID" NUMBER(*,0), 
	"END_ACCOUNT_MN" NUMBER, 
	"MN" NUMBER(4,0), 
	"PERIOD" VARCHAR2(10 BYTE), 
	"CHARGE_SUM_MN" NUMBER, 
	"CHARGE_SUM_TOTAL" NUMBER, 
	"PAY_SUM_MN" NUMBER, 
	"PAY_SUM_TOTAL" NUMBER, 
	"PENI_SUM_MN" NUMBER, 
	"PENI_SUM_TOTAL" NUMBER, 
	"BARTER_SUM_MN" NUMBER, 
	"BARTER_SUM_TOTAL" NUMBER, 
	"DOLG_SUM_MN" NUMBER, 
	"DOLG_SUM_TOTAL" NUMBER, 
	"ROW_TIME" TIMESTAMP (6)
   ) ON COMMIT DELETE ROWS ;