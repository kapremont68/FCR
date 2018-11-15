--------------------------------------------------------
--  DDL for View V#TOSK_NEW_ACCOUNTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#TOSK_NEW_ACCOUNTS" ("ADDR", "KV", "FIO", "ACCOUNT_NUM", "AREA", "DATE_BEG") AS 
  with 
    uniq_acc as (
        select
          ACCOUNT_NUM
        from
          t#tosk_nach
        group BY
          ACCOUNT_NUM          
    )    
    ,old_out_num_list as (
        select  uniq_acc.* from uniq_acc join T#ACCOUNT_OP on (ACCOUNT_NUM = c#out_num)
    )
    ,new_out_num_list as (
        select 
            * 
        from 
            uniq_acc 
            join
        where ACCOUNT_NUM not in (select ACCOUNT_NUM from old_out_num_list)
    )
    ,last_items as (
        select 
            t.*
            ,'01.08.2017' DATE_BEG
        from 
            t#tosk_nach t
            join new_out_num_list n on (t.ACCOUNT_NUM = n.ACCOUNT_NUM)
    )
select
    "ADDR","KV","FIO","ACCOUNT_NUM","AREA","DATE_BEG"
from
   last_items
;
