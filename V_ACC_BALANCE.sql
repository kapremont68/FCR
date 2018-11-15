--------------------------------------------------------
--  DDL for View V_ACC_BALANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_ACC_BALANCE" ("N", "NN", "ACCOUNT_ID", "MN", "MN_PER", "VOL", "REAL_DATE", "REAL_DATE_STR", "PAY_PERIOD", "RKC_NAME", "ACCOUNT_NUM", "PAY_COMMENT", "PAYER", "CHARGE_SUM", "PAY_SUM", "CHARGE_TOTAL", "PAY_TOTAL", "BALANCE") AS 
  WITH
        ch AS (
        SELECT
            ROWIDTOCHAR(ROWID)                                           N,
            1                                                            NN,
            C#ACCOUNT_ID                                                 ACCOUNT_ID,
            C#A_MN                                                       MN,
--             P#UTILS.GET#TARIF(C#ACCOUNT_ID, P#MN_UTILS.GET#DATE(C#A_MN)) TARIF,
            C#VOL                                                        VOL,
            C#SUM                                                        CHARGE_SUM
        FROM
            T#CHARGE
    )
    , pay AS (
    SELECT
        ROWIDTOCHAR(P.ROWID)                              N,
        2                                                 NN,
        coalesce(C#ACC_ID, C#ACC_ID_CLOSE, C#ACC_ID_TTER) ACCOUNT_ID,
        P#MN_UTILS.GET#MN(C#REAL_DATE)                    MN,
        C#REAL_DATE                                       REAL_DATE,
        C#PERIOD                                          PAY_PERIOD,
        C#COD_RKC                                         RKC_CODE,
        R.C#NAME                                          RKC_NAME,
        C#ACCOUNT                                         ACCOUNT_NUM,
        C#SUMMA                                           PAY_SUM,
        C#COMMENT                                         PAY_COMMENT,
        C#PLAT                                            PAYER
    FROM
        T#PAY_SOURCE P
        LEFT JOIN T#OUT_PROC R ON (TO_NUMBER(P.C#COD_RKC) = TO_NUMBER(R.C#CODE))
    WHERE
        C#OPS_ID IS NOT NULL
)
    , alls AS (
    SELECT
        N,
        NN,
        ACCOUNT_ID,
        MN,
        TO_CHAR(P#MN_UTILS.GET#DATE(MN), 'mm.yyyy') MN_PER,
--         TARIF,
        VOL,
        NULL                                        REAL_DATE,
        NULL                                        REAL_DATE_STR,
        NULL                                        PAY_PERIOD,
        NULL                                        RKC_NAME,
        NULL                                        ACCOUNT_NUM,
        NULL                                        PAY_COMMENT,
        NULL                                        PAYER,
        CHARGE_SUM,
        NULL                                        PAY_SUM
    FROM
        ch
    UNION ALL
    SELECT
        N,
        NN,
        ACCOUNT_ID,
        MN,
        NULL                             MN_PER,
--         NULL                             TARIF,
        NULL                             VOL,
        REAL_DATE,
        TO_CHAR(REAL_DATE, 'dd.mm.yyyy') REAL_DATE_STR,
        PAY_PERIOD,
        RKC_NAME,
        ACCOUNT_NUM,
        PAY_COMMENT,
        PAYER,
        NULL                             CHARGE_SUM,
        PAY_SUM
    FROM
        pay

)
SELECT
    alls."N",alls."NN",alls."ACCOUNT_ID",alls."MN",alls."MN_PER",alls."VOL",alls."REAL_DATE",alls."REAL_DATE_STR",alls."PAY_PERIOD",alls."RKC_NAME",alls."ACCOUNT_NUM",alls."PAY_COMMENT",alls."PAYER",alls."CHARGE_SUM",alls."PAY_SUM",
    sum(CHARGE_SUM)
    OVER (
        ORDER BY MN, NN, N ) CHARGE_TOTAL,
    sum(PAY_SUM)
    OVER (
        ORDER BY MN, NN, N ) PAY_TOTAL,
    sum(NVL(PAY_SUM, 0) - NVL(CHARGE_SUM, 0))
    OVER (
        ORDER BY MN, NN, N ) BALANCE
FROM
    alls
-- WHERE
--     ACCOUNT_ID = 92022
ORDER BY
    MN, NN, REAL_DATE
;
