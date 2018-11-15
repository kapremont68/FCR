--------------------------------------------------------
--  DDL for View V#ERC_NEW_ACCOUNTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#ERC_NEW_ACCOUNTS" ("CITY", "UL_NAME", "DOM", "DOP_NAME", "KV", "PL_OB", "PER_BEG", "PER_END", "ADDR", "NEW_ACCOUNT_NUM") AS 
  with
    uniq_acc as (
        select
          MIN(PER) PER_BEG,
          MAX(PER) PER_END,
          LSO ACCOUNT_NUM,
          CITY,
          UL_NAME,
          DOM,
          DOP_NAME,
          KV,
          CITY||','||UL_NAME||','||DOM||','||DOP_NAME||','||KV ADDR,
          PL_OB
        from
          t#erc_nach
        group BY
          CITY||','||UL_NAME||','||DOM||','||DOP_NAME||','||KV,
          CITY,
          UL_NAME,
          DOM,
          DOP_NAME,
          KV,
          PL_OB,
          LSO
    ),
    old_out_num_list as (
        select  uniq_acc.* from uniq_acc join T#ACCOUNT_OP on (ACCOUNT_NUM = c#out_num)
    ),
    new_out_num_list as (
        select * from uniq_acc where ACCOUNT_NUM not in (select ACCOUNT_NUM from old_out_num_list)
    ),
    all_out_num_list as (
--         select n.*, o.ACCOUNT_NUM old_account_num
        select n.*
        from
            new_out_num_list n
--             left join old_out_num_list o
--            on (n.ADDR = o.ADDR and o.PER_END < n.PER_BEG)
--             on (n.ADDR = o.ADDR and n.PL_OB = o.PL_OB)
--         where
--           o.PER_BEG = (select MAX(PER_BEG) from old_out_num_list o2 where n.ADDR = o2.ADDR and n.PL_OB = o.PL_OB)
--           or o.ACCOUNT_NUM is null
    )
select distinct
    CITY,
    UL_NAME,
    DOM,
    DOP_NAME,
    KV,
    PL_OB,
    PER_BEG,
    PER_END,
    ADDR,
    ACCOUNT_NUM NEW_ACCOUNT_NUM
--     OLD_ACCOUNT_NUM
from
    all_out_num_list
;
