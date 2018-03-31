CREATE OR REPLACE PACKAGE P#WWW AS 

    function get#acc_id_by_any_acc_num(p_ACC_NUM VARCHAR2) RETURN NUMBER;

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

END P#WWW;
/
