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
