CREATE OR REPLACE PACKAGE p#export AS
    
    PROCEDURE acquiring_sber;

END p#export;
/


CREATE OR REPLACE PACKAGE BODY p#export AS
--------------------------------
    PROCEDURE acquiring_sber AS
        p_query    VARCHAR2(2000);
        v_return   NUMBER;
    BEGIN
        v_return := dump_csv('
            select
                ACC_NUM,
                null EMPTY,
                ADDR,
                PER,
                PER_SUM
            from
                v_acquiring
            where
                length(ACC_NUM) BETWEEN 5 and 15
        '
        ,';','DUMP_CSV_DIR','acquiring_sber.csv');
    END acquiring_sber;
--------------------------------

END p#export;
/
