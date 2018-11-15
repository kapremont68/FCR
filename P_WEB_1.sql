--------------------------------------------------------
--  DDL for Package P#WEB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#WEB" AS 

-- возвращает сумму платежей (с нарастающим итогом) для заданного дома и даты(конца месяца)
 FUNCTION GET#SUM_FOR_HOUSE_DATE(a#house_id NUMBER, a#date DATE) RETURN NUMBER;

-- возвращает пени для заданного дома и периода
-- FUNCTION GET#PENI_FOR_HOUSE_PERIOD(a#house_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- возвращает пени для заданного счета и периода
-- FUNCTION GET#PENI_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- возвращает начисления для заданного счета за период
 FUNCTION GET#CHARGE_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- возвращает платежи для заданного счета за период
 FUNCTION GET#PAY_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- возвращает текущий долг
 FUNCTION GET#DOLG(a#acc_id NUMBER) RETURN NUMBER;
 
-- возвращает начисления для заданного счета с начала по закрытый (прошлый) месяц
 FUNCTION GET#CHARGE_FOR_DOLG(a#acc_id NUMBER) RETURN NUMBER;
 

END P#WEB;

/
