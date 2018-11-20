--------------------------------------------------------
--  DDL for View V3_PAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V3_PAY" ("PAY_ID", "PAY_TYPE_ID", "PAY_TYPE_NAME", "PAY_SUM", "PAY_DATE", "PAY_INVOICE", "PAY_SOURCE", "PAY_NOTE", "HOUSE_ID", "HOUSE_ADDR", "JOB_ID", "JOB_TYPE_ID", "JOB_TYPE_NAME", "REG_JOB_TYPE_ID", "REG_JOB_TYPE_NAME", "JOB_ELEM_CODE", "JOB_DATE_BEGIN", "JOB_DATE_END", "JOB_NOTE", "JOB_STATUS", "PLAN_SUM", "HOUSE_PLAN_SUM", "JOB_SUM", "HOUSE_SUM", "CONTRACT_ID", "CONTRACT_DATE", "CONTRACT_NUM", "CONTRACT_TYPE_NAME", "CONTRACT_DESCRIPTION", "CONTRACTOR_ID", "CONTRACTOR_NAME", "CONTRACTOR_INN", "CONTRACTOR_KPP", "CONTRACTOR_CONTACT_INFO", "CONTRACTOR_1C_ID", "CONTRACTOR_BANK_BIC", "CONTRACTOR_BANK_KOR", "CONTRACTOR_BANK_NAME", "CONTRACTOR_BANK_ACCOUNT") AS 
  select
  P.C#id PAY_ID,
  P.C#PAY_TYPE_ID PAY_TYPE_ID,
  PT.C#NAME PAY_TYPE_NAME,
  P.C#SUM PAY_SUM,
  P.C#PAY_DATE PAY_DATE,
  P.C#INVOICE PAY_INVOICE,
  P.C#SOURCE PAY_SOURCE,
  P.C#NOTE PAY_NOTE,
  J.HOUSE_ID,
  J.HOUSE_ADDR,
  J.JOB_ID,
  J.JOB_TYPE_ID,
  J.JOB_TYPE_NAME,
  J.REG_JOB_TYPE_ID,
  J.REG_JOB_TYPE_NAME,
  J.JOB_ELEM_CODE,
  J.JOB_DATE_BEGIN,
  J.JOB_DATE_END,
  J.JOB_NOTE,
  J.JOB_STATUS,
  J.PLAN_SUM,
  J.HOUSE_PLAN_SUM,
  J.JOB_SUM,
  J.HOUSE_SUM,
  J.CONTRACT_ID,
  J.CONTRACT_DATE,
  J.CONTRACT_NUM,
  J.CONTRACT_TYPE_NAME,
  J.CONTRACT_DESCRIPTION,
  J.CONTRACTOR_ID,
  J.CONTRACTOR_NAME,
  J.CONTRACTOR_INN,
  J.CONTRACTOR_KPP,
  J.CONTRACTOR_CONTACT_INFO,
  J.CONTRACTOR_1C_ID,
  J.CONTRACTOR_BANK_BIC,
  J.CONTRACTOR_BANK_KOR,
  J.CONTRACTOR_BANK_NAME,
  J.CONTRACTOR_BANK_ACCOUNT
FROM
  T3_PAY P
  left join V3_JOBS J on (J.JOB_ID = P.C#JOB_ID)
  left join T3_PAY_TYPE PT on (PT.C#ID = P.C#PAY_TYPE_ID)
;