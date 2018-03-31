CREATE OR REPLACE PACKAGE P#RECALC AS 

-- форс-пересчет счета
    PROCEDURE FORCE_RECALC_ACC(p_ACC_ID NUMBER, p_RECALC_HOUSE VARCHAR2 DEFAULT 'Y');

-- форс-пересчет всех счетов дома + накопления самого дома
    PROCEDURE FORCE_RECALC_HOUSE(p_HOUSE_ID NUMBER);
    
    
    PROCEDURE RESET_PAY_SOURCE_FOR_ACC(p_ACC_ID NUMBER);
    

END P#RECALC;
/


CREATE OR REPLACE PACKAGE BODY P#RECALC AS

  PROCEDURE FORCE_RECALC_ACC(p_ACC_ID NUMBER, p_RECALC_HOUSE VARCHAR2 DEFAULT 'Y') AS
    a_HOUSE_ID NUMBER;
--    maxMN NUMBER;
  BEGIN
    DO#RECALC_ACCOUNT(null,to_date('01.06.2014','dd.mm.yyyy'),p_ACC_ID);

    P#TOTAL.UPDATE_TOTAL_ACCOUNT (p_ACC_ID) ;  
    
    if p_RECALC_HOUSE = 'Y' then
        select house_id into a_HOUSE_ID from V_HOUSE_ROOM_ACC where account_id = p_ACC_ID and rownum < 2;
        P#TOTAL.UPDATE_TOTAL_HOUSE(a_HOUSE_ID);    
    end if;


--    maxMN := P#UTILS.GET#OPEN_MN()+1;
--    
--    EXECUTE IMMEDIATE 'alter trigger TR#STORE#WARD disable';
--    EXECUTE IMMEDIATE 'alter trigger TR#STORAGE#WARD disable';
--    FOR lmn IN 163..maxMN LOOP
--        DO#CALC_STORE(p_ACC_ID,lmn);
--    END LOOP;
--    EXECUTE IMMEDIATE 'alter trigger TR#STORE#WARD enable';
--    EXECUTE IMMEDIATE 'alter trigger TR#STORAGE#WARD enable';

    commit;

  END FORCE_RECALC_ACC;

------------------------------------------------------------------------
  PROCEDURE FORCE_RECALC_HOUSE(p_HOUSE_ID NUMBER) AS
  BEGIN
    
    for accItem in (select ACCOUNT_ID from V_HOUSE_ROOM_ACC where HOUSE_ID = p_HOUSE_ID) loop
        FORCE_RECALC_ACC(accItem.ACCOUNT_ID, 'N');    
    end loop;
       
    P#TOTAL.UPDATE_TOTAL_HOUSE(p_HOUSE_ID) ;  

  END FORCE_RECALC_HOUSE;

------------------------------------------------------------------------

    PROCEDURE RESET_PAY_SOURCE_FOR_ACC(p_ACC_ID NUMBER) AS
    BEGIN
        update T#PAY_SOURCE set
            C#ACC_ID_CLOSE = null,
            C#ACC_ID = null,
            C#ACC_ID_TTER = null,
            C#OPS_ID = null
        where
            coalesce(C#ACC_ID,C#ACC_ID_TTER,C#ACC_ID_CLOSE) = p_ACC_ID
        ;
        
        EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD disable';
        EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD disable';
        delete from t#op where C#ACCOUNT_ID = p_ACC_ID;
        EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD enable';
        EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD enable';
        
        COMMIT;
        
    END RESET_PAY_SOURCE_FOR_ACC;

END P#RECALC;
/
