--------------------------------------------------------
--  DDL for View V4_TRANSFER
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V4_TRANSFER" ("TRANSFER_ID", "HOUSE_ID", "INVOICE", "TRANSFER_DATE", "TRANSFER_SUM", "ACCOUNT_FROM", "ACCOUNT_TO", "HOST_NAME", "NOTE") AS 
  with
    acc as (
        SELECT
            C#ACC_NUM ACCOUNT_NUM,
--             C#ACC_HOST_ID HOST_ID,
            C#NAME HOST_NAME
        from
            T4_SPEC_ACCOUNTS A
            left JOIN T4_HOSTS H on (A.C#ACC_HOST_ID = H.C#ID)
    )
    ,pays as (
        select
            T.C#ID TRANSFER_ID,
            C#HOUSE_ID HOUSE_ID,
            C#INVOICE INVOICE,
            C#DATE TRANSFER_DATE,
            C#SUM PAY_SUM,
            C#ACC_FROM ACCOUNT_FROM,
            C#ACC_TO ACCOUNT_TO,
            HOST_NAME,
            C#NOTE NOTE
        from
            T4_TRANSFER T
            LEFT JOIN acc on (T.C#ACC_TO = acc.ACCOUNT_NUM)
    )
select
    "TRANSFER_ID","HOUSE_ID","INVOICE","TRANSFER_DATE","PAY_SUM" "TRANSFER_SUM","ACCOUNT_FROM","ACCOUNT_TO","HOST_NAME","NOTE"
from
    pays
;
