--------------------------------------------------------
--  Constraints for Table T#HOUSE_INFO
--------------------------------------------------------

  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#ET" CHECK (C#ELEVATOR_TAG in ('N','Y')) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#BT" CHECK (C#BASEMENT_TAG in ('N','Y')) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#CY" CHECK (C#CREATE_YEAR >= 1100 AND C#CREATE_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#RLY" CHECK (C#ROOF_L_YEAR >= 1100 AND C#ROOF_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#RHY" CHECK (C#ROOF_H_YEAR >= 1100 AND C#ROOF_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#FLY" CHECK (C#FACE_L_YEAR >= 1100 AND C#FACE_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#FHY" CHECK (C#FACE_H_YEAR >= 1100 AND C#FACE_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#ILY" CHECK (C#ISYS_L_YEAR >= 1100 AND C#ISYS_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#IHY" CHECK (C#ISYS_H_YEAR >= 1100 AND C#ISYS_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#CMLY" CHECK (C#CMET_L_YEAR >= 1100 AND C#CMET_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#CMHY" CHECK (C#CMET_H_YEAR >= 1100 AND C#CMET_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#ELY" CHECK (C#ELEV_L_YEAR >= 1100 AND C#ELEV_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#EHY" CHECK (C#ELEV_H_YEAR >= 1100 AND C#ELEV_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#BLY" CHECK (C#BASE_L_YEAR >= 1100 AND C#BASE_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#BHY" CHECK (C#BASE_H_YEAR >= 1100 AND C#BASE_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#FULY" CHECK (C#FUND_L_YEAR >= 1100 AND C#FUND_L_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#FUHY" CHECK (C#FUND_H_YEAR >= 1100 AND C#FUND_H_YEAR <= 2100) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#RY" CHECK (C#ROOF_L_YEAR <= C#ROOF_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#FY" CHECK (C#FACE_L_YEAR <= C#FACE_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#IY" CHECK (C#ISYS_L_YEAR <= C#ISYS_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#CMY" CHECK (C#CMET_L_YEAR <= C#CMET_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#EY" CHECK (C#ELEV_L_YEAR <= C#ELEV_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#T#HOUSE_INFO#BY" CHECK (C#BASE_L_YEAR <= C#BASE_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CC#HOUSE_INFO#FUY" CHECK (C#FUND_L_YEAR <= C#FUND_H_YEAR) ENABLE;
  ALTER TABLE "FCR"."T#HOUSE_INFO" ADD CONSTRAINT "CP#HOUSE_INFO" PRIMARY KEY ("C#HOUSE_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1"  ENABLE;
