--------------------------------------------------------
--  DDL for View V#GIS_CHARGE_FOR_GIS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#GIS_CHARGE_FOR_GIS" ("PERIOD", "MN", "ACCOUNT_ID", "ACCOUNT_NUM", "GKU_ID", "CHARGE_SUM_MN", "PAY_SUM_MN", "DOLG", "AVANS", "BIC_NUM", "BANK_ACC_NUM", "TARIF") AS 
  with
            accs as (
                select
                    C#ID ACCOUNT_ID,
                    GKU_ID,
                    ACCOUNT_NUM
                from
                    T#GIS_ACCLIST_FROM_GIS G
                    join V#ACCOUNT A on (A.C#NUM = G.ACCOUNT_NUM)
            )
            ,bank as (
                SELECT distinct
                    A.C#ID ACCOUNT_ID,
                    C#BIC_NUM BIC_NUM,
                    BA.C#NUM BANK_ACC_NUM
                FROM
                    V#ACCOUNT A
                    JOIN V#ROOMS R on (A.C#ROOMS_ID = R.C#ROOMS_ID)
                    JOIN V#BANKING VB on (VB.C#HOUSE_ID = R.C#HOUSE_ID)
                    JOIN T#B_ACCOUNT BA on (VB.C#B_ACCOUNT_ID = BA.C#ID)
                    JOIN T#BANK B on (B.C#ID = BA.C#BANK_ID)
            )
            ,alls as (
                SELECT
                    T.PERIOD,
                    T.MN,
                    A.ACCOUNT_ID,
                    ACCOUNT_NUM,
                    GKU_ID,
                    CHARGE_SUM_MN,
                    PAY_SUM_MN,
                    DOLG_SUM_TOTAL-DOLG_SUM_MN DOLG_SUM,
                    BIC_NUM,
                    BANK_ACC_NUM,
                    P#UTILS.GET#TARIF(A.ACCOUNT_ID,P#MN_UTILS.GET#DATE(MN)) TARIF
                from
                    accs A
                    join T#TOTAL_ACCOUNT T on (A.ACCOUNT_ID = T.ACCOUNT_ID)
                    left join bank B on (A.ACCOUNT_ID = B.ACCOUNT_ID)
            )
        select
            PERIOD,
            MN, 
            ACCOUNT_ID,
            ACCOUNT_NUM,
            GKU_ID,
            CHARGE_SUM_MN,
            PAY_SUM_MN,
            CASE WHEN DOLG_SUM > 0 THEN DOLG_SUM ELSE 0 END DOLG,
            CASE WHEN DOLG_SUM < 0 THEN ABS(DOLG_SUM) ELSE 0 END AVANS,
            BIC_NUM,
            BANK_ACC_NUM,
            TARIF
        from
            alls
;
