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
