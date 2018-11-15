--------------------------------------------------------
--  DDL for Table TT#PB_DATA_JP
--------------------------------------------------------

  CREATE GLOBAL TEMPORARY TABLE "FCR"."TT#PB_DATA_JP" 
   (	"C#ACCOUNT_ID" NUMBER(*,0), 
	"C#MN" NUMBER(4,0), 
	"C#TAR_VAL" NUMBER, 
	"C#C_SUM" NUMBER(38,2), 
	"C#M_SUM" NUMBER(38,2), 
	"C#P_SUM" NUMBER(38,2), 
	"C#FC_SUM" NUMBER(38,2), 
	"C#FP_SUM" NUMBER(38,2), 
	"C#NUM" VARCHAR2(20 BYTE)
   ) ON COMMIT DELETE ROWS ;
