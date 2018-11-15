--------------------------------------------------------
--  DDL for View V#ZACHET2
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ZACHET2" ("ACC_ID") AS 
  SELECT
--     *
    coalesce(C#ACC_ID, C#ACC_ID_CLOSE, C#ACC_ID_TTER) ACC_ID
FROM
    T#PAY_SOURCE
WHERE
    C#COD_RKC = '88'
    AND C#SUMMA = 0
    AND C#FINE > 0
--     AND C#FINE <> 0.01
    and coalesce(C#ACC_ID, C#ACC_ID_CLOSE, C#ACC_ID_TTER) is not null
;
