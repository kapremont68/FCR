--------------------------------------------------------
--  DDL for Package P4#API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P4#API" 
is

-- insert
function transfer_ins (
    p_C#HOUSE_ID in T4_TRANSFER.C#HOUSE_ID%type
    ,p_C#SUM in T4_TRANSFER.C#SUM%type
    ,p_C#DATE in T4_TRANSFER.C#DATE%type
    ,p_C#ACC_FROM in T4_TRANSFER.C#ACC_FROM%type
    ,p_C#ACC_TO in T4_TRANSFER.C#ACC_TO%type
    ,p_C#INVOICE in T4_TRANSFER.C#INVOICE%type
    ,p_C#NOTE in T4_TRANSFER.C#NOTE%type default null 
) RETURN NUMBER;

-- delete
procedure transfer_del (
    p_C#ID in T4_TRANSFER.C#ID%type
);

-- изменение данных по протоколу 
procedure protocol_upd(
    p_HOUSE_ID T4_HOUSE_PROTS.C#HOUSE_ID%type,
    p_PROT_N in T#B_ACCOUNT.C#PROT_N%type,
    p_PROT_DATE in T#B_ACCOUNT.C#PROT_DATE%type
);

-- удалить протокол из истории
procedure protocol_del(
    p_PROT_ID T4_HOUSE_PROTS.C#ID%type
);


end P4#API;

/
