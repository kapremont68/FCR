--------------------------------------------------------
--  DDL for Table HOSTS_VD
--------------------------------------------------------

  CREATE TABLE "FCR"."HOSTS_VD" 
   (	"C#ID" VARCHAR2(20 BYTE), 
	"C#PHONE" VARCHAR2(20 BYTE), 
	"C#MAIL" VARCHAR2(30 BYTE), 
	"C#BOSS_DOLGN_DP" VARCHAR2(40 BYTE), 
	"C#INDEX" VARCHAR2(6 BYTE), 
	"C#ADDRESS" VARCHAR2(200 BYTE), 
	"C#NOTE" VARCHAR2(200 BYTE), 
	"C#BOSS_FIO" VARCHAR2(80 BYTE), 
	"C#BOSS_FIO_DP" VARCHAR2(80 BYTE), 
	"C#BOSS_DOLGN" VARCHAR2(60 BYTE), 
	"C#BOSS_SHORT_NAME" VARCHAR2(60 BYTE), 
	"C#INN" VARCHAR2(12 BYTE), 
	"C#KPP" VARCHAR2(9 BYTE), 
	"C#OBR" VARCHAR2(9 BYTE), 
	"C#VN" NUMBER(*,0), 
	"C#VALID_TAG" VARCHAR2(1 BYTE), 
	"C#SIGN_DATE" DATE, 
	"C#SIGN_S_ID" NUMBER(*,0), 
	"C#BANK_ACC" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 16384 NEXT 8192 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."HOSTS_VD"."C#BANK_ACC" IS '���������� ����';
  GRANT FLASHBACK ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT DEBUG ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT QUERY REWRITE ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT ON COMMIT REFRESH ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT REFERENCES ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT UPDATE ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT SELECT ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT INSERT ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT INDEX ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT DELETE ON "FCR"."HOSTS_VD" TO "KAN";
  GRANT ALTER ON "FCR"."HOSTS_VD" TO "KAN";
