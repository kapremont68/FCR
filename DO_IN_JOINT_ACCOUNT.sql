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
