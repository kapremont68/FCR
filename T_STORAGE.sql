--------------------------------------------------------
--  DDL for Table T#STORAGE
--------------------------------------------------------

  CREATE TABLE "FCR"."T#STORAGE" 
   (	"C#ACCOUNT_ID" NUMBER(*,0), 
	"C#WORK_ID" NUMBER(*,0), 
	"C#DOER_ID" NUMBER(*,0), 
	"C#MN" NUMBER(4,0), 
	"C#C_VOL" NUMBER, 
	"C#C2_VOL" NUMBER, 
	"C#C_SUM" NUMBER(38,2), 
	"C#C2_SUM" NUMBER(38,2), 
	"C#MC_SUM" NUMBER(38,2), 
	"C#M_SUM" NUMBER(38,2), 
	"C#MP_SUM" NUMBER(38,2), 
	"C#P_SUM" NUMBER(38,2), 
	"C#FC_SUM" NUMBER(38,2), 
	"C#FP_SUM" NUMBER(38,2), 
	"C#ROW_TIME" TIMESTAMP (6) DEFAULT sysdate
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#C_VOL" IS 'Объём начислений.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#C2_VOL" IS 'Объём начислений не за тп или не в тп.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#C_SUM" IS 'Сумма начислений.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#C2_SUM" IS 'Сумма начислений не за тп или не в тп.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#MC_SUM" IS 'Сумма изменений начислений.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#M_SUM" IS 'Сумма изменений.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#MP_SUM" IS 'Сумма изменений платежей.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#P_SUM" IS 'Сумма платежей.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#FC_SUM" IS 'Сумма начислений пени.';
   COMMENT ON COLUMN "FCR"."T#STORAGE"."C#FP_SUM" IS 'Сумма платежей пени.';
