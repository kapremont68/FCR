CREATE OR REPLACE PACKAGE p#dbf AS
   
    PROCEDURE after_autoload;

END p#dbf;
/


CREATE OR REPLACE PACKAGE BODY p#dbf AS


------------------------------------------

    PROCEDURE del_doubles_dbf
        AS
    BEGIN
        DELETE FROM t#fcr_dbf
        WHERE
            id IN (
                SELECT
                    id
                FROM
                    (
                        SELECT
                            s.*,
                            ROW_NUMBER() OVER(
                                PARTITION BY 
                                data_pl,
                                summ_pl,
                                penalty,
                                ls,
                                period,
                                cod_rkc,
                                pd_num,
                                inn,
                                kpp,
                                plat,
                                prim
                                ORDER BY
                                    row_time
                            ) num
                        FROM
                            t#fcr_dbf s
                    )
                WHERE
                    num <> 1
            );

        COMMIT;
    END;
------------------------------------------

    PROCEDURE load_to_paysource
        AS
    BEGIN
        INSERT INTO t#pay_source (
            c#account,
            c#real_date,
            c#summa,
            c#fine,
            c#period,
            c#cod_rkc,
            c#pay_num,
            c#file_id,
            c#comment,
            c#plat
        )
            SELECT
                regexp_substr(ltrim(replace(ls,' ',''),'0'),'[^?-]+',1),
                data_pl,
                summ_pl,
                penalty,
                period,
                cod_rkc,
                pd_num,
                -6,
                file_name,
                plat
            FROM
                t#fcr_dbf d
            WHERE
                id NOT IN (
                    SELECT
                        r.id
                    FROM
                        t#pay_source p
                        JOIN t#fcr_dbf r ON ( c#real_date = data_pl
                                              AND   (
                            regexp_substr(ltrim(replace(ls,' ',''),'0'),'[^?-]+',1) = c#account
                            OR    ls = c#account
                        )
                                              AND   summ_pl = c#summa
                                              AND   p.c#file_id >= 0
                                              AND   period = c#period
                                              AND   nvl(c#pay_num,0) = nvl(pd_num,0) )
                )
            MINUS
            SELECT
                c#account,
                c#real_date,
                c#summa,
                c#fine,
                c#period,
                c#cod_rkc,
                TO_CHAR(c#pay_num),
                c#file_id,
                c#comment,
                c#plat
            FROM
                t#pay_source
            WHERE
                c#file_id < 0;

        COMMIT;
    END;
------------------------------------------

    PROCEDURE after_autoload
        AS
    BEGIN
        del_doubles_dbf ();
        load_to_paysource ();
    END after_autoload;

END p#dbf;
/
