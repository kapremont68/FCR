--------------------------------------------------------
--  DDL for Package P4#UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P4#UTILS" AS 

-- собрано (оплачено) всего по дому
  FUNCTION GET#HOUSE_PAY_SUM_TOTAL(a_HOUSE_ID NUMBER) RETURN NUMBER;

-- потрачено на работы средств собственников всего по дому
  FUNCTION GET#HOUSE_JOB_SUM_TOTAL(a_HOUSE_ID NUMBER) RETURN NUMBER;

-- переведено укашкам всего по дому  
  FUNCTION GET#HOUSE_TRANSFER_SUM_TOTAL(a_HOUSE_ID NUMBER) RETURN NUMBER;

END P4#UTILS;

/
