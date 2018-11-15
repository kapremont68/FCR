--------------------------------------------------------
--  DDL for View V_LAST_PAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_LAST_PAY" ("ACC_ID", "ACC_NUM", "PAY_DATE", "PAY_SUM", "PAY_AGENT") AS 
  WITH
        pays AS (
        SELECT
--             c#id                                              PAY_ID,
            coalesce(C#ACC_ID, C#ACC_ID_CLOSE, C#ACC_ID_TTER) ACC_ID,
            C#ACCOUNT                                         ACC_NUM,
            C#REAL_DATE                                       PAY_DATE,
            C#SUMMA                                           PAY_SUM,
            C#COD_RKC                                         PAY_AGENT,
            ROW_NUMBER() OVER (PARTITION BY coalesce(C#ACC_ID, C#ACC_ID_CLOSE, C#ACC_ID_TTER) ORDER BY C#REAL_DATE desc)  num
        FROM
            T#PAY_SOURCE
        WHERE
            C#OPS_ID IS NOT NULL
    )
SELECT
    ACC_ID,
    ACC_NUM,
    PAY_DATE,
    PAY_SUM,
    nvl(D.C#NAME, P.PAY_AGENT) PAY_AGENT
FROM
    pays P
    left join t#ops_kind D on (P.PAY_AGENT = D.C#COD) 
where
    NUM = 1
;
