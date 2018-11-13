BEGIN
    FOR rec IN (
        SELECT DISTINCT
            c#account_id account_id,
            c#out_proc_id out_proc_id,
            t.name1 out_num,
            'Добавлено пакетно '
            || SYSDATE note
        FROM
            t#account_op o
            JOIN tt#tter_te t ON ( o.c#out_num = t.outerls )
    ) LOOP
        INSERT INTO t#account_op (
            c#account_id,
            c#date,
            c#out_proc_id,
            c#out_num,
            c#note
        ) VALUES (
            rec.account_id,
            get_new_rkc_date(rec.account_id,TO_DATE('01.10.2018','dd.mm.yyyy') ),
            rec.out_proc_id,
            rec.out_num,
            rec.note
        );

    END LOOP;
END;