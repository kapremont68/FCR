--------------------------------------------------------
--  DDL for Package P3UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P3UTILS" AS 

-- строка с перечнем всех работ по дому 
  FUNCTION get_jobs_txt(p_HOUSE_ID NUMBER DEFAULT NULL, p_DATE_BEG DATE, p_DATE_END DATE) RETURN NVARCHAR2;

-- сумма всех платежей по работе
  FUNCTION get_job_summa(p_JOB_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- сумма всех платежей по дому
  FUNCTION get_house_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- плановая сумма всех работ по дому
  FUNCTION get_house_plan_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- начислено, оплачено, потрачено, долг, остаток по дому по месяцам
  FUNCTION LST#HOUSE_BALANCE(p_HOUSE_ID NUMBER) RETURN sys_refcursor;

-- платежи в разрезе по домам за работы, проведенные (или по договорам, заключенным) в заданном диапазоне дат
  FUNCTION LST#HOUSES_PAYS(p_DATE_BEG DATE, p_DATE_END DATE) RETURN sys_refcursor;
  
-- разносит имортированные из 1С платежи
  PROCEDURE DO#IMPORT;

END P3UTILS;

/
