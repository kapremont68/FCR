--------------------------------------------------------
--  DDL for Table T#OP_131216
--------------------------------------------------------

  CREATE TABLE "FCR"."T#OP_131216" 
   (	"C#ID" NUMBER(*,0), 
	"C#OPS_ID" NUMBER(*,0), 
	"C#ACCOUNT_ID" NUMBER(*,0), 
	"C#WORK_ID" NUMBER(*,0), 
	"C#DOER_ID" NUMBER(*,0), 
	"C#DATE" DATE, 
	"C#REAL_DATE" DATE, 
	"C#A_MN" NUMBER(4,0), 
	"C#B_MN" NUMBER(4,0), 
	"C#TYPE_TAG" VARCHAR2(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 8192 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#OP_131216"."C#TYPE_TAG" IS 'Тип {"MC":изменение начисления;"M":изменение;"MP":изменение платежа;"P":платеж;"FC":начисление пени;"FP":платеж пени.}';
