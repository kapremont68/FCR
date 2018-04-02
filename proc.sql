--------------------------------------------------------
--  File created - понедельник-апреля-02-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure DEL#OP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DEL#OP" (a#ops_id number) is
a#err varchar2(4000);
begin
  insert into TT#TR_FLAG (C#VAL) values('OP#PASS_MOD');
  insert into TT#TR_FLAG (C#VAL) values('OP_VD#PASS_MOD');
    delete from fcr.t#op_vd where c#id in (select c#id from fcr.t#op where c#ops_id = a#ops_id);
    delete from fcr.t#op where c#ops_id = a#ops_id;
--  commit;
  exception
   when OTHERS then 
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DEL#OP',sysdate,a#err,to_char(a#ops_id));
     rollback;
 
end;

/
--------------------------------------------------------
--  DDL for Procedure DEL#OP2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DEL#OP2" (a#ops_id number) is
a#err varchar2(4000);
begin
  insert into TT#TR_FLAG (C#VAL) values('OP#PASS_MOD');
  insert into TT#TR_FLAG (C#VAL) values('OP_VD#PASS_MOD');
    delete from fcr.t#op_vd where c#id in (select c#id from fcr.t#op where c#ops_id = a#ops_id);
    delete from fcr.t#op where c#ops_id = a#ops_id;
--  commit;
  exception
   when OTHERS then 
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DEL#OP',sysdate,a#err,to_char(a#ops_id));
     rollback;

end;

/
--------------------------------------------------------
--  DDL for Procedure DO#2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#2" AS
cursor old_ostatok is --Собираем строки с недораспределенными остатками и заводим их новой строкой
--для попытки распределения, по старым строкам ставим признак что остаток перенесен в новую строку

select mp.c#person_id, mp.с#ostatok, mp.c#date, mp.c#living_tag, mp.c#id, mp.c#npd, mp.c#cod_rkc, mp.c#comment
  from t#mass_pay mp
 where nvl(mp.с#ostatok,0) > 0
   and nvl(mp.c#remove_flg, 'N') <> 'Y'
   and nvl(mp.c#storno_flg, 'N') <> 'Y'
   and (mp.C#ACC_ID is null or mp.C#ACC_ID = 0)
;
a#err varchar2(4000);
begin
for mp in old_ostatok loop
begin
insert into fcr.t#mass_pay(c#person_id, c#sum, c#date, c#living_tag, c#parent_id, c#npd, c#cod_rkc, c#comment)
values (mp.c#person_id, mp.с#ostatok, mp.c#date, mp.c#living_tag, mp.c#id, mp.c#npd, mp.c#cod_rkc, mp.c#comment);
update fcr.t#mass_pay m
  set m.c#remove_flg = 'Y'
 where m.c#id = mp.c#id;
commit;
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#2',sysdate,a#err,to_char(mp.c#person_id));
end;
end loop;
END DO#2;

/
--------------------------------------------------------
--  DDL for Procedure DO#2_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#2_1" AS
cursor ins_storno is
select t.c#person_id,  --to_date('01.09.2016','dd.mm.yyyy') 
fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN)
as c#date, -1*sum(t.c#sum) c#sum
  from T#MASS_PAY t
 where 1 = 1
   and  t.c#acc_id is not null
   and nvl(t.c#storno_flg,'N') = 'Y'
   and nvl(t.c#remove_flg, 'N') = 'N'
group by t.c#person_id;
a#err varchar2(4000);
BEGIN

for mp in ins_storno loop
begin	
insert into fcr.t#mass_pay(c#person_id, c#sum, c#date, c#cod_rkc, c#comment, c#acc_id)
values (mp.c#person_id, mp.c#sum, mp.c#date, 91, 'Сторно по ЛС', 0);

update fcr.t#mass_pay m
  set m.c#remove_flg = 'Y'
 where m.c#acc_id is not null
  and nvl(m.c#storno_flg, 'N') = 'Y'
  and nvl(m.c#remove_flg, 'N') = 'N'
  and m.c#person_id = mp.c#person_id
  ;
commit;  
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#2_1',sysdate,a#err,to_char(mp.c#person_id));

end;
end loop;  

END DO#2_1;

/
--------------------------------------------------------
--  DDL for Procedure DO#3
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#3" AS

    CURSOR pay IS
        SELECT
            mp.c#id,
            mp.c#person_id,
            mp.c#sum,
            mp.c#date,
            nvl(mp.c#living_tag,'A') AS living_tag,
            mp.c#npd,
            mp.c#comment,
            mp.c#cod_rkc
        FROM
            fcr.t#mass_pay mp
        WHERE
                1 = 1
            AND
                mp.c#ops_id IS NULL
            AND
                mp.c#sum > 0
    --and mp.c#id >= 750
        ORDER BY
            mp.c#person_id,
            mp.c#id;

    CURSOR nach (
        a#person_id       IN NUMBER,
        a#lt              IN CHAR,
        a#m_date_offset   IN NUMBER
    ) IS
        SELECT
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id,
            a.c#mn AS c#a_mn,
            a.c#b_mn,
            nvl(a.c#c_sum,0) + nvl(a.c#m_sum,0) - nvl(c#p_sum,0) to_pay
        FROM
            (
                SELECT
                    a.*,
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        0
                    ) ) "C#TAR_VAL",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        1
                    ) ) "C#C_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        2
                    ) ) "C#M_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        3
                    ) ) "C#WORK_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        4
                    ) ) "C#DOER_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        5
                    ) ) "C#B_MN",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -3
                    ) ) "C#P_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -2
                    ) ) "C#FC_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -1
                    ) ) "C#FP_SUM"
                FROM
                    (
                        SELECT
                            a.c#account_id,
                            value(t) "C#MN"
                        FROM
                            (
                                SELECT
                                    *
                                FROM
                                    (
                                        SELECT
                                            c#account_id,
                                            nvl(
                                                greatest(
                                                    p#mn_utils.get#mn(c#date) +
                                                        CASE
                                                            WHEN c#date < trunc(c#date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    162
                                                ),
                                                162
                                            ) "C#MN",
                                            nvl(
                                                least(
                                                    p#mn_utils.get#mn(c#next_date) +
                                                        CASE
                                                            WHEN c#next_date < trunc(c#next_date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    fcr.p#utils.get#open_mn
                                                ),
                                                fcr.p#utils.get#open_mn
                                            ) "C#NEXT_MN"
                                        FROM
                                            (
                                                SELECT
                                                    asp.c#person_id,
                                                    asp.c#account_id,
                                                    asp.c#date,
                                                    LEAD(
                                                        asp.c#date
                                                    ) OVER(PARTITION BY
                                                        asp.c#account_id
                                                        ORDER BY asp.c#date
                                                    ) "C#NEXT_DATE"
                                                FROM
                                                    v#account_spec asp
                                                WHERE
                                                        1 = 1
                                                    AND
                                                        asp.c#valid_tag = 'Y'
                                                    AND
                                                        asp.c#account_id IN (
                                                            SELECT
                                                                c#account_id
                                                            FROM
                                                                v#account_spec
                                                            WHERE
                                                                    1 = 1
                                                                AND
                                                                    c#valid_tag = 'Y'
                                                                AND
                                                                    c#person_id = a#person_id
                                                        )
                                            )
                                        WHERE
                                            c#person_id = a#person_id
                                    )
                                WHERE
                                    c#mn < c#next_mn
                            ) a,
                            TABLE ( CAST(MULTISET(
                                SELECT
                                    c#mn + level - 1
                                FROM
                                    TABLE(ttab#number(0) )
                                CONNECT BY
                                    level <= c#next_mn+1 - c#mn -- +1 добавлено 21.03.2018 чтобы переплата разносилась в том числе и на текущий месяц
                            ) AS ttab#number) ) t
                    ) a,
                    TABLE ( CAST(MULTISET(
                        SELECT
                            w.c#tar_val
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#c_sum,0) + nvl(t.c#mc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#m_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#work_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#doer_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#b_mn,0) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#mp_sum,0) + nvl(t.c#p_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fp_sum,0) ) )
                        FROM
                            v#chop t,
                            v#work w
                        WHERE
                                1 = 1
                            AND
                                t.c#account_id = a.c#account_id
                            AND
                                t.c#a_mn = a.c#mn
                            AND
                                w.c#valid_tag = 'Y'
                            AND
                                w.c#id = t.c#work_id
                        GROUP BY
                            w.c#tar_val,
                            t.c#work_id,
                            t.c#doer_id,
                            t.c#b_mn
                        HAVING
                            SUM(nvl(t.c#c_sum,0) + nvl(t.c#mc_sum,0) ) + SUM(nvl(t.c#m_sum,0) ) <> SUM(nvl(t.c#mp_sum,0) + nvl(t.c#p_sum,0) )
                        OR
                            SUM(nvl(t.c#fc_sum,0) ) <> SUM(nvl(t.c#fp_sum,0) )
                    ) AS ttab#string) ) t
            ) a
        WHERE
            (
                nvl(a.c#c_sum,0) + nvl(a.c#m_sum,0) - nvl(c#p_sum,0) <> 0
            ) AND (p#tools.house_is_open(a.c#account_id) = 'Y') -- добавлено 16.02.2018 чтобы не пересчитывались счета на закрытых домах
        ORDER BY
            a.c#mn,
            a.c#b_mn,
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id;

    kind_id    NUMBER;
    a#date     DATE;
    w_id       NUMBER;
    d_id       NUMBER;
    ops_id     NUMBER;
    op_id      NUMBER;
    ostatok    NUMBER;
    a_mn       NUMBER;
    work_mn    NUMBER;
    pay_date   DATE;
    a#err      VARCHAR2(4000);
BEGIN
    a#date := SYSDATE;
    a_mn := fcr.p#utils.get#open_mn;
    work_mn := fcr.p#utils.get#open_mn;
    FOR c IN pay LOOP
        BEGIN
            IF
                c.c#date < fcr.p#mn_utils.get#date(work_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(work_mn);
            ELSE
                pay_date := c.c#date;
            END IF;

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = nvl(c.c#cod_rkc,'90');

            INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;
  
    --dbms_output.put_line('ops_id = '||ops_id);

            INSERT INTO t#ops_vd (
                c#id,
                c#vn,
                c#valid_tag,
                c#kind_id,
                c#note_text
            ) VALUES (
                ops_id,
                1,
                'Y',
                kind_id,
                CASE
                    WHEN c.c#npd IS NOT NULL THEN '(НПД ' || c.c#npd || ')'
                END
            );

            ostatok := c.c#sum;
            IF
                ostatok > 0
            THEN
    
      --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);
                FOR d IN nach(
                    c.c#person_id,
                    c.living_tag,
                    15
                ) LOOP
                    IF
                        ostatok > 0
                    THEN
        
          --dbms_output.put_line(d.c#account_id||' '||d.c#work_id||' '||d.C#DOER_ID);
                        IF
                            d.to_pay < ostatok
                        THEN
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                d.to_pay
                            );

                        ELSE
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                ostatok
                            );

                        END IF;

                        ostatok := ostatok - d.to_pay;
          --dbms_output.put_line('Остаток после перераспределения  = '||ostatok);
                    END IF;
        --  commit;
                END LOOP;

                IF
                    ostatok > 0
                THEN
                    dbms_output.put_line(c.c#id
                     || ' Остаток после всех распределений = '
                     || ostatok);
                    UPDATE fcr.t#mass_pay f
                        SET
                            f.с#ostatok = ostatok
                    WHERE
                            1 = 1
                        AND
                            f.c#person_id = c.c#person_id
                        AND
                            f.c#id = c.c#id;

                END IF;

            END IF;

            UPDATE fcr.t#mass_pay f
                SET
                    f.c#ops_id = ops_id
            WHERE
                    1 = 1
                AND
                    f.c#person_id = c.c#person_id
                AND
                    f.c#id = c.c#id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                a#err := 'Error - '
                 || TO_CHAR(sqlcode)
                 || ' - '
                 || sqlerrm;
                INSERT INTO fcr.t#exception (
                    c#name_package,
                    c#name_proc,
                    c#date,
                    c#text,
                    c#comment
                ) VALUES (
                    'PROCEDURE',
                    'DO#3',
                    SYSDATE,
                    a#err,
                    TO_CHAR(c.c#person_id)
                );

        END;
    END LOOP;

  -- отрицательные суммы

    do#distr_negative_balance;
END do#3;

/
--------------------------------------------------------
--  DDL for Procedure DO#3BYPERSONID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#3BYPERSONID" ( p_person_id NUMBER )  AS 
    CURSOR pay IS
        SELECT
            mp.c#id,
            mp.c#person_id,
            mp.c#sum,
            mp.c#date,
            nvl(mp.c#living_tag,'A') AS living_tag,
            mp.c#npd,
            mp.c#comment,
            mp.c#cod_rkc
        FROM
            fcr.t#mass_pay mp
        WHERE
                1 = 1
            AND
                mp.c#ops_id IS NULL
            AND
                mp.c#sum > 0
            AND
                mp.c#person_id = p_person_id
    --and mp.c#id >= 750
        ORDER BY
            mp.c#person_id,
            mp.c#id;

    CURSOR nach (
        a#person_id       IN NUMBER,
        a#lt              IN CHAR,
        a#m_date_offset   IN NUMBER
    ) IS
        SELECT
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id,
            a.c#mn AS c#a_mn,
            a.c#b_mn,
            nvl(a.c#c_sum,0) + nvl(a.c#m_sum,0) - nvl(c#p_sum,0) to_pay
        FROM
            (
                SELECT
                    a.*,
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        0
                    ) ) "C#TAR_VAL",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        1
                    ) ) "C#C_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        2
                    ) ) "C#M_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        3
                    ) ) "C#WORK_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        4
                    ) ) "C#DOER_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        5
                    ) ) "C#B_MN",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -3
                    ) ) "C#P_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -2
                    ) ) "C#FC_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -1
                    ) ) "C#FP_SUM"
                FROM
                    (
                        SELECT
                            a.c#account_id,
                            value(t) "C#MN"
                        FROM
                            (
                                SELECT
                                    *
                                FROM
                                    (
                                        SELECT
                                            c#account_id,
                                            nvl(
                                                greatest(
                                                    p#mn_utils.get#mn(c#date) +
                                                        CASE
                                                            WHEN c#date < trunc(c#date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    162
                                                ),
                                                162
                                            ) "C#MN",
                                            nvl(
                                                least(
                                                    p#mn_utils.get#mn(c#next_date) +
                                                        CASE
                                                            WHEN c#next_date < trunc(c#next_date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    fcr.p#utils.get#open_mn
                                                ),
                                                fcr.p#utils.get#open_mn
                                            ) "C#NEXT_MN"
                                        FROM
                                            (
                                                SELECT
                                                    asp.c#person_id,
                                                    asp.c#account_id,
                                                    asp.c#date,
                                                    LEAD(
                                                        asp.c#date
                                                    ) OVER(PARTITION BY
                                                        asp.c#account_id
                                                        ORDER BY asp.c#date
                                                    ) "C#NEXT_DATE"
                                                FROM
                                                    v#account_spec asp
                                                WHERE
                                                        1 = 1
                                                    AND
                                                        asp.c#valid_tag = 'Y'
                                                    AND
                                                        asp.c#account_id IN (
                                                            SELECT
                                                                c#account_id
                                                            FROM
                                                                v#account_spec
                                                            WHERE
                                                                    1 = 1
                                                                AND
                                                                    c#valid_tag = 'Y'
                                                                AND
                                                                    c#person_id = a#person_id
                                                        )
                                            )
                                        WHERE
                                            c#person_id = a#person_id
                                    )
                                WHERE
                                    c#mn < c#next_mn
                            ) a,
                            TABLE ( CAST(MULTISET(
                                SELECT
                                    c#mn + level - 1
                                FROM
                                    TABLE(ttab#number(0) )
                                CONNECT BY
                                    level <= c#next_mn+1 - c#mn -- +1 добавлено 21.03.2018 чтобы переплата разносилась в том числе и на текущий месяц
                            ) AS ttab#number) ) t
                    ) a,
                    TABLE ( CAST(MULTISET(
                        SELECT
                            w.c#tar_val
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#c_sum,0) + nvl(t.c#mc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#m_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#work_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#doer_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#b_mn,0) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#mp_sum,0) + nvl(t.c#p_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fp_sum,0) ) )
                        FROM
                            v#chop t,
                            v#work w
                        WHERE
                                1 = 1
                            AND
                                t.c#account_id = a.c#account_id
                            AND
                                t.c#a_mn = a.c#mn
                            AND
                                w.c#valid_tag = 'Y'
                            AND
                                w.c#id = t.c#work_id
                        GROUP BY
                            w.c#tar_val,
                            t.c#work_id,
                            t.c#doer_id,
                            t.c#b_mn
                        HAVING
                            SUM(nvl(t.c#c_sum,0) + nvl(t.c#mc_sum,0) ) + SUM(nvl(t.c#m_sum,0) ) <> SUM(nvl(t.c#mp_sum,0) + nvl(t.c#p_sum,0) )
                        OR
                            SUM(nvl(t.c#fc_sum,0) ) <> SUM(nvl(t.c#fp_sum,0) )
                    ) AS ttab#string) ) t
            ) a
        WHERE
            (
                nvl(a.c#c_sum,0) + nvl(a.c#m_sum,0) - nvl(c#p_sum,0) <> 0
            ) 
--            AND (p#tools.house_is_open(a.c#account_id) = 'Y') -- добавлено 16.02.2018 чтобы не пересчитывались счета на закрытых домах
             AND (
                p#tools.account_is_open_error(a.c#account_id) = 'N'
            ) -- добавлено 13.03.2018 чтобы не разносить бабло на закрытые в день открытия счета
        ORDER BY
            a.c#mn,
            a.c#b_mn,
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id;

    kind_id    NUMBER;
    a#date     DATE;
    w_id       NUMBER;
    d_id       NUMBER;
    ops_id     NUMBER;
    op_id      NUMBER;
    ostatok    NUMBER;
    a_mn       NUMBER;
    work_mn    NUMBER;
    pay_date   DATE;
    a#err      VARCHAR2(4000);
BEGIN
    a#date := SYSDATE;
    a_mn := fcr.p#utils.get#open_mn;
    work_mn := fcr.p#utils.get#open_mn;
    FOR c IN pay LOOP
        BEGIN
            IF
                c.c#date < fcr.p#mn_utils.get#date(work_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(work_mn);
            ELSE
                pay_date := c.c#date;
            END IF;

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = nvl(c.c#cod_rkc,'90');

            INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;

    --dbms_output.put_line('ops_id = '||ops_id);

            INSERT INTO t#ops_vd (
                c#id,
                c#vn,
                c#valid_tag,
                c#kind_id,
                c#note_text
            ) VALUES (
                ops_id,
                1,
                'Y',
                kind_id,
                CASE
                    WHEN c.c#npd IS NOT NULL THEN '(НПД ' || c.c#npd || ')'
                END
            );

            ostatok := c.c#sum;
            IF
                ostatok > 0
            THEN

      --dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);
                FOR d IN nach(
                    c.c#person_id,
                    c.living_tag,
                    15
                ) LOOP
                    IF
                        ostatok > 0
                    THEN

--          dbms_output.put_line(d.c#a_mn);
          --dbms_output.put_line(d.c#account_id||' '||d.c#work_id||' '||d.C#DOER_ID);
                        IF
                            d.to_pay < ostatok
                        THEN
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                d.to_pay
                            );

                        ELSE
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                ostatok
                            );

                        END IF;

                        ostatok := ostatok - d.to_pay;
          --dbms_output.put_line('Остаток после перераспределения  = '||ostatok);
                    END IF;
        --  commit;
                END LOOP;

                IF
                    ostatok > 0
                THEN
                    dbms_output.put_line(c.c#id
                     || ' Остаток после всех распределений = '
                     || ostatok);
                    UPDATE fcr.t#mass_pay f
                        SET
                            f.с#ostatok = ostatok
                    WHERE
                            1 = 1
                        AND
                            f.c#person_id = c.c#person_id
                        AND
                            f.c#id = c.c#id;

                END IF;

            END IF;

            UPDATE fcr.t#mass_pay f
                SET
                    f.c#ops_id = ops_id
            WHERE
                    1 = 1
                AND
                    f.c#person_id = c.c#person_id
                AND
                    f.c#id = c.c#id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                a#err := 'Error - '
                 || TO_CHAR(sqlcode)
                 || ' - '
                 || sqlerrm;
                INSERT INTO fcr.t#exception (
                    c#name_package,
                    c#name_proc,
                    c#date,
                    c#text,
                    c#comment
                ) VALUES (
                    'PROCEDURE',
                    'DO#3',
                    SYSDATE,
                    a#err,
                    TO_CHAR(c.c#person_id)
                );

        END;
    END LOOP;

  -- отрицательные суммы

    do#distr_negative_balance_pers(p_person_id);
    END DO#3BYPERSONID;

/
--------------------------------------------------------
--  DDL for Procedure DO#CALC_B_STORE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CALC_B_STORE" (
    a#h_id INTEGER,
    a#mn NUMBER
) IS

    a#lh     VARCHAR2(128);
    atab#d   ttab#cbs_d;
    a#num    VARCHAR2(20);
    a#err    VARCHAR2(4000);
BEGIN
--        RAISE_APPLICATION_ERROR(-20002,'Отключено');
    RETURN;
-- dbms_lock.allocate_unique_autonomous('CALC_B_STORE#'||A#H_ID, A#LH, 60);
-- if dbms_lock.request(A#LH, dbms_lock.x_mode, 60/*dbms_lock.maxwait*/, true) = 0
-- then
--  null;
-- else
--  raise_application_error(-20000,'Ошибка расчёта, ресурс занят.');
-- end if;
-- begin
    DELETE FROM t#b_storage
    WHERE
        c#house_id = a#h_id
        AND   c#mn >= a#mn;

    DELETE FROM t#b_store
    WHERE
        c#house_id = a#h_id
        AND   c#mn >= a#mn;

    atab#d := p#cbs_utils.get_tab#d(a#h_id,a#mn);
    IF
        atab#d IS NOT NULL AND atab#d.count > 0
    THEN
        DECLARE
            a#n_mn   NUMBER;
        BEGIN
            SELECT
                MIN(least(nvl(f#0_mn,f#1_mn),nvl(f#1_mn,f#0_mn) ) ) + 1
            INTO
                a#n_mn
            FROM
                TABLE ( CAST(atab#d AS ttab#cbs_d) ) t
            WHERE
                nvl(f#0_mn,f#1_mn) < a#mn - 1;

            IF
                a#n_mn IS NOT NULL
            THEN
                raise_application_error(-20000,'DO#CALC_B_STORE: Ошибка расчёта, требуется последовательный расчёт с "'
                || TO_CHAR(p#mn_utils.get#date(a#n_mn),'mm.yyyy')
                || '". HOUSE_ID = '
                || a#h_id);

            END IF;

        END;

        INSERT INTO t#b_store (
            c#id,
            c#house_id,
            c#service_id,
            c#b_account_id,
            c#mn
        )
            SELECT
                s#b_store.NEXTVAL,
                a#h_id,
                f#service_id,
                f#b_account_id,
                a#mn
            FROM
                TABLE ( CAST(atab#d AS ttab#cbs_d) ) t
            WHERE
                nvl(f#0_mn,f#1_mn) = a#mn - 1;

        INSERT INTO t#b_storage (
            c#house_id,
            c#service_id,
            c#b_account_id,
            c#mn,
            c#c_sum,
            c#m_sum,
            c#p_sum,
            c#t_sum
        )
            SELECT
                a#h_id,
                f#service_id,
                f#b_account_id,
                a#mn,
                nvl(t.fobj#0_a.f#c_sum,0) + nvl(t.fobj#1_a.f#c_sum,0),
                nvl(t.fobj#0_a.f#m_sum,0) + nvl(t.fobj#1_a.f#m_sum,0),
                nvl(t.fobj#0_a.f#p_sum,0) + nvl(t.fobj#1_a.f#p_sum,0),
                nvl(t.fobj#0_a.f#t_sum,0) + nvl(t.fobj#1_a.f#t_sum,0)
            FROM
                TABLE ( CAST(atab#d AS ttab#cbs_d) ) t
            WHERE
                nvl(f#0_mn,f#1_mn) = a#mn - 1
                AND   f#tag > 1;

    END IF;
-- exception
--  when others then
--   raise;
-- end;

END;

/
--------------------------------------------------------
--  DDL for Procedure DO#CALC_CHARGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CALC_CHARGE" 
 (
  A#A_ID integer
 ,A#MN number
 ,A#B_MN number
 ,A#C_MN number
 ,A#SKIP_ZEROS number := null
 ) is
 A#LH varchar2(128);
 AOBJ#AD TOBJ#CC_AD;
begin
 dbms_lock.allocate_unique_autonomous('CALC_CHARGE#'||A#A_ID||';'||A#MN, A#LH, 60);
 if dbms_lock.request(A#LH, dbms_lock.x_mode, 120/*dbms_lock.maxwait*/, true) = 0
 then
  null;
 else
  raise_application_error(-20000,'Ошибка расчёта, ресурс занят.');
 end if;
-- begin
  delete
    from T#CHARGE
   where C#ACCOUNT_ID = A#A_ID
     and C#MN = A#C_MN
     and C#A_MN = A#MN
     and C#B_MN = A#B_MN
  ;
--  if P#CC_UTILS.GET#AD_INITED(A#A_ID, A#MN, AOBJ#AD) and AOBJ#AD.FTAB#D.count > 0
--  then
   declare
    ATAB#DVS TTAB#CC_DVS := P#CC_UTILS.GET_TAB#DVS(A#A_ID, A#MN, AOBJ#AD, AOBJ#AD.FTAB#D);
   begin

   insert into T#CHARGE (C#ID, C#ACCOUNT_ID, C#WORK_ID, C#DOER_ID, C#MN, C#A_MN, C#B_MN, C#VOL, C#SUM)
   select S#CHARGE.nextval
          ,A#A_ID
          ,C#WORK_ID
          ,C#DOER_ID
          ,A#C_MN
          ,A#MN
          ,A#B_MN
          ,nvl(C#VOL,0)
          ,nvl(C#SUM,0)
      from (
            select C#WORK_ID
                  ,C#DOER_ID
                  ,sum(C#VOL) "C#VOL"
                  ,sum(C#SUM) "C#SUM"
              from (
                    select C.C#WORK_ID
                          ,C.C#DOER_ID
                          ,-1*C.C#VOL "C#VOL"
                          ,-1*C.C#SUM "C#SUM"
                      from T#CHARGE C
                     where 1 = 1
                       and C.C#ACCOUNT_ID = A#A_ID
                       and C.C#A_MN = A#MN
                    union all
                    select /*+ cardinality (T 10)*/
                           T.FOBJ#D.F#WORK_ID
                          ,T.FOBJ#D.F#DOER_ID
                          ,T.FOBJ#DV.F#VOL
                          ,T.FOBJ#DS.F#SUM
                      from table(cast(ATAB#DVS as TTAB#CC_DVS)) T
                   )
             group by
                   C#WORK_ID
                  ,C#DOER_ID
           )
     where C#VOL <> 0 or C#SUM <> 0 or (A#SKIP_ZEROS is null and A#MN = A#B_MN and A#MN = A#C_MN) or A#SKIP_ZEROS = 0
   ;
   end;
--  end if;
-- exception
--  when others then
--   raise;
-- end;
end;

/
--------------------------------------------------------
--  DDL for Procedure DO#CALC_STORE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CALC_STORE" (A#A_ID integer, A#MN number) is
  A#NUM  varchar2(20);
  A#LH   varchar2(128);
  ATAB#D TTAB#CS_D;
begin
--  dbms_lock.allocate_unique_autonomous('CALC_STORE#' || A#A_ID, A#LH, 60);
--  if dbms_lock.request(A#LH,
--                       dbms_lock.x_mode,
--                       60 /*dbms_lock.maxwait*/,
--                       true) = 0 then
--    null;
--  else
--    raise_application_error(-20000,
--                            'Ошибка расчёта, ресурс занят.');
--  end if;
  -- begin
  delete from T#STORAGE
   where C#ACCOUNT_ID = A#A_ID
     and C#MN >= A#MN;
  delete from T#STORE
   where C#ACCOUNT_ID = A#A_ID
     and C#MN >= A#MN;
  ATAB#D := P#CS_UTILS.GET_TAB#D(A#A_ID, A#MN);
  if ATAB#D is not null and ATAB#D.count > 0 then
    declare
      A#N_MN number;
    begin
      select min(least(nvl(F#0_MN, F#1_MN), nvl(F#1_MN, F#0_MN))) + 1
        into A#N_MN
        from table(cast(ATAB#D as TTAB#CS_D)) T
       where nvl(F#0_MN, F#1_MN) < A#MN - 1;
      if A#N_MN is not null then
        select c#num into a#num from fcr.t#account where c#id = A#A_ID;
        DO#RECALC_ACCOUNT(a#num, P#MN_UTILS.GET#DATE(A#N_MN));
      
        raise_application_error(-20000,
                                'DO#CALC_STORE: Ошибка расчёта, требуется последовательный расчёт с "' ||
                                to_char(P#MN_UTILS.GET#DATE(A#N_MN),
                                        'mm.yyyy') || '". ACCOUNT_NUM = '||a#num);
      end if;
    end;
    insert into T#STORE
      (C#ID, C#ACCOUNT_ID, C#WORK_ID, C#DOER_ID, C#MN)
      select S#STORE.nextval, A#A_ID, F#WORK_ID, F#DOER_ID, A#MN
        from table(cast(ATAB#D as TTAB#CS_D)) T
       where nvl(F#0_MN, F#1_MN) = A#MN - 1;
    insert into T#STORAGE
      (C#ACCOUNT_ID,
       C#WORK_ID,
       C#DOER_ID,
       C#MN,
       C#C_VOL,
       C#C2_VOL,
       C#C_SUM,
       C#C2_SUM,
       C#MC_SUM,
       C#M_SUM,
       C#MP_SUM,
       C#P_SUM,
       C#FC_SUM,
       C#FP_SUM)
      select A#A_ID,
             F#WORK_ID,
             F#DOER_ID,
             A#MN,
             nvl(T.FOBJ#0_A.F#C_VOL, 0) + nvl(T.FOBJ#1_A.F#C_VOL, 0),
             nvl(T.FOBJ#0_A.F#C2_VOL, 0) + nvl(T.FOBJ#1_A.F#C2_VOL, 0),
             nvl(T.FOBJ#0_A.F#C_SUM, 0) + nvl(T.FOBJ#1_A.F#C_SUM, 0),
             nvl(T.FOBJ#0_A.F#C2_SUM, 0) + nvl(T.FOBJ#1_A.F#C2_SUM, 0),
             nvl(T.FOBJ#0_A.F#MC_SUM, 0) + nvl(T.FOBJ#1_A.F#MC_SUM, 0),
             nvl(T.FOBJ#0_A.F#M_SUM, 0) + nvl(T.FOBJ#1_A.F#M_SUM, 0),
             nvl(T.FOBJ#0_A.F#MP_SUM, 0) + nvl(T.FOBJ#1_A.F#MP_SUM, 0),
             nvl(T.FOBJ#0_A.F#P_SUM, 0) + nvl(T.FOBJ#1_A.F#P_SUM, 0),
             nvl(T.FOBJ#0_A.F#FC_SUM, 0) + nvl(T.FOBJ#1_A.F#FC_SUM, 0),
             nvl(T.FOBJ#0_A.F#FP_SUM, 0) + nvl(T.FOBJ#1_A.F#FP_SUM, 0)
        from table(cast(ATAB#D as TTAB#CS_D)) T
       where nvl(F#0_MN, F#1_MN) = A#MN - 1
         and F#TAG > 1;
  end if;
  -- exception
  --  when others then
  --   raise;
  -- end;
end;

/
--------------------------------------------------------
--  DDL for Procedure DO#CLOSE_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CLOSE_ACCOUNT" 
(
  A#DATE IN DATE 
, A#ACCOUNT_ID NUMBER
, A#STATUS OUT NUMBER 
) AS 
  A#MN number ; -- месяц закрытия счета
  A#OP number ;
  A#COUNT number;
  rw_charge fcr.t#charge%rowtype;
BEGIN
   A#STATUS := 1;
   A#OP := fcr.p#utils.GET#OPEN_MN;
   IF (not A#DATE is null ) THEN  
   A#MN := fcr.P#MN_UTILS.GET#MN(A#DATE); -- месяц закрытия счета
-- проверить, что нет оплат за период до даты закрытия  
   select count(*) into A#COUNT from fcr.t#op where c#account_id = a#account_id and c#a_mn >=a#mn;
-- dbms_output.put_line('Счет : ' || A#ACCOUNT_ID || ' Месяц :' || A#MN || ' оплаты :' || A#COUNT);
-- удалить начисления до даты закрытия
   IF(A#COUNT = 0) THEN
      for rw_charge in 
      (
       select  C#VOL,C#B_MN,C#A_MN,C#DOER_ID,C#WORK_ID,C#ACCOUNT_ID,Sum(NVL(C#SUM,0)) C#SUM from fcr.t#charge where c#account_id = a#account_id and c#a_mn >=A#MN and c#a_mn < A#OP
       group by  C#VOL,C#B_MN,C#A_MN,C#DOER_ID,C#WORK_ID,C#ACCOUNT_ID
      )
      loop
         -- dbms_output.put_line(uid || ' ' || SYSDATE || ' ' || -1*rw_charge.C#SUM || ' ' || -1*rw_charge.C#VOL || ' ' || rw_charge.C#B_MN || ' ' || rw_charge.C#A_MN || ' ' || (A#OP+1)
         -- || ' ' || rw_charge.C#DOER_ID || ' ' || rw_charge.C#WORK_ID || ' ' || rw_charge.C#ACCOUNT_ID);          
          insert into fcr.t#charge(C#SIGN_S_ID,C#SIGN_DATE,C#SUM,C#VOL,C#B_MN,C#A_MN,C#MN,C#DOER_ID,C#WORK_ID,C#ACCOUNT_ID)
          values (uid,SYSDATE,-1*rw_charge.C#SUM,-1*rw_charge.C#VOL,rw_charge.C#B_MN,rw_charge.C#A_MN, A#OP,rw_charge.C#DOER_ID,rw_charge.C#WORK_ID,rw_charge.C#ACCOUNT_ID);      
      end loop;
      delete from fcr.t#Charge where c#account_id = a#account_id  and c#a_mn = A#OP;
      A#STATUS := 0;
   END IF;
   END IF;
   
END DO#CLOSE_ACCOUNT;

/
--------------------------------------------------------
--  DDL for Procedure DO#DISTR_NEGATIVE_BALANCE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#DISTR_NEGATIVE_BALANCE" AS

    CURSOR pay IS
        SELECT
            mp.c#id,
            mp.c#person_id,
            mp.c#sum,
            mp.c#date,
            nvl(mp.c#living_tag,'A') AS living_tag,
            mp.c#npd,
            mp.c#comment,
            mp.c#cod_rkc
        FROM
            fcr.t#mass_pay mp
        WHERE
                1 = 1
            AND
                mp.c#ops_id IS NULL
            AND
                mp.c#sum < 0
        ORDER BY
            mp.c#person_id,
            mp.c#id;

    CURSOR nach (
        a#person_id       IN NUMBER,
        a#lt              IN CHAR,
        a#m_date_offset   IN NUMBER
    ) IS
        SELECT
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id,
            a.c#mn AS c#a_mn,
            a.c#b_mn,
            nvl(c#p_sum,0) to_pay
        FROM
            (
                SELECT
                    a.*,
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        0
                    ) ) "C#TAR_VAL",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        1
                    ) ) "C#C_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        2
                    ) ) "C#M_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        3
                    ) ) "C#WORK_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        4
                    ) ) "C#DOER_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        5
                    ) ) "C#B_MN",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -3
                    ) ) "C#P_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -2
                    ) ) "C#FC_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -1
                    ) ) "C#FP_SUM"
                FROM
                    (
                        SELECT
                            a.c#account_id,
                            value(t) "C#MN"
                        FROM
                            (
                                SELECT
                                    *
                                FROM
                                    (
                                        SELECT
                                            c#account_id,
                                            nvl(
                                                greatest(
                                                    p#mn_utils.get#mn(c#date) +
                                                        CASE
                                                            WHEN c#date < trunc(c#date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    162
                                                ),
                                                162
                                            ) "C#MN",
                                            nvl(
                                                least(
                                                    p#mn_utils.get#mn(c#next_date) +
                                                        CASE
                                                            WHEN c#next_date < trunc(c#next_date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    (fcr.p#utils.get#open_mn + 1)
                                                ),
                                                (fcr.p#utils.get#open_mn + 1)
                                            ) "C#NEXT_MN"
                                        FROM
                                            (
                                                SELECT
                                                    asp.c#person_id,
                                                    asp.c#account_id,
                                                    asp.c#date,
                                                    LEAD(
                                                        asp.c#date
                                                    ) OVER(PARTITION BY
                                                        asp.c#account_id
                                                        ORDER BY asp.c#date
                                                    ) "C#NEXT_DATE"
                                                FROM
                                                    v#account_spec asp
                                                WHERE
                                                        1 = 1
                                                    AND
                                                        asp.c#valid_tag = 'Y'
                                                    AND
                                                        asp.c#account_id IN (
                                                            SELECT
                                                                c#account_id
                                                            FROM
                                                                v#account_spec
                                                            WHERE
                                                                    1 = 1
                                                                AND
                                                                    c#valid_tag = 'Y'
                                                                AND
                                                                    c#person_id = a#person_id
                                                        )
                                            )
                                        WHERE
                                            c#person_id = a#person_id
                                    )
                                WHERE
                                    c#mn < c#next_mn
                            ) a,
                            TABLE ( CAST(MULTISET(
                                SELECT
                                    c#mn + level - 1
                                FROM
                                    TABLE(ttab#number(0) )
                                CONNECT BY
                                    level <= c#next_mn+1 - c#mn -- +1 добавлено 21.03.2018 чтобы переплата разносилась в том числе и на текущий месяц
                            ) AS ttab#number) ) t
                    ) a,
                    TABLE ( CAST(MULTISET(
                        SELECT
                            w.c#tar_val
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#c_sum,0) + nvl(t.c#mc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#m_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#work_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#doer_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#b_mn,0) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#mp_sum,0) + nvl(t.c#p_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fp_sum,0) ) )
                        FROM
                            v#chop t,
                            v#work w
                        WHERE
                                1 = 1
                            AND
                                t.c#account_id = a.c#account_id
                            AND
                                t.c#a_mn = a.c#mn
                            AND
                                w.c#valid_tag = 'Y'
                            AND
                                w.c#id = t.c#work_id
                        GROUP BY
                            w.c#tar_val,
                            t.c#work_id,
                            t.c#doer_id,
                            t.c#b_mn
                    ) AS ttab#string) ) t
            ) a
        WHERE
                1 = 1
            AND nvl(c#p_sum,0) <> 0
            and (P#TOOLS.house_is_open(A.c#account_id) = 'Y')  -- добавлено 16.02.2018 чтобы не пересчитывались счета на закрытых домах
        ORDER BY
            a.c#mn DESC,
            a.c#b_mn DESC,
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id;

    kind_id     NUMBER;
    ops_id      NUMBER;
    op_id       NUMBER;
    ostatok     NUMBER;
    pay_date    DATE;
    a#work_mn   INTEGER;
    a#err       VARCHAR2(4000);
BEGIN
  
--A#DATE := sysdate;
--рабочий месяц = открытому
    a#work_mn := fcr.p#utils.get#open_mn;
    FOR c IN pay LOOP
        BEGIN
            IF
                c.c#date < fcr.p#mn_utils.get#date(a#work_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(a#work_mn);
            ELSE
                pay_date := c.c#date;
            END IF;

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = nvl(c.c#cod_rkc,'91');

            INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;

            INSERT INTO t#ops_vd (
                c#id,
                c#vn,
                c#valid_tag,
                c#kind_id,
                c#note_text
            ) VALUES (
                ops_id,
                1,
                'Y',
                kind_id,
                CASE
                    WHEN c.c#npd IS NOT NULL THEN '(НПД ' || c.c#npd || ')'
                END
            );

            ostatok :=-1 * c.c#sum;
            IF
                ostatok > 0
            THEN
                FOR d IN nach(
                    c.c#person_id,
                    c.living_tag,
                    15
                ) LOOP
                    IF
                        ostatok > 0
                    THEN
                        IF
                            d.to_pay < ostatok
                        THEN
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                -1 * d.to_pay
                            );

                        ELSE
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                -1 * ostatok
                            );

                        END IF;

                        ostatok := ostatok - d.to_pay;
                    END IF;  
 -- commit;
                END LOOP;

                IF
                    ostatok > 0
                THEN
                    dbms_output.put_line(c.c#id
                     || ' Остаток после всех распределений = '
                     || ostatok);
                    UPDATE fcr.t#mass_pay f
                        SET
                            f.с#ostatok =-1 * ostatok
                    WHERE
                            1 = 1
                        AND
                            f.c#person_id = c.c#person_id
                        AND
                            f.c#id = c.c#id;

                END IF;

            END IF;

            UPDATE fcr.t#mass_pay f
                SET
                    f.c#ops_id = ops_id
            WHERE
                    1 = 1
                AND
                    f.c#person_id = c.c#person_id
                AND
                    f.c#id = c.c#id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                a#err := 'Error - '
                 || TO_CHAR(sqlcode)
                 || ' - '
                 || sqlerrm;
                INSERT INTO fcr.t#exception (
                    c#name_package,
                    c#name_proc,
                    c#date,
                    c#text,
                    c#comment
                ) VALUES (
                    'PROCEDURE',
                    'DO#DIST_NEGATIVE_BALANCE',
                    SYSDATE,
                    a#err,
                    TO_CHAR(c.c#person_id)
                );

        END;
    END LOOP;

END do#distr_negative_balance;

/
--------------------------------------------------------
--  DDL for Procedure DO#DISTR_NEGATIVE_BALANCE_PERS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#DISTR_NEGATIVE_BALANCE_PERS" (P_PERSON_ID NUMBER) AS

    CURSOR pay IS
        SELECT
            mp.c#id,
            mp.c#person_id,
            mp.c#sum,
            mp.c#date,
            nvl(mp.c#living_tag,'A') AS living_tag,
            mp.c#npd,
            mp.c#comment,
            mp.c#cod_rkc
        FROM
            fcr.t#mass_pay mp
        WHERE
                1 = 1
            AND
                mp.c#ops_id IS NULL
            AND
                mp.c#sum < 0
            and 
                mp.c#person_id = P_PERSON_ID
        ORDER BY
            mp.c#person_id,
            mp.c#id;

    CURSOR nach (
        a#person_id       IN NUMBER,
        a#lt              IN CHAR,
        a#m_date_offset   IN NUMBER
    ) IS
        SELECT
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id,
            a.c#mn AS c#a_mn,
            a.c#b_mn,
            nvl(c#p_sum,0) to_pay
        FROM
            (
                SELECT
                    a.*,
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        0
                    ) ) "C#TAR_VAL",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        1
                    ) ) "C#C_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        2
                    ) ) "C#M_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        3
                    ) ) "C#WORK_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        4
                    ) ) "C#DOER_ID",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        5
                    ) ) "C#B_MN",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -3
                    ) ) "C#P_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -2
                    ) ) "C#FC_SUM",
                    to_number(get#substr(
                        value(t),
                        CHR(1),
                        -1
                    ) ) "C#FP_SUM"
                FROM
                    (
                        SELECT
                            a.c#account_id,
                            value(t) "C#MN"
                        FROM
                            (
                                SELECT
                                    *
                                FROM
                                    (
                                        SELECT
                                            c#account_id,
                                            nvl(
                                                greatest(
                                                    p#mn_utils.get#mn(c#date) +
                                                        CASE
                                                            WHEN c#date < trunc(c#date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    162
                                                ),
                                                162
                                            ) "C#MN",
                                            nvl(
                                                least(
                                                    p#mn_utils.get#mn(c#next_date) +
                                                        CASE
                                                            WHEN c#next_date < trunc(c#next_date,'MM') + a#m_date_offset THEN 0
                                                            ELSE 1
                                                        END,
                                                    (fcr.p#utils.get#open_mn + 1)
                                                ),
                                                (fcr.p#utils.get#open_mn + 1)
                                            ) "C#NEXT_MN"
                                        FROM
                                            (
                                                SELECT
                                                    asp.c#person_id,
                                                    asp.c#account_id,
                                                    asp.c#date,
                                                    LEAD(
                                                        asp.c#date
                                                    ) OVER(PARTITION BY
                                                        asp.c#account_id
                                                        ORDER BY asp.c#date
                                                    ) "C#NEXT_DATE"
                                                FROM
                                                    v#account_spec asp
                                                WHERE
                                                        1 = 1
                                                    AND
                                                        asp.c#valid_tag = 'Y'
                                                    AND
                                                        asp.c#account_id IN (
                                                            SELECT
                                                                c#account_id
                                                            FROM
                                                                v#account_spec
                                                            WHERE
                                                                    1 = 1
                                                                AND
                                                                    c#valid_tag = 'Y'
                                                                AND
                                                                    c#person_id = a#person_id
                                                        )
                                            )
                                        WHERE
                                            c#person_id = a#person_id
                                    )
                                WHERE
                                    c#mn < c#next_mn
                            ) a,
                            TABLE ( CAST(MULTISET(
                                SELECT
                                    c#mn + level - 1
                                FROM
                                    TABLE(ttab#number(0) )
                                CONNECT BY
                                    level <= c#next_mn+1 - c#mn -- +1 добавлено 21.03.2018 чтобы переплата разносилась в том числе и на текущий месяц
                            ) AS ttab#number) ) t
                    ) a,
                    TABLE ( CAST(MULTISET(
                        SELECT
                            w.c#tar_val
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#c_sum,0) + nvl(t.c#mc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#m_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#work_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#doer_id,0) )
                             || CHR(1)
                             || TO_CHAR(nvl(t.c#b_mn,0) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#mp_sum,0) + nvl(t.c#p_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fc_sum,0) ) )
                             || CHR(1)
                             || TO_CHAR(SUM(nvl(t.c#fp_sum,0) ) )
                        FROM
                            v#chop t,
                            v#work w
                        WHERE
                                1 = 1
                            AND
                                t.c#account_id = a.c#account_id
                            AND
                                t.c#a_mn = a.c#mn
                            AND
                                w.c#valid_tag = 'Y'
                            AND
                                w.c#id = t.c#work_id
                        GROUP BY
                            w.c#tar_val,
                            t.c#work_id,
                            t.c#doer_id,
                            t.c#b_mn
                    ) AS ttab#string) ) t
            ) a
        WHERE
                1 = 1
            AND nvl(c#p_sum,0) <> 0
--            and (P#TOOLS.house_is_open(A.c#account_id) = 'Y')  -- добавлено 16.02.2018 чтобы не пересчитывались счета на закрытых домах
            AND (p#tools.account_is_open_error(a.c#account_id) = 'N') -- добавлено 13.03.2018 чтобы не разносить бабло на закрытые в день открытия счета

        ORDER BY
            a.c#mn DESC,
            a.c#b_mn DESC,
            a.c#account_id,
            a.c#work_id,
            a.c#doer_id;

    kind_id     NUMBER;
    ops_id      NUMBER;
    op_id       NUMBER;
    ostatok     NUMBER;
    pay_date    DATE;
    a#work_mn   INTEGER;
    a#err       VARCHAR2(4000);
BEGIN

--A#DATE := sysdate;
--рабочий месяц = открытому
    a#work_mn := fcr.p#utils.get#open_mn;
    FOR c IN pay LOOP
        BEGIN
            IF
                c.c#date < fcr.p#mn_utils.get#date(a#work_mn)
            THEN
                pay_date := fcr.p#mn_utils.get#date(a#work_mn);
            ELSE
                pay_date := c.c#date;
            END IF;

            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#ops_kind ok
            WHERE
                ok.c#cod = nvl(c.c#cod_rkc,'91');

            INSERT INTO fcr.t#ops ( c#id ) VALUES ( fcr.s#ops.nextval ) RETURNING c#id INTO ops_id;

            INSERT INTO t#ops_vd (
                c#id,
                c#vn,
                c#valid_tag,
                c#kind_id,
                c#note_text
            ) VALUES (
                ops_id,
                1,
                'Y',
                kind_id,
                CASE
                    WHEN c.c#npd IS NOT NULL THEN '(НПД ' || c.c#npd || ')'
                END
            );

            ostatok :=-1 * c.c#sum;
            IF
                ostatok > 0
            THEN
                FOR d IN nach(
                    c.c#person_id,
                    c.living_tag,
                    15
                ) LOOP
                    IF
                        ostatok > 0
                    THEN
                        IF
                            d.to_pay < ostatok
                        THEN
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                -1 * d.to_pay
                            );

                        ELSE
                            INSERT INTO fcr.t#op (
                                c#id,
                                c#ops_id,
                                c#account_id,
                                c#work_id,
                                c#doer_id,
                                c#date,
                                c#real_date,
                                c#a_mn,
                                c#b_mn,
                                c#type_tag
                            ) VALUES (
                                fcr.s#op.nextval,
                                ops_id,
                                d.c#account_id,
                                d.c#work_id,
                                d.c#doer_id,
                                pay_date,
                                c.c#date,
                                d.c#a_mn,
                                d.c#b_mn,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                -1 * ostatok
                            );

                        END IF;

                        ostatok := ostatok - d.to_pay;
                    END IF;  
 -- commit;
                END LOOP;

                IF
                    ostatok > 0
                THEN
                    dbms_output.put_line(c.c#id
                     || ' Остаток после всех распределений = '
                     || ostatok);
                    UPDATE fcr.t#mass_pay f
                        SET
                            f.с#ostatok =-1 * ostatok
                    WHERE
                            1 = 1
                        AND
                            f.c#person_id = c.c#person_id
                        AND
                            f.c#id = c.c#id;

                END IF;

            END IF;

            UPDATE fcr.t#mass_pay f
                SET
                    f.c#ops_id = ops_id
            WHERE
                    1 = 1
                AND
                    f.c#person_id = c.c#person_id
                AND
                    f.c#id = c.c#id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                a#err := 'Error - '
                 || TO_CHAR(sqlcode)
                 || ' - '
                 || sqlerrm;
                INSERT INTO fcr.t#exception (
                    c#name_package,
                    c#name_proc,
                    c#date,
                    c#text,
                    c#comment
                ) VALUES (
                    'PROCEDURE',
                    'DO#DIST_NEGATIVE_BALANCE',
                    SYSDATE,
                    a#err,
                    TO_CHAR(c.c#person_id)
                );

        END;
    END LOOP;

END do#distr_negative_balance_PERS;

/
--------------------------------------------------------
--  DDL for Procedure DO#IN_JOINT_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#IN_JOINT_ACCOUNT" IS

    CURSOR pay IS SELECT
        k.id AS k_id,
        k.pl_sum,
        k.pl_date,
        k.comm,
        fcr.p#mn_utils.get#mn(k.pl_date) AS mn
                  FROM
        fcr.kotel_other_prih k
                  WHERE
        1 = 1
        AND   k.c#ops_id IS NULL
    ORDER BY
        k.pl_date,
        k.id;

    CURSOR nach (
        a#mn IN NUMBER
    ) IS SELECT
        a.c#house_id,
        a.c#b_account_id,
        a.c#service_id,
        a.c#mn,
        nvl(h.h_id,10000000),
        SUM(nvl(a.c_sum,0) - nvl(p_sum,0) ) to_pay,
        CASE
                WHEN SUM(nvl(a.c_sum,0) - nvl(p_sum,0) ) > 0 THEN 1
                ELSE 0
            END
        minus_flg
         FROM
        (
            SELECT
                t.c#house_id,
                t.c#b_account_id,
                t.c#service_id,
                t.c#mn - 1 AS c#mn,
                SUM(tt.c#c_sum) "C_SUM",
                SUM(tt.c#p_sum) "P_SUM"
            FROM
                t#b_store t,
                t#b_storage tt
            WHERE
                1 = 1
                AND   t.c#mn - 1 = a#mn
                AND   t.c#b_account_id = 1 --КОТЕЛ
                AND   tt.c#b_account_id = t.c#b_account_id
                AND   tt.c#service_id = t.c#service_id
                AND   tt.c#house_id = t.c#house_id
                AND   tt.c#mn = (
                    SELECT
                        MAX(c#mn)
                    FROM
                        t#b_storage t1
                    WHERE
                        t1.c#b_account_id = t.c#b_account_id
                        AND   t1.c#service_id = t.c#service_id
                        AND   t1.c#house_id = t.c#house_id
                        AND   t1.c#mn <= t.c#mn
                )
            GROUP BY
                t.c#house_id,
                t.c#b_account_id,
                t.c#service_id,
                t.c#mn - 1
              
     /*     union all
  select
         O.C#HOUSE_ID
     ,O.C#B_ACCOUNT_ID
     ,O.C#SERVICE_ID
     ,P#MN_UTILS.GET#MN(O.C#DATE) "C#MN"
     ,null "C#C_SUM"
     ,SUM(case when O.C#TYPE_TAG = 'P' then O.C#SUM end) "P_SUM"
    from FCR.V#B_OP O
   where 1 = 1
     and O.C#VALID_TAG = 'Y'
     AND O.C#b_ACCOUNT_ID = 1 --КОТЕЛ
     AND P#MN_UTILS.GET#MN(O.C#DATE) = a#MN

     GROUP BY O.C#HOUSE_ID
          ,O.C#B_ACCOUNT_ID
          ,O.C#SERVICE_ID
          ,P#MN_UTILS.GET#MN(O.C#DATE)*/
        ) a,
        (
            SELECT DISTINCT
                h.h_id
            FROM
                fcr1.kotel k,
                fcr2.houses_4 h
            WHERE
                1 = 1
                AND   k.id_house = h.id_house
        ) h
         WHERE
        1 = 1
        AND   a.c#house_id = h.h_id (+)
         GROUP BY
        a.c#house_id,
        a.c#b_account_id,
        a.c#service_id,
        a.c#mn,
        nvl(h.h_id,10000000)
    HAVING
        SUM(nvl(a.c_sum,0) - nvl(p_sum,0) ) <> 0
    ORDER BY
        CASE
            WHEN SUM(nvl(a.c_sum,0) - nvl(p_sum,0) ) > 0 THEN 1
            ELSE 0
        END,
        nvl(h.h_id,10000000);

    kind_id   NUMBER;
--A#DATE date;
    ops_id    NUMBER;
    op_id     NUMBER;
    ostatok   NUMBER;
    a#err     VARCHAR2(4000);
--FLG_MN number;
BEGIN
--        RAISE_APPLICATION_ERROR(-20002,'Отключено');

    RETURN;
--A#DATE := sysdate;
--A_MN := fcr.p#mn_utils.GET#MN(to_date('30.11.2015','dd.mm.yyyy'));
--FLG_MN := fcr.p#mn_utils.GET#MN(to_date('01.07.2014','dd.mm.yyyy')); --флаг для расчета сальдо
    FOR c IN pay LOOP
        BEGIN
            SELECT
                ok.c#id
            INTO
                kind_id
            FROM
                fcr.t#b_ops_kind ok
            WHERE
                ok.c#id = 1;

            INSERT INTO fcr.t#b_ops ( c#id ) VALUES ( fcr.s#b_ops.nextval ) RETURNING c#id INTO ops_id;

--dbms_output.put_line('ops_id = '||ops_id);

            INSERT INTO t#b_ops_vd (
                c#id,
                c#vn,
                c#valid_tag,
                c#kind_id,
                c#note_text
            ) VALUES (
                ops_id,
                1,
                'Y',
                kind_id,
                c.comm
            );

            ostatok := c.pl_sum;
/* if flg_mn < c.mn then

        for A#MN in flg_mn..c.mn+1--181..181--162..179
         loop
          dbms_stats.gather_schema_stats(ownname => 'FCR', cascade => true, options => 'GATHER AUTO');
          for CR#I in
           (
            select T.C#ID from T#HOUSE T
        --     where rownum < 10001
        --     where not exists (select 1 from T#STORE S where S.C#ACCOUNT_ID = T.C#ID)
             order by 1
           )
          loop
        --   DO#CALC_CHARGE(CR#I.C#ID, A#MN, A#MN, A#MN);
        --   DO#CALC_STORE(CR#I.C#ID, A#MN);
           DO#CALC_B_STORE(CR#I.C#ID, A#MN);
           commit;
          end loop;
         end loop;
flg_mn := c.mn;
end if;*/
            IF
                ostatok <> 0
            THEN

--dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);
                FOR d IN nach(c.mn) LOOP
                    IF
                        ostatok <> 0
                    THEN

--dbms_output.put_line('Помесячный платеж = '||d.to_pay|| '  период ' ||fcr.p#mn_utils.GET#DATE(d.c#a_mn));
                        IF
                            d.to_pay < ostatok
                        THEN
                            INSERT INTO fcr.t#b_op (
                                c#id,
                                c#ops_id,
                                c#house_id,
                                c#service_id,
                                c#b_account_id,
                                c#date,
                                c#real_date,
                                c#type_tag
                            ) VALUES (
                                fcr.s#b_op.nextval,
                                ops_id,
                                d.c#house_id,
                                d.c#service_id,
                                d.c#b_account_id,
                                c.pl_date,
                                c.pl_date,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#b_op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                d.to_pay
                            );

                            ostatok := ostatok - d.to_pay;
                        ELSE
                            INSERT INTO fcr.t#b_op (
                                c#id,
                                c#ops_id,
                                c#house_id,
                                c#service_id,
                                c#b_account_id,
                                c#date,
                                c#real_date,
                                c#type_tag
                            ) VALUES (
                                fcr.s#b_op.nextval,
                                ops_id,
                                d.c#house_id,
                                d.c#service_id,
                                d.c#b_account_id,
                                c.pl_date,
                                c.pl_date,
                                'P'
                            ) RETURNING c#id INTO op_id;

                            INSERT INTO fcr.t#b_op_vd (
                                c#id,
                                c#vn,
                                c#valid_tag,
                                c#sum
                            ) VALUES (
                                op_id,
                                1,
                                'Y',
                                ostatok
                            );

                            ostatok := 0;
                        END IF;
                    END IF;

                    COMMIT;
                END LOOP;
            END IF;

            dbms_output.put_line('Остаток после перераспределения  = '
            || ostatok);
            UPDATE fcr.kotel_other_prih ff
                SET
                    ff.c#ops_id = ops_id,
                    ff.c#ostatok = ostatok
            WHERE
                1 = 1
                AND   ff.id = c.k_id;

            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                a#err := 'Error - '
                || TO_CHAR(sqlcode)
                || ' - '
                || sqlerrm;
                INSERT INTO fcr.t#exception (
                    c#name_package,
                    c#name_proc,
                    c#date,
                    c#text,
                    c#comment
                ) VALUES (
                    'PROCEDURE',
                    'DO#IN_JOINT_ACCOUNT',
                    SYSDATE,
                    a#err,
                    TO_CHAR(c.k_id)
                    || ' - '
                    || TO_CHAR(ops_id)
                );

                dbms_output.put(a#err);
        END;
    END LOOP;
END do#in_joint_account;

/
--------------------------------------------------------
--  DDL for Procedure DO#IN_SPECIAL_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#IN_SPECIAL_ACCOUNT" IS

    CURSOR pay IS SELECT
                      k.c#ops_id,
                      k.id_house,
                      k.pay,
                      k.dt_pay,
                      k.c#id,
                      b.c#house_id,
                      b.c#service_id,
                      b.c#b_account_id,
                      'Приход по дому '
                      || k.id_house
                      || ' ('
                      || k.c#comment
                      || ')'                          AS comm,
                      fcr.p#mn_utils.get#mn(k.dt_pay) AS mn
                  FROM
                      fcr.spec_prihod k,
                      fcr.t#house h,
                      fcr.v#banking b
                  WHERE
                      1 = 1
                      AND h.c#id = k.id_house
                      AND b.c#house_id = h.c#id
                      AND b.c#b_account_id <> 1
                      AND k.c#ops_id IS NULL
                  ORDER BY
                      k.dt_pay,
                      k.c#id;

    kind_id NUMBER;
    --A#DATE date;
    ops_id  NUMBER;
    op_id   NUMBER;
    a#err   VARCHAR2(4000);
    BEGIN

--        RAISE_APPLICATION_ERROR(-20002,'Отключено');
        RETURN;
        

        EXECUTE IMMEDIATE 'ALTER TRIGGER TR#B_OP_VD#WARD DISABLE';

        --A#DATE := sysdate;
        FOR c IN pay LOOP
            BEGIN
                SELECT ok.c#id
                INTO
                    kind_id
                FROM
                    fcr.t#b_ops_kind ok
                WHERE
                    ok.c#id = 3;

                INSERT INTO fcr.t#b_ops (c#id) VALUES (fcr.s#b_ops.nextval)
                RETURNING c#id INTO ops_id;


                INSERT INTO t#b_ops_vd (
                    c#id,
                    c#vn,
                    c#valid_tag,
                    c#kind_id,
                    c#note_text
                ) VALUES (
                    ops_id,
                    1,
                    'Y',
                    kind_id,
                    c.comm
                );

                INSERT INTO fcr.t#b_op (
                    c#id,
                    c#ops_id,
                    c#house_id,
                    c#service_id,
                    c#b_account_id,
                    c#date,
                    c#real_date,
                    c#type_tag
                ) VALUES (
                    fcr.s#b_op.nextval,
                    ops_id,
                    c.c#house_id,
                    c.c#service_id,
                    c.c#b_account_id,
                    c.dt_pay,
                    c.dt_pay,
                    'P'
                )
                RETURNING c#id INTO op_id;


                INSERT INTO fcr.t#b_op_vd (
                    c#id,
                    c#vn,
                    c#valid_tag,
                    c#sum
                ) VALUES (
                    op_id,
                    1,
                    'Y',
                    c.pay
                );

                UPDATE fcr.spec_prihod ff
                SET
                    ff.c#ops_id = ops_id
                WHERE
                    1 = 1
                    AND ff.c#id = c.c#id
                    AND ff.id_house = c.id_house;

                COMMIT;
                EXCEPTION
                WHEN OTHERS THEN
                ROLLBACK;
                a#err := 'Error - '
                         || TO_CHAR(sqlcode)
                         || ' - '
                         || sqlerrm;
                INSERT INTO fcr.t#exception (
                    c#name_package,
                    c#name_proc,
                    c#date,
                    c#text,
                    c#comment
                ) VALUES (
                    'PROCEDURE',
                    'DO#IN_SPECIAL_ACCOUNT',
                    SYSDATE,
                    a#err,
                    TO_CHAR(c.id_house)
                );
                DBMS_OUTPUT.PUT_LINE(a#err);

            END;
        END LOOP;
        EXECUTE IMMEDIATE 'ALTER TRIGGER TR#B_OP_VD#WARD ENABLE';
    END do#in_special_account;

/
--------------------------------------------------------
--  DDL for Procedure DO#PAY_SOURCE_RKC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#PAY_SOURCE_RKC" 
(
  a#rkc  number,
  a#date date 
)
AS 

-- TYPE type_rkc is VARRAY(4) OF number;

cursor upload(p#date date, p#rkc number) is
select f.c#id
      ,t.c#id account_id
      ,t.c#date
      ,t.c#end_date
      ,t.C#LIVING_TAG
      ,t.C#OWN_TYPE_TAG
      ,t.c#area_val
      ,t.oa.f#house_id house_id
      ,t.oa.f#person_id person_id
      ,t.c#out_num out_account_num
      ,t.oa.f#num account_num
      ,p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path -- rooms_addr(t.oa.f#rooms_id) address
      ,t.c#house_num
      ,t.c#flat_num
      ,t.room_id
      , p#utils.get#person_name(t.oa.f#person_id) person
      , (select max('Счет юр лица')
           from fcr.t#person_j p
          where p.c#person_id = t.oa.f#person_id
        ) as URFIZ
     ,c#out_proc_id
     ,c#code     
     ,f.c#real_date, f.c#summa, f.c#account, f.c#period, f.c#cod_rkc, f.c#file_id, ok.c#name, ok.c#cod
  from 
(
select a.C#ID
      ,rs.C#LIVING_TAG, rs.C#OWN_TYPE_TAG, rs.C#AREA_VAL, a.c#num
      ,p#utils.get_obj#account(op.c#account_id, sysdate) oa
      ,h.c#addr_obj_id
      ,a.c#date
      ,a.C#END_DATE
      ,h.c#num || rtrim('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num
      ,r.c#id as room_id
      ,r.c#flat_num
      ,op.c#out_num
      ,op.c#out_proc_id
      ,oo.c#code
  from fcr.t#account_op op,
       fcr.v#account a,
       fcr.v#rooms_spec rs,
       fcr.t#rooms r, 
       fcr.t#house h,
       fcr.t#out_proc oo
 where op.c#date = (select max(o.c#date)
                      from fcr.t#account_op o
                     where 1 = 1
                       and o.c#account_id = op.c#account_id
                       and o.c#date < p#date
                   )
   and a.c#id = op.c#account_id
   and a.c#date = (select max(a1.c#date)
                      from fcr.v#account a1
                     where 1 = 1
                       and a1.c#id = a.c#id
                       and a1.c#date < p#date
                       and a1.C#VALID_TAG = 'Y'
                   )
   and op.c#out_proc_id in (p#rkc)
   and oo.c#id = op.c#out_proc_id
   
   
   and rs.C#ROOMS_ID = a.c#rooms_id
   and rs.C#VALID_TAG = 'Y'
   and a.C#VALID_TAG = 'Y'
   and r.c#id = rs.C#ROOMS_ID
   and r.c#house_id = h.c#id   
   and rs.C#DATE =  (
                     select max(rs1.C#DATE)
                       from fcr.v#rooms_spec rs1
                      where rs1.C#ROOMS_ID = rs.C#ROOMS_ID
                        and rs1.C#DATE < p#date
                    )
) t,
fcr.t#pay_source f,
fcr.t#ops_kind ok                
where coalesce(f.c#acc_id, f.c#acc_id_close, f.c#acc_id_tter) = t.c#id
  and to_char(t.c#code,'00') <> to_char(f.c#cod_rkc,'00')
  and f.c#kind_id = ok.c#id
  and ok.c#cod <> '88'
  and f.c#upload_flg is null
;
-- a#rkc type_rkc;
BEGIN

--   a#rkc := type_rkc(1,2,8,9);
--   for i in 1..4 loop 
--     DBMS_OUTPUT.PUT_LINE(a#rkc(i));
      for c in upload(a#date,a#rkc) loop
         update fcr.t#pay_source ff
           set ff.c#upload_flg = a#rkc
         where ff.c#id = c.c#id;
      end loop;
--   end loop; 

END DO#PAY_SOURCE_RKC;

/
--------------------------------------------------------
--  DDL for Procedure DO#RECALC_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_ACCOUNT" 
(
    A#ACCOUNT_NUM IN VARCHAR2,
	A#DATE IN DATE,
    A#ACC_ID NUMBER DEFAULT NULL
)  
AS 
  A#N_MN integer;
  A#MN integer;
  A#ACCOUNT_ID integer;  
	a#err varchar2(4000);
begin

   select fcr.p#utils.GET#OPEN_MN into A#MN from DUAL;
   select fcr.p#mn_utils.GET#MN(a#date) into A#N_MN from DUAL;

   if A#ACC_ID is null then
    select c#id into a#ACCOUNT_ID from fcr.t#account where c#num = a#account_num; 
   else
    a#ACCOUNT_ID := A#ACC_ID;
   end if;
	 
   execute immediate 'alter trigger TR#CHARGE#WARD disable';
   execute immediate 'alter trigger TR#STORAGE#WARD disable';
   execute immediate 'alter trigger TR#STORE#WARD disable';
   
--   FCR1

    delete from T#CHARGE where C#ACCOUNT_ID = A#ACCOUNT_ID and c#A_MN >= A#N_MN-1;
    delete from T#STORAGE where C#ACCOUNT_ID = A#ACCOUNT_ID and c#MN >= A#N_MN;
    commit;

         for a#open_mn in A#N_MN-1 .. A#MN
               loop
--                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,0);
                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,1);
--                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,2);
--                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,3);
--                  commit;
               end loop;


--   fcr.p#fcr.do#calc_account(sysdate,A#ACCOUNT_ID,3); -- дата похер какая, т.к. внутри все равно используется цикл по всем MN
--   commit;
               
   execute immediate 'alter trigger TR#STORE#WARD enable';               
   execute immediate 'alter trigger TR#STORAGE#WARD enable';							 
   execute immediate 'alter trigger TR#CHARGE#WARD enable';							 
   
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
		 P#EXCEPTION.LOG#EXCEPTION('PROCEDURE','DO#RECALC_ACCOUNT',a#err,to_char(a#account_num));
    DBMS_OUTPUT.PUT_LINE(a#err);
END DO#RECALC_ACCOUNT;

/
--------------------------------------------------------
--  DDL for Procedure DO#RECALC_BANK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_BANK" 
(
	A#DATE IN DATE
)  
AS 
  A#N_MN integer;
  A#MN integer;
	a#err varchar2(4000);
begin
   select fcr.p#utils.GET#OPEN_B_MN into A#MN from DUAL;
   select fcr.p#mn_utils.GET#MN(a#date) into A#N_MN from DUAL;
	 
   execute immediate 'alter trigger TR#B_STORAGE#WARD disable';
   execute immediate 'alter trigger TR#B_STORE#WARD disable';
	 
   for a#open_mn in A#N_MN-1 .. A#MN
   loop
    for cr#i in (select t.c#id from t#house t order by 1)
    loop
       fcr.do#calc_b_store(cr#i.c#id, a#open_mn);
    end loop;
	 end loop;
	 	
   execute immediate 'alter trigger TR#B_STORE#WARD enable';               
   execute immediate 'alter trigger TR#B_STORAGE#WARD enable';							 

 commit;
   
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#RECALC_BANK',sysdate,a#err,'');
END DO#RECALC_BANK;

/
--------------------------------------------------------
--  DDL for Procedure DO#RECALC_CHARGE_BY_PERSONID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_CHARGE_BY_PERSONID" (P_PERSON_ID IN NUMBER) AS 
BEGIN
-- пересчитываем начисления по всем счетам принадлежащим юрику сейчас
    FOR rec IN (
        select distinct C#ACC_NUM from v#acc_last2 where C#PERSON_ID = P_PERSON_ID
    )            
    LOOP
        BEGIN
            FCR.DO#RECALC_ACCOUNT(rec.C#ACC_NUM, to_date('01.06.2014','dd.mm.yyyy')); 
        END;        
    END LOOP;
END DO#RECALC_CHARGE_BY_PERSONID;

/
--------------------------------------------------------
--  DDL for Procedure DO#RECALC_MASS_PAY_BY_PERSONID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_MASS_PAY_BY_PERSONID" (
    P_PERSON_ID IN NUMBER, 
    P_DO_CHARGE_RECALC IN VARCHAR2 DEFAULT 'N',
    P_DO_PAY_RECALC IN VARCHAR2 DEFAULT 'N'
    ) AS 
BEGIN

    EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD disable';
    EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD disable';

-- удаляем все опы от счетов принадлежавших юрику сейчас
    delete from t#op where C#ID in ( 
        SELECT O.C#ID
        FROM
            V#ACC_LAST2 L
            JOIN V#OP O ON (L.C#ACCOUNT_ID = O.C#ACCOUNT_ID)
        WHERE
            C#PERSON_ID = P_PERSON_ID
    );

    COMMIT;

    EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD enable';
    EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD enable';

-- удаляем все записи в MASS_PAY кроме первоисточников (опы от них удаляются каскадом)
    delete from T#MASS_PAY where C#PERSON_ID = P_PERSON_ID and c#id not in (
    select c#ID from T#MASS_PAY WHERE C#PARENT_ID is null and C#COD_RKC = 90 and C#PERSON_ID = P_PERSON_ID);
    
    delete from T#MASS_PAY where C#PERSON_ID = P_PERSON_ID and LOWER(C#COMMENT) like '%выравнивание%'; 
    delete from T#MASS_PAY where C#PERSON_ID = P_PERSON_ID and LOWER(C#COMMENT) like '%сторн%'; 

-- удаляем ошибочно заведенные на юрике внешние счета других РКЦ
    delete from T#ACCOUNT_OP where C#ID in (
        SELECT C#ID
        FROM T#ACCOUNT_OP
        WHERE
            C#ACCOUNT_ID IN (SELECT C#ACCOUNT_ID
                             FROM V#ACC_LAST2
                             WHERE C#PERSON_ID = P_PERSON_ID)
            AND C#OUT_PROC_ID <> 10
    )
    ;

-- оставшиеся записи MASS_PAY (первоисточники) помечаем как неразнесенные
    update T#MASS_PAY set C#REMOVE_FLG = null, С#OSTATOK = 0, C#OPS_ID = null WHERE C#PERSON_ID = P_PERSON_ID;

-- все заиси в PAY_SOURCE, имеющие в настоящее время отношение к нынешним счетам юрика, помечаем как неразнесенные
    update T#PAY_SOURCE 
    set C#ACC_ID = null,C#ACC_ID_CLOSE = null, C#ACC_ID_TTER = null, C#OPS_ID = null
    where COALESCE(C#ACC_ID,C#ACC_ID_CLOSE,C#ACC_ID_TTER) in 
    (SELECT C#ACCOUNT_ID FROM V#ACC_LAST2  where C#PERSON_ID = P_PERSON_ID);

    COMMIT;
   
    
-- пересчитываем начисления по всем счетам принадлежащим юрику сейчас
    IF P_DO_CHARGE_RECALC = 'Y' THEN
        DO#RECALC_CHARGE_BY_PERSONID(P_PERSON_ID);
        COMMIT;
    END IF;    

-- разносим платежи по юрику заново
    IF P_DO_PAY_RECALC = 'Y' THEN
        DO#3BYPERSONID(P_PERSON_ID);
        COMMIT;
    END IF;    
END DO#RECALC_MASS_PAY_BY_PERSONID;

/
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
--------------------------------------------------------
--  DDL for Procedure DO#ROLLBACK_LOAD_OUTER_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#ROLLBACK_LOAD_OUTER_DATA" 
(
  A#FILE_ID IN NUMBER 
) AS 
BEGIN
  delete from fcr.t#pay_source where c#file_id = A#FILE_ID;
  delete from fcr.t#file_pay where c#id = A#FILE_ID;
  COMMIT;
END DO#ROLLBACK_LOAD_OUTER_DATA;

/
--------------------------------------------------------
--  DDL for Procedure DO#STORNO_M
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#STORNO_M" AS
BEGIN
	do#2;
  DO#2_1;
  DO#3;
END DO#STORNO_M;

/
--------------------------------------------------------
--  DDL for Procedure STORNO#UL#PAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."STORNO#UL#PAY" (A#acc_id in number, A#date in date) is

cursor storno is
select b.*
  from
(
select a.c#ops_id, a.c#account_id, a.c#date, a.c#sum,
sum(a.c#sum) over (partition by a.C#ACCOUNT_ID) as sum_all
  from
(
select o.C#OPS_ID, o.C#ACCOUNT_ID, o.C#DATE, sum(o.C#SUM) as C#SUM
  from fcr.v#op o,
       fcr.v#ops op
 where o.C#ACCOUNT_ID = A#acc_id--532
   and o.C#OPS_ID = op.C#ID
   and op.C#KIND_ID in (32, 118)  -- c#cod in (90,91)
   and o.C#VALID_TAG = 'Y'
   and op.C#VALID_TAG = 'Y'
 group by o.C#OPS_ID, o.C#ACCOUNT_ID, o.C#DATE
) a
) b
where b.sum_all <> 0 and b.c#sum <> 0
;

cursor storno_pay(ops_id in number, acc_id in number) is

select o.C#ACCOUNT_ID, o.C#WORK_ID, o.C#DOER_ID, A#date as c#date, o.C#REAL_DATE,
       o.C#A_MN, o.C#B_MN, o.C#TYPE_TAG, o.C#SUM
  from fcr.v#op o
 where o.C#OPS_ID = ops_id
   and o.C#VALID_TAG = 'Y'
   and o.C#ACCOUNT_ID = acc_id;
   ops_id number;
   op_id number;
   kind_id number;
   mp_id number;
   old_mp_id number;
   person_id number;
   a#err varchar2(4000);
begin
for c in storno loop
begin
  select fcr.s#mass_pay.nextval into mp_id
    from dual;

    select max(m.c#id), max(m.c#person_id) into old_mp_id, person_id
      from fcr.t#mass_pay m
     where m.c#ops_id = c.C#OPS_ID;

   insert into fcr.t#ops(c#id)
    values(fcr.s#ops.nextval)
    returning c#id into ops_id;
    
--dbms_output.put_line('ops_id : '|| c.C#OPS_ID);
--dbms_output.put_line('Person_id : '|| person_id);


insert into fcr.t#mass_pay(c#id, c#person_id, c#sum, c#date, c#living_tag, c#ops_id, с#ostatok, c#parent_id, c#npd, c#cod_rkc, c#comment, c#remove_flg, c#acc_id, c#storno_flg)
values(mp_id, person_id, -1*c.c#sum, c.c#date, null, ops_id, null, old_mp_id, '', 91, '', null, c.C#ACCOUNT_ID, 'Y');


select ok.c#id into kind_id
  from fcr.t#ops_kind ok
 where ok.c#cod  = '91';

    insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
    values(ops_id, 1, 'Y', kind_id);


    for d in storno_pay(c.c#ops_id, c.C#ACCOUNT_ID) loop

         insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
         values(fcr.s#op.nextval, ops_id, d.C#ACCOUNT_ID, d.c#work_id, d.c#doer_id, d.c#date, d.C#REAL_DATE, d.c#a_mn, d.c#b_mn, d.C#TYPE_TAG)
         returning c#id into op_id;

         insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
         values(op_id, 1, 'Y', -1*d.C#SUM);

    end loop;
    

commit;
	exception
   when OTHERS then
        rollback;
    a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
--         insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment)
         P#EXCEPTION.LOG#EXCEPTION('PROCEDURE','storno#ul#pay',a#err,to_char(c.c#account_id));
  end;
end loop;

end storno#ul#pay;

/
--------------------------------------------------------
--  DDL for Procedure TRANSFER#MANUAL#PAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."TRANSFER#MANUAL#PAY" (A#PS_ID in number, A#DATE in date, A#MN in number) is

cursor pay is
select t.c#id, t.c#acc_id, t.c#summa, t.c#cod_rkc, t.c#real_date, t.c#fine, t.c#period, t.c#date
from fcr.t#pay_source t
where t.c#id = A#PS_ID
and t.c#ops_id is null
order by 2,5, 1
;

cursor nach(ls in number) is
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN, A.TO_PAY
from 
(
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN,SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) TO_PAY
  from fcr.v#chop  a where a.C#A_MN <= A#MN
  and a.C#ACCOUNT_ID = ls
GROUP BY A.C#A_MN, A.C#B_MN, A.C#WORK_ID, A.C#DOER_ID
having SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) <> 0
) A
order by case when a.to_pay < 0 then 0 else 1 end, a.c#a_mn, a.c#b_mn, a.c#work_id, a.c#doer_id
;

ops_id number;
op_id number;
pay_date date;
w_id number;
w1_id number;
d1_id number;
d_id number;
ostatok number;
per_num number;

kind_id number := 36;

begin
 
for c in pay loop

PAY_DATE := A#DATE;

select ok.c#id into kind_id
  from fcr.t#ops_kind ok
 where ok.c#cod  = trim(to_char(c.c#cod_rkc, '000'));

select max(a.C#WORK_ID), max(a.C#DOER_ID) into w_id, d_id
  from 
(
select WS.C#SERVICE_ID
     -- ,W.C#WORKS_ID
      ,W.C#ID as c#WORK_ID
--      ,W_VD.C#TAR_TYPE_TAG
--      ,W_VD.C#TAR_VAL
      ,D_VD.C#DOER_ID      
      ,row_number() over (partition by D.C#house_Id order by d.c#date desc , nvl(d_vd.c#end_date, to_date('01.01.2222','dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
            from T#DOING D,
                 T#DOING_VD D_VD,
                 T#WORK W,
                 T#WORK_VD W_VD,
                 T#WORKS WS
           where 1 = 1
             and D.C#HOUSE_ID = (select R.C#HOUSE_ID
                                   from T#ACCOUNT A, T#ROOMS R
                                  where A.C#ID = c.c#acc_id 
                                    and R.C#ID = A.C#ROOMS_ID
                                )
             and D.C#DATE = (select max(C#DATE) from T#DOING where C#HOUSE_ID = D.C#HOUSE_ID and C#WORKS_ID = D.C#WORKS_ID and C#DATE <= A#DATE)
             and D_VD.C#ID = D.C#ID
             and D_VD.C#VN = (select max(C#VN) from T#DOING_VD where C#ID = D_VD.C#ID)
             and D_VD.C#VALID_TAG = 'Y'
--             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
             and W.C#WORKS_ID = D.C#WORKS_ID
             and W.C#DATE = (select max(C#DATE) from T#WORK where C#WORKS_ID = W.C#WORKS_ID and C#DATE < A#DATE)
             and W_VD.C#ID = W.C#ID
             and W_VD.C#VN = (select max(C#VN) from T#WORK_VD where C#ID = W_VD.C#ID)
             and W_VD.C#VALID_TAG = 'Y'
             and WS.C#ID = W.C#WORKS_ID             
) a
   where a.sort_order = 1
;
--dbms_output.put_line('w_id = '||w_id);
if w_id is not null then

insert into fcr.t#ops(c#id)
values(fcr.s#ops.nextval)
returning c#id into ops_id;

--dbms_output.put_line('ops_id = '||ops_id);

insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
values(ops_id, 1, 'Y', kind_id);

ostatok := c.c#summa;
if ostatok > 0 then

--dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

  for d in nach(c.c#acc_id) loop
  
  if ostatok > 0 then
  
        if d.to_pay < ostatok then                  
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, c.c#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P')
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', d.to_pay);
           ostatok := ostatok - d.to_pay;
        else 
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, c.c#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P')
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', ostatok);
           ostatok := 0; 
       end if;
  end if;
  end loop;
  
  if ostatok > 0 then --Если остались деньги после всех распределений
--dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = c.c#acc_id
     and ch.C#A_MN = a#mn+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, 'P')
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
  
   end if;

 

else --Отрицательная оплата  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = c.c#acc_id
     and ch.C#A_MN = A#MN+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;  

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, 'P')
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
end if;
 update fcr.t#pay_source f
     set f.c#transfer_flg = 1,
         f.c#ops_id = ops_id,
         f.c#kind_id = kind_id
   where 1 = 1
     and f.c#id = c.c#id;
     
     
  if nvl(c.c#fine,0) <> 0 then --есть пени
    
  per_num := fcr.p#mn_utils.GET#MN(to_date(c.c#period,'mmyy'));
  
  begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = c.c#acc_id
     and ch.C#A_MN = per_num
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;
  
   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FC')
   returning c#id into op_id;
   
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', c.c#fine);
   
   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FP')
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', c.c#fine);
  
  end if;
         
     
  end if;
  end loop; 
  
end TRANSFER#MANUAL#PAY;

/
--------------------------------------------------------
--  DDL for Procedure TRANSFER#PAY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."TRANSFER#PAY" (A#PS_ID in number, A#acc_id in number, A#DATE in date, A#MN in number) is

cursor STORNO is
select t.*
  from fcr.t#pay_source t
 where t.c#id = A#PS_ID;
 
cursor opl(p_id in number) is
select v.C#ACCOUNT_ID, v.C#WORK_ID, v.C#DOER_ID, v.C#DATE, v.C#REAL_DATE, v.C#A_MN, v.C#B_MN, v.C#TYPE_TAG, v.C#SUM
  from v#op v
 where v.C#VALID_TAG = 'Y'
   and v.C#OPS_ID = p_id
;

cursor pay(c#ps_id in number) is
select t.c#id, t.c#acc_id, t.c#summa, t.c#cod_rkc, t.c#real_date, t.c#fine, t.c#period, t.c#date
from fcr.t#pay_source t
where t.c#id = c#ps_id
and t.c#ops_id is null
order by 2,5, 1
;
cursor nach(ls in number) is
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN, A.TO_PAY

  from 
(
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN,
       SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) TO_PAY
  from fcr.v#chop  a
where a.C#A_MN <= A#MN
  and a.C#ACCOUNT_ID = ls
GROUP BY A.C#A_MN, A.C#B_MN, A.C#WORK_ID, A.C#DOER_ID
having SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) <> 0
) A
order by case when a.to_pay < 0 then 0 else 1 end, a.c#a_mn, a.c#b_mn, a.c#work_id, a.c#doer_id
;

ACC_NUM  number;
PS_ID number;
ops_id number;
op_id number;
pay_date date;
w_id number;
w1_id number;
d1_id number;
d_id number;
ostatok number;
per_num number;


kind_id number := 36;


begin
  select a.c#num into ACC_NUM
    from fcr.t#account a
   where a.c#id = A#ACC_ID;
   
  for c in STORNO loop  --Снимаем оплаты со старого ЛС
    insert into fcr.t#pay_source(c#account, c#real_date, c#summa, c#fine, c#period, c#cod_rkc, c#pay_num, c#file_id, c#transfer_flg,
                                 c#acc_id, c#acc_id_close, c#acc_id_tter, c#ops_id, c#kind_id,  c#upload_flg, c#storno_id,c#date, c#comment)
    values(c.c#account, c.c#real_date, -1*c.c#summa, -1*c.c#fine, c.c#period, c.c#cod_rkc, c.c#pay_num, 1, c.c#transfer_flg,
                                 c.c#acc_id, c.c#acc_id_close, c.c#acc_id_tter, c.c#ops_id, c.c#kind_id,  null, c.c#id, A#DATE, sysdate||' на счет '||ACC_NUM);
                                 
    insert into fcr.t#pay_source(c#account, c#real_date, c#summa, c#fine, c#period, c#cod_rkc, c#pay_num, c#file_id, c#transfer_flg,
                                 c#acc_id, c#acc_id_close, c#acc_id_tter, c#ops_id, c#kind_id,  c#upload_flg, c#storno_id, c#date, c#comment)
    values(ACC_NUM, c.c#real_date, c.c#summa, c.c#fine, c.c#period, c.c#cod_rkc, c.c#pay_num, 1, c.c#transfer_flg,
                                 A#ACC_ID, null, null, null, null,  null, null, A#DATE, sysdate||' со счета '||c.c#account)
    returning c#id into PS_ID;

    insert into fcr.t#ops(c#id)
    values(fcr.s#ops.nextval)
    returning c#id into ops_id;

    insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
    values(ops_id, 1, 'Y', kind_id);
 
      for d in opl(c.c#ops_id) loop
         insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
         values(fcr.s#op.nextval, ops_id, d.C#ACCOUNT_ID, d.c#work_id, d.c#doer_id, A#DATE, d.C#REAL_DATE, d.c#a_mn, d.c#b_mn, d.C#TYPE_TAG)
         returning c#id into op_id;
                 
         insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
         values(op_id, 1, 'Y', -1*d.C#SUM);           
      end loop;                           
  end loop;--Снимаем оплаты со старого ЛС
 
for c in pay(ps_id) loop

 PAY_DATE := A#DATE;
select ok.c#id into kind_id
  from fcr.t#ops_kind ok
 where ok.c#cod  = trim(to_char(c.c#cod_rkc, '00'));

select max(a.C#WORK_ID), max(a.C#DOER_ID) into w_id, d_id
  from 
(
select WS.C#SERVICE_ID
     -- ,W.C#WORKS_ID
      ,W.C#ID as c#WORK_ID
--      ,W_VD.C#TAR_TYPE_TAG
--      ,W_VD.C#TAR_VAL
      ,D_VD.C#DOER_ID      
      ,row_number() over (partition by D.C#house_Id order by d.c#date desc , nvl(d_vd.c#end_date, to_date('01.01.2222','dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
            from T#DOING D,
                 T#DOING_VD D_VD,
                 T#WORK W,
                 T#WORK_VD W_VD,
                 T#WORKS WS
           where 1 = 1
             and D.C#HOUSE_ID = (select R.C#HOUSE_ID
                                   from T#ACCOUNT A, T#ROOMS R
                                  where A.C#ID = c.c#acc_id 
                                    and R.C#ID = A.C#ROOMS_ID
                                )
             and D.C#DATE = (select max(C#DATE) from T#DOING where C#HOUSE_ID = D.C#HOUSE_ID and C#WORKS_ID = D.C#WORKS_ID and C#DATE <= A#DATE)
             and D_VD.C#ID = D.C#ID
             and D_VD.C#VN = (select max(C#VN) from T#DOING_VD where C#ID = D_VD.C#ID)
             and D_VD.C#VALID_TAG = 'Y'
--             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
             and W.C#WORKS_ID = D.C#WORKS_ID
             and W.C#DATE = (select max(C#DATE) from T#WORK where C#WORKS_ID = W.C#WORKS_ID and C#DATE < A#DATE)
             and W_VD.C#ID = W.C#ID
             and W_VD.C#VN = (select max(C#VN) from T#WORK_VD where C#ID = W_VD.C#ID)
             and W_VD.C#VALID_TAG = 'Y'
             and WS.C#ID = W.C#WORKS_ID             
) a
   where a.sort_order = 1
;
--dbms_output.put_line('w_id = '||w_id);
if w_id is not null then

insert into fcr.t#ops(c#id)
values(fcr.s#ops.nextval)
returning c#id into ops_id;

--dbms_output.put_line('ops_id = '||ops_id);

insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
values(ops_id, 1, 'Y', kind_id);

ostatok := c.c#summa;
if ostatok > 0 then

--dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

  for d in nach(c.c#acc_id) loop
  
  if ostatok > 0 then
  
        if d.to_pay < ostatok then                  
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, c.c#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P')
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', d.to_pay);
           ostatok := ostatok - d.to_pay;
        else 
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, c.c#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P')
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', ostatok);
           ostatok := 0; 
       end if;
  end if;
  end loop;
  
  if ostatok > 0 then --Если остались деньги после всех распределений
--dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = c.c#acc_id
     and ch.C#A_MN = a#mn+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, 'P')
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
  
   end if;

 

else --Отрицательная оплата  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = c.c#acc_id
     and ch.C#A_MN = A#MN+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;  

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, 'P')
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
end if;
 update fcr.t#pay_source f
     set f.c#transfer_flg = 1,
         f.c#ops_id = ops_id,
         f.c#kind_id = kind_id
   where 1 = 1
     and f.c#id = c.c#id;
     
     
  if nvl(c.c#fine,0) <> 0 then --есть пени
    
  per_num := fcr.p#mn_utils.GET#MN(to_date(c.c#period,'mmyy'));
  
  begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = c.c#acc_id
     and ch.C#A_MN = per_num
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;
  
  insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FC')
   returning c#id into op_id;
   
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', c.c#fine);
   
   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, c.c#acc_id, w1_id, d1_id, pay_date, c.c#real_date, per_num, per_num, 'FP')
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', c.c#fine);
  
  end if;
         
     
  end if;
  end loop; 
  
end TRANSFER#PAY;

/
--------------------------------------------------------
--  DDL for Procedure TRANSFER#PAY_OTHER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."TRANSFER#PAY_OTHER" (A#OP_ID in number, A#acc_id in number, A#DATE in date, A#MN in number) is

 
cursor opl is
select v.C#ACCOUNT_ID, v.C#WORK_ID, v.C#DOER_ID, v.C#DATE, v.C#REAL_DATE, v.C#A_MN, v.C#B_MN, v.C#TYPE_TAG, v.C#SUM
  from v#op v
 where v.C#VALID_TAG = 'Y'
   and v.C#ID = A#OP_ID
;

cursor nach(ls in number) is
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN, A.TO_PAY

  from 
(
select A.C#WORK_ID, A.C#DOER_ID, A.C#A_MN, A.C#B_MN,
       SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) TO_PAY
  from fcr.v#chop  a
where a.C#A_MN <= A#MN
  and a.C#ACCOUNT_ID = ls
GROUP BY A.C#A_MN, A.C#B_MN, A.C#WORK_ID, A.C#DOER_ID
having SUM(nvl(A.C#C_SUM,0)+nvl(A.C#MC_SUM,0)+nvl(A.C#M_SUM,0)-nvl(A.C#MP_SUM,0)-nvl(C#P_SUM,0)) <> 0
) A
order by case when a.to_pay < 0 then 0 else 1 end, a.c#a_mn, a.c#b_mn, a.c#work_id, a.c#doer_id
;

ops_id number;
op_id number;
pay_date date;
w_id number;
w1_id number;
d1_id number;
d_id number;
ostatok number;


kind_id number := 36;


begin
    insert into fcr.t#ops(c#id)
    values(fcr.s#ops.nextval)
    returning c#id into ops_id;

    insert into t#ops_vd(c#id, c#vn, c#valid_tag, c#kind_id)
    values(ops_id, 1, 'Y', kind_id);
 
      for c in opl loop
         insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
         values(fcr.s#op.nextval, ops_id, c.C#ACCOUNT_ID, c.c#work_id, c.c#doer_id, A#DATE, c.C#REAL_DATE, c.c#a_mn, c.c#b_mn, c.C#TYPE_TAG)
         returning c#id into op_id;
                 
         insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
         values(op_id, 1, 'Y', -1*c.C#SUM);          

         PAY_DATE := A#DATE;

select max(a.C#WORK_ID), max(a.C#DOER_ID) into w_id, d_id
  from 
(
select WS.C#SERVICE_ID
     -- ,W.C#WORKS_ID
      ,W.C#ID as c#WORK_ID
--      ,W_VD.C#TAR_TYPE_TAG
--      ,W_VD.C#TAR_VAL
      ,D_VD.C#DOER_ID      
      ,row_number() over (partition by D.C#house_Id order by d.c#date desc , nvl(d_vd.c#end_date, to_date('01.01.2222','dd.mm.yyyy')), d.c#works_id, d_vd.c#doer_id) sort_order
            from T#DOING D,
                 T#DOING_VD D_VD,
                 T#WORK W,
                 T#WORK_VD W_VD,
                 T#WORKS WS
           where 1 = 1
             and D.C#HOUSE_ID = (select R.C#HOUSE_ID
                                   from T#ACCOUNT A, T#ROOMS R
                                  where A.C#ID =a#acc_id 
                                    and R.C#ID = A.C#ROOMS_ID
                                )
             and D.C#DATE = (select max(C#DATE) from T#DOING where C#HOUSE_ID = D.C#HOUSE_ID and C#WORKS_ID = D.C#WORKS_ID and C#DATE <= A#DATE)
             and D_VD.C#ID = D.C#ID
             and D_VD.C#VN = (select max(C#VN) from T#DOING_VD where C#ID = D_VD.C#ID)
             and D_VD.C#VALID_TAG = 'Y'
--             and (D_VD.C#END_DATE is null or D_VD.C#END_DATE > greatest(D.C#DATE,A#M_DATE + A#M_DATE_OFFSET))
             and W.C#WORKS_ID = D.C#WORKS_ID
             and W.C#DATE = (select max(C#DATE) from T#WORK where C#WORKS_ID = W.C#WORKS_ID and C#DATE < A#DATE)
             and W_VD.C#ID = W.C#ID
             and W_VD.C#VN = (select max(C#VN) from T#WORK_VD where C#ID = W_VD.C#ID)
             and W_VD.C#VALID_TAG = 'Y'
             and WS.C#ID = W.C#WORKS_ID             
) a
   where a.sort_order = 1
;
--dbms_output.put_line('w_id = '||w_id);
if w_id is not null then

--dbms_output.put_line('ops_id = '||ops_id);

ostatok := c.c#sum;
if ostatok > 0 then

--dbms_output.put_line('Сумма для распределения = '||ostatok|| 'дата = '||c.data_pl);

  for d in nach(c.c#account_id) loop
  
  if ostatok > 0 then
  
        if d.to_pay < ostatok then                  
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, a#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, 'P')
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', d.to_pay);
           ostatok := ostatok - d.to_pay;
        else 
           insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
           values(fcr.s#op.nextval, ops_id, a#acc_id, d.c#work_id, d.c#doer_id, pay_date, c.c#real_date, d.c#a_mn, d.c#b_mn, c.c#type_tag)
           returning c#id into op_id;
           
           insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
           values(op_id, 1, 'Y', ostatok);
           ostatok := 0; 
       end if;
  end if;
  end loop;
  
  if ostatok > 0 then --Если остались деньги после всех распределений
--dbms_output.put_line('Остаток после всех распределений = '||ostatok);  
  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = a#acc_id
     and ch.C#A_MN = a#mn+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, a#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, c.c#type_tag)
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
  
   end if;

 

else --Отрицательная оплата  

begin 
   select c#work_id, c#doer_id into w1_id, d1_id
   from 
 (  
 select ch.C#WORK_ID, ch.C#DOER_ID,
        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order

 
    from fcr.v#chop ch
   where ch.C#ACCOUNT_ID = a#acc_id
     and ch.C#A_MN = A#MN+1
     and (ch.C#C_SUM is not null or ch.C#P_SUM is not null)
 )
 where sort_order = 1
;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
                     BEGIN
                     w1_id := w_id;
                     d1_id := d_id;
                     END;
end;  

   insert into fcr.t#op(c#id, c#ops_id, c#account_id, c#work_id, c#doer_id, c#date, c#real_date, c#a_mn, c#b_mn, c#type_tag)
   values(fcr.s#op.nextval, ops_id, a#acc_id, w1_id, d1_id, pay_date, c.c#real_date, a#mn+1, a#mn+1, c.c#type_tag)
   returning c#id into op_id;
           
   insert into fcr.t#op_vd(c#id, c#vn, c#valid_tag, c#sum)
   values(op_id, 1, 'Y', ostatok);
end if;
end if;
  end loop; 
  
end TRANSFER#PAY_OTHER;

/
--------------------------------------------------------
--  DDL for Procedure UPD#ACCOUNT_DATE_BEGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#ACCOUNT_DATE_BEGIN" 
(
  A#NUM IN VARCHAR2 DEFAULT 15 
, A#DATE IN VARCHAR2 DEFAULT 10 
) AS 
BEGIN

insert into tt#tr_flag (c#val) values ('ACCOUNT#PASS_MOD');
insert into tt#tr_flag (c#val) values ('ACCOUNT_SPEC#PASS_MOD');
update (select * from fcr.t#account where c#num= a#num )
set c#date = to_date(a#date,'dd.mm.yyyy');
update (select * from fcr.t#account_spec where c#account_id = (select c#id from fcr.t#account where c#num= a#num) )
set c#date = to_date(a#date,'dd.mm.yyyy');
commit;

DO#RECALC_ACCOUNT( A#NUM, A#DATE);

END UPD#ACCOUNT_DATE_BEGIN;

/
--------------------------------------------------------
--  DDL for Procedure UPD#ACCOUNT_ID_DATE_BEGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#ACCOUNT_ID_DATE_BEGIN" 
(
  A#ACCOUNT_ID IN number
, A#DATE IN date
) AS 
a#id number;
A#NUM varchar2(20);
BEGIN
  a#id := a#account_id;
insert into tt#tr_flag (c#val) values ('ACCOUNT#PASS_MOD');
insert into tt#tr_flag (c#val) values ('ACCOUNT_SPEC#PASS_MOD');
update (select * from fcr.t#account where c#id= A#ID )
set c#date = a#date;
update (select * from fcr.t#account_spec where c#account_id = A#ID )
set c#date = a#date;
commit;
-- выполняем перерасчет
select c#num into a#num from fcr.t#account where c#id = a#account_id;
DO#RECALC_ACCOUNT( A#NUM, A#DATE);

END UPD#ACCOUNT_ID_DATE_BEGIN ;

/
--------------------------------------------------------
--  DDL for Procedure UPD#DATE_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#DATE_ACCOUNT" 
(
  a#id integer,
  a#date date
)
AS 
BEGIN

  update (select * from fcr.t#account where c#id = a#id)
  set  c#date = a#date;
  
END UPD#DATE_ACCOUNT;

/
--------------------------------------------------------
--  DDL for Procedure UPD#HOUSE_DATE_BEGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#HOUSE_DATE_BEGIN" 
(
  A#HOUSE_ID IN NUMBER 
, A#DATE IN date
) AS 
BEGIN
-- дом
update fcr.t#house_info
set
   C#2ND_DATE = A#DATE
where   c#house_id = A#HOUSE_ID;
--счета
for rec in 
 (select a.c#id from fcr.t#account a,fcr.t#rooms r where 1=1 and r.c#id = a.c#rooms_id and r.c#house_id = A#HOUSE_ID)
loop
  begin
        UPD#ACCOUNT_ID_DATE_BEGIN (rec.c#id,A#DATE);
  exception
  when others then 
        dbms_output.put_line(rec.c#id);
  end;      
end loop;
commit;
END UPD#HOUSE_DATE_BEGIN;

/
