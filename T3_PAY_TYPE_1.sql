--------------------------------------------------------
--  DDL for Table T3_PAY_TYPE
--------------------------------------------------------

  CREATE TABLE "FCR"."T3_PAY_TYPE" 
   (	"C#ID" NUMBER(10,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE , 
	"C#NAME" VARCHAR2(150 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;

   COMMENT ON COLUMN "FCR"."T3_PAY_TYPE"."C#NAME" IS '������������';
   COMMENT ON TABLE "FCR"."T3_PAY_TYPE"  IS '���� ����� ����� �� ����������';
