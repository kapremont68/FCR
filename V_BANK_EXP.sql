--------------------------------------------------------
--  DDL for View V_BANK_EXP
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_BANK_EXP" ("B_ACCOUNT_ID", "ACC_TYPE", "MN", "PERIOD", "HOUSE_ID", "HOUSE_COUNT", "PAY_SUM_TOTAL", "BARTER_SUM_TOTAL", "SPEC_TRANSFER", "KOTEL_TRANSFER", "MIN_ROW_TIME") AS 
  SELECT
        B.B_ACCOUNT_ID,
        B.ACC_TYPE,
        H.MN,
        H.PERIOD,
        CASE WHEN B.ACC_TYPE = 1
            THEN 0
        ELSE MAX(H.HOUSE_ID) END   HOUSE_ID,
        count(DISTINCT B.HOUSE_ID) HOUSE_COUNT,
        NVL(SUM(PAY_SUM_TOTAL),0)         PAY_SUM_TOTAL,
        NVL(SUM(BARTER_SUM_TOTAL),0)      BARTER_SUM_TOTAL,
        NVL(P#BANKEXP.GET#SPEC_TRANSFER(B.B_ACCOUNT_ID,P#MN_UTILS.GET#DATE(H.MN+1)-1),0)     SPEC_TRANSFER,
        CASE WHEN B.ACC_TYPE = 1
            THEN NVL(P#BANKEXP.GET#KOTEL_TRANSFER(P#MN_UTILS.GET#DATE(H.MN+1)-1),0)
        ELSE 0 END                 KOTEL_TRANSFER,
        MIN(ROW_TIME) MIN_ROW_TIME
    FROM
        V4_BANK_VD B
        JOIN T#TOTAL_HOUSE H ON (B.HOUSE_ID = H.HOUSE_ID)
    WHERE
        ACC_TYPE IN (1, 2)
        AND VALID_TAG = 'Y'
    GROUP BY
        B.B_ACCOUNT_ID,
        B.ACC_TYPE,
        H.MN,
        H.PERIOD
;
