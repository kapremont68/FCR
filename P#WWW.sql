CREATE OR REPLACE PACKAGE P#WWW AS 

    function get#acc_id_by_any_acc_num(p_ACC_NUM VARCHAR2) RETURN NUMBER;
    
    function get#acc_balance(p_ACC_NUM VARCHAR2) RETURN sys_refcursor;

END P#WWW;
/


CREATE OR REPLACE PACKAGE BODY P#WWW AS

    function get#acc_id_by_any_acc_num(p_ACC_NUM VARCHAR2) RETURN NUMBER AS
        ret_ACC_ID NUMBER;
    BEGIN
        select 
            c#account_id
        into 
            ret_ACC_ID
        from
            T#ACCOUNT_OP
        WHERE
            C#OUT_NUM = p_ACC_NUM
        ;    
        RETURN ret_ACC_ID;
        EXCEPTION
            when NO_DATA_FOUND then 
            begin
                select 
                    c#id
                into 
                    ret_ACC_ID
                from
                    T#ACCOUNT
                WHERE
                    C#NUM = p_ACC_NUM;
                RETURN ret_ACC_ID;
            end;
        RETURN ret_ACC_ID;
    END get#acc_id_by_any_acc_num;

    function get#acc_balance(p_ACC_NUM VARCHAR2) RETURN sys_refcursor AS
        res sys_refcursor;
        a_ACC_ID number;
    BEGIN
        select P#WWW.GET#ACC_ID_BY_ANY_ACC_NUM(p_ACC_NUM) into a_ACC_ID from dual;
        OPEN res FOR
            with
                ch as (
                    select
                        ROWIDTOCHAR(ROWID) N,
                        1 NN,
                        C#ACCOUNT_ID ACCOUNT_ID,
                        C#A_MN MN,
                        P#UTILS.GET#TARIF(C#ACCOUNT_ID,P#MN_UTILS.GET#DATE(C#A_MN)) TARIF,
                        C#VOL VOL,
                        C#SUM CHARGE_SUM
                    from
                        T#CHARGE
                )
                ,pay as (
                    SELECT
                        ROWIDTOCHAR(P.ROWID) N,
                        2 NN,
                        coalesce(C#ACC_ID,C#ACC_ID_CLOSE,C#ACC_ID_TTER) ACCOUNT_ID,
                        P#MN_UTILS.GET#MN(C#REAL_DATE) MN,
                        C#REAL_DATE REAL_DATE,
                        C#PERIOD PAY_PERIOD,
                        C#COD_RKC RKC_CODE,
                        R.C#NAME RKC_NAME,
                        C#ACCOUNT ACCOUNT_NUM,
                        C#SUMMA PAY_SUM,
                        C#COMMENT PAY_COMMENT,
                        C#PLAT PAYER
                    from
                        T#PAY_SOURCE P
                        left join T#OUT_PROC R on (TO_NUMBER(P.C#COD_RKC) = TO_NUMBER(R.C#CODE))
                    where
                        C#OPS_ID is not null
                )
                ,alls as (
                    select
                        N,
                        NN,
                        ACCOUNT_ID,
                        MN,
                        TO_CHAR(P#MN_UTILS.GET#DATE(MN),'mm.yyyy') MN_PER,
                        TARIF,
                        VOL,
                        null REAL_DATE,
                        null REAL_DATE_STR,
                        null PAY_PERIOD,
                        null RKC_NAME,
                        null ACCOUNT_NUM,
                        null PAY_COMMENT,
                        null PAYER,
                        CHARGE_SUM,
                        null PAY_SUM
                    from
                        ch
                    union all
                    select
                        N,
                        NN,
                        ACCOUNT_ID,
                        MN,
                        null MN_PER,
                        null TARIF,
                        null VOL,
                        REAL_DATE,
                        TO_CHAR(REAL_DATE,'dd.mm.yyyy') REAL_DATE_STR,
                        PAY_PERIOD,
                        RKC_NAME,
                        ACCOUNT_NUM,
                        PAY_COMMENT,
                        PAYER,
                        null CHARGE_SUM,
                        PAY_SUM
                    from
                        pay
            
                )
            select
                alls.*,
                sum(CHARGE_SUM)  over (order by MN, NN, N) CHARGE_TOTAL,
                sum(PAY_SUM)  over (order by MN, NN, N) PAY_TOTAL,
                sum(NVL(PAY_SUM,0) - NVL(CHARGE_SUM,0)) over (order by MN, NN, N) BALANCE
            from
                alls
            where
                ACCOUNT_ID = a_ACC_ID
            order by
                MN, NN, REAL_DATE
            ;
        RETURN res;
    END get#acc_balance;

END P#WWW;
/
