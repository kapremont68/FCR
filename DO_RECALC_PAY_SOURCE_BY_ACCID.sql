--------------------------------------------------------
--  DDL for Procedure DO#RECALC_PAY_SOURCE_BY_ACCID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_PAY_SOURCE_BY_ACCID" (P_ACC_ID IN NUMBER) AS
BEGIN

    EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD disable';
    EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD disable';

    delete from T#OP where C#ACCOUNT_ID = P_ACC_ID;

    EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD enable';
    EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD enable';

    update T#PAY_SOURCE
    set
        C#ACC_ID = null,
        C#ACC_ID_CLOSE = null,
        C#ACC_ID_TTER = null,
        C#OPS_ID = null
    where COALESCE(C#ACC_ID,C#ACC_ID_CLOSE,C#ACC_ID_TTER) = P_ACC_ID;

    COMMIT;

END DO#RECALC_PAY_SOURCE_BY_ACCID;

/
