--------------------------------------------------------
--  DDL for View V#TTER_NEW_ACCOUNTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#TTER_NEW_ACCOUNTS" ("ACCOUNT_NUM_LONG", "ACCOUNT_NUM", "ADDR", "NAME1", "NAME2", "NAME3", "AREA", "PER_BEG", "PER_END", "ADR_COUNT", "AREA_COUNT", "NAME_COUNT") AS 
  with 
    uniq_acc as (
        select
          LS ACCOUNT_NUM
          ,MIN(PERIOD) PER_BEG
          ,MAX(PERIOD) PER_END
          ,count(distinct ADR2) ADR_COUNT
          ,count(distinct AREA) AREA_COUNT
          ,count(distinct UPPER(NAME1||NAME2||NAME3)) NAME_COUNT
        from
          t#tter_nach
        group BY
          LS          
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
            n.ACCOUNT_NUM ACCOUNT_NUM_LONG
            ,t.OUTERLS ACCOUNT_NUM
            ,t.ADR1 ADDR
            ,t.NAME1 
            ,t.NAME2
            ,t.NAME3
            ,t.AREA
            ,PER_BEG
            ,PER_END
            ,ADR_COUNT
            ,AREA_COUNT
            ,NAME_COUNT
        from 
            t#tter_nach t
            join new_out_num_list n on (t.ls = n.ACCOUNT_NUM and t.PERIOD = n.PER_END)
    )
select
    "ACCOUNT_NUM_LONG","ACCOUNT_NUM","ADDR","NAME1","NAME2","NAME3","AREA","PER_BEG","PER_END","ADR_COUNT","AREA_COUNT","NAME_COUNT"
from
   last_items
;
