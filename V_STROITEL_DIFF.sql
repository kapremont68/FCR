--------------------------------------------------------
--  DDL for View V_STROITEL_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_STROITEL_DIFF" ("ACCOUNT_ID", "NAS_PUNKT", "UL", "DOM", "DOP", "KV", "LS", "PAY_ERC", "PAY_FCR", "PAY_DIFF", "SALDO_ERC", "SALDO_FCR", "SALDO_DIFF", "COMMENT_TEXT") AS 
  with
    tmp as (
        SELECT
            *
        FROM
            T#TEMP_STROITEL_2017_11
    )
    ,acc as (
        SELECT DISTINCT
            C#ACCOUNT_ID,
            C#OUT_NUM
        from
            V#ACC_LAST
        where
            C#OUT_NUM in (select ls from tmp)
    )
    ,pays as (
        SELECT
            acc.*,
            P#WEB.GET#CHARGE_FOR_ACC_PERIOD(acc.C#ACCOUNT_ID,TO_DATE('01.06.2014','dd.mm.yyyy'),TO_DATE('31.10.2017','dd.mm.yyyy')) charge_sum,
            P#WEB.GET#PAY_FOR_ACC_PERIOD(acc.C#ACCOUNT_ID,TO_DATE('01.06.2014','dd.mm.yyyy'),TO_DATE('31.10.2017','dd.mm.yyyy')) pay_sum        
        from
            acc
    )
select 
    pays.C#ACCOUNT_ID ACCOUNT_ID,
    tmp.NAS_PUNKT,
    tmp.UL,
    tmp.DOM,
    tmp.DOP,
    tmp.KV,
    tmp.LS,
    tmp.oplata PAY_ERC,
    NVL(pays.pay_sum,0) PAY_FCR,
    NVL(pays.pay_sum,0)-tmp.oplata PAY_DIFF,
    tmp.SALDO SALDO_ERC,
    NVL(pays.charge_sum,0)-NVL(pays.pay_sum,0) SALDO_FCR,
    NVL(pays.charge_sum,0)-NVL(pays.pay_sum,0)-tmp.SALDO SALDO_DIFF,
    CASE WHEN pays.C#ACCOUNT_ID is null then 'счета нет или закрыт' END COMMENT_TEXT
from
    tmp
    left join pays on (tmp.LS = pays.C#OUT_NUM)
;
