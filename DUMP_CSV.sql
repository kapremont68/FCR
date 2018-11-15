--------------------------------------------------------
--  DDL for Function DUMP_CSV
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."DUMP_CSV" (
    p_query       IN VARCHAR2,
    p_separator   IN VARCHAR2 DEFAULT ';',
    p_dir         IN VARCHAR2,
    p_filename    IN VARCHAR2
) RETURN NUMBER IS

    l_output        utl_file.file_type;
    l_thecursor     INTEGER DEFAULT dbms_sql.open_cursor;
    l_columnvalue   VARCHAR2(2000);
    l_status        INTEGER;
    l_colcnt        NUMBER DEFAULT 0;
    l_separator     VARCHAR2(10) DEFAULT ';';
    l_cnt           NUMBER DEFAULT 0;
BEGIN
    l_output := utl_file.fopen(p_dir,p_filename,'w');
    dbms_sql.parse(l_thecursor,p_query,dbms_sql.native);
    FOR i IN 1..255 LOOP
        BEGIN
            dbms_sql.define_column(l_thecursor,i,l_columnvalue,2000);
            l_colcnt := i;
        EXCEPTION
            WHEN OTHERS THEN
                IF
                    ( sqlcode =-1007 )
                THEN
                    EXIT;
                ELSE
                    RAISE;
                END IF;
        END;
    END LOOP;

    dbms_sql.define_column(l_thecursor,1,l_columnvalue,2000);
    l_status := dbms_sql.execute(l_thecursor);
    LOOP
        EXIT WHEN ( dbms_sql.fetch_rows(l_thecursor) <= 0 );
        l_separator := '';
        FOR i IN 1..l_colcnt LOOP
            dbms_sql.column_value(l_thecursor,i,l_columnvalue);
            utl_file.put(l_output,l_separator
            || l_columnvalue);
            l_separator := p_separator;
        END LOOP;

        utl_file.new_line(l_output);
        l_cnt := l_cnt + 1;
    END LOOP;

    dbms_sql.close_cursor(l_thecursor);
    utl_file.fclose(l_output);
    RETURN l_cnt;
END dump_csv;

/
