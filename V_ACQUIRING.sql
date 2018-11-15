--------------------------------------------------------
--  DDL for View V_ACQUIRING
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_ACQUIRING" ("ACC_NUM", "ADDR", "PER", "PER_SUM") AS 
  SELECT
    o.c#out_num acc_num,
    ha.addr
    || ', '
    || t.flat_num addr,
    substr(t.period,1,2)
    || substr(t.period,6,2) per,
    t.charge_sum_mn per_sum
FROM
    t#total_account t
    JOIN mv_houses_adreses ha ON ( t.house_id = ha.house_id )
    JOIN (
        SELECT
            c#account_id,
            c#out_num
        FROM
            t#account_op
        UNION ALL
        SELECT
            c#id,
            c#num
        FROM
            t#account
    ) o ON ( t.account_id = o.c#account_id )
WHERE
    mn = (
        SELECT
            MAX(mn)
        FROM
            t#total_account
        WHERE
            charge_sum_mn > 0
    )
;
