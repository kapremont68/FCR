--------------------------------------------------------
--  DDL for View V_RAW_MINUS_MASSPAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_RAW_MINUS_MASSPAY" ("ID", "PLATELSHIKINN", "PERSON_ID", "SUMMA", "DATA", "NPD", "RKC", "PLATELSHIK") AS 
  SELECT
    ID,
    PLATELSHIKINN,
    P.C#PERSON_ID PERSON_ID,
    R.SUMMA SUMMA,
    R.DATA DATA,
    R.NOMER NPD,
    '90' RKC,
    R.PLATELSHIK1 PLATELSHIK
from
    T#RAW_1C_V101 R
    join T#PERSON_J P on (R.PLATELSHIKINN = P.C#INN_NUM)
where
    id NOT IN (
        SELECT
            r.id
        FROM
            t#RAW_1C_V101 R
            join T#PERSON_J P on (R.PLATELSHIKINN = P.C#INN_NUM)
            JOIN T#MASS_PAY M ON (
                P.C#PERSON_ID = M.C#PERSON_ID
                and R.SUMMA = M.C#SUM
                and R.DATA = M.C#DATE
                and R.NOMER = M.C#NPD
                and '90' = M.C#COD_RKC
                and R.PLATELSHIK1 = M.C#COMMENT
            )
    )
;
