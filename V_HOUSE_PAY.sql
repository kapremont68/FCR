--------------------------------------------------------
--  DDL for View V#HOUSE_PAY
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#HOUSE_PAY" ("HOUSE_ID", "ACC_NUM", "PAY_DATE", "PAY_SUM", "PAY_PERIOD", "PAY_AGENT") AS 
  SELECT
    HOUSE_ID,
    ACC_NUM,
    PAY_DATE,
    sum(PAY_SUM) PAY_SUM,
    '' PAY_PERIOD,
--     TO_CHAR(p#mn_utils.GET#DATE(MIN(PAY_PERIOD)), 'mm.yyyy') PAY_PERIOD,
--     TO_CHAR(p#mn_utils.GET#DATE(MAX(PAY_PERIOD)), 'mm.yyyy') PAY_PERIOD2,
    PAY_AGENT
from (
    SELECT
        L.C#HOUSE_ID                                       HOUSE_ID,
        L.C#OUT_NUM                                        ACC_NUM,
        OP.C#REAL_DATE                                     PAY_DATE,
        OP.C#SUM                                           PAY_SUM,
--         TO_CHAR(p#mn_utils.GET#DATE(op.C#A_MN), 'mm.yyyy') PAY_PERIOD,
        op.C#A_MN PAY_PERIOD,
        K.C#NAME                                           PAY_AGENT
    FROM
        v#OP OP
        JOIN v#ops ops ON (op.C#OPS_ID = ops.C#ID)
        JOIN fcr.t#ops_kind K ON (ops.C#KIND_ID = K.C#ID)
        JOIN V#ACC_LAST2 L ON (OP.C#ACCOUNT_ID = L.C#ACCOUNT_ID)
)
-- where
--     HOUSE_ID = 4206
--     and ACC_NUM = '7730750010'
group by
    HOUSE_ID,
    ACC_NUM,
    PAY_DATE,
--     PAY_PERIOD,
    PAY_AGENT
HAVING
    sum(PAY_SUM) <> 0
order by
    PAY_DATE desc
;
