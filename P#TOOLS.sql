CREATE OR REPLACE PACKAGE p#tools AS
    PROCEDURE fill_accounts_adreses;

    FUNCTION get_account_by_adres (
        p_adres IN VARCHAR2
    ) RETURN SYS_REFCURSOR;



    FUNCTION get_person_name_by_id (
        p_person_id IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION get_person_sname_by_id (
        p_person_id IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION get_person_1name_by_id (
        p_person_id IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION get_person_2name_by_id (
        p_person_id IN NUMBER
    ) RETURN VARCHAR2;

    FUNCTION get_person_tip_by_id (
        p_person_id IN NUMBER
    ) RETURN VARCHAR2;

    PROCEDURE add_new_erc_accounts;

    PROCEDURE add_new_erc_accounts_by_id;


-- добавляем внешний счет (равный внутреннему от той же даты) для аккаунтов у которых их нет

    PROCEDURE add_new_fcr_accounts;
  
-- возвращает площадь помещения по номеру счета на дату  

    FUNCTION get#acc_area (
        a#acc_id   NUMBER,
        a#date     DATE DEFAULT SYSDATE
    ) RETURN NUMBER;

-- возвращает адрес по account_id  

    FUNCTION get#acc_addr (
        a#acc_id NUMBER
    ) RETURN VARCHAR2;

  
-- возвращает максимальную свободную дату для добавления РКЦ для заданного счета

    FUNCTION get_new_rkc_date (
        p_acc_id NUMBER,
        p_date DATE
    ) RETURN DATE;

-- возвращает MN закрытия счета или 1000 если открыт

    FUNCTION get#end_account_mn (
        a#acc_id NUMBER
    ) RETURN NUMBER;

-- возвращает для задонного acc_id количество записей из T#PAY_SOURCE с кодом РКЦ 88

    FUNCTION get#count_88 (
        a#acc_id NUMBER
    ) RETURN NUMBER;

-- возвращает account_id для номера счета

    FUNCTION get#acc_id#by#acc_num (
        a#acc_num VARCHAR2
    ) RETURN NUMBER;

-- возвращает внутренний номер счета по account_id

    FUNCTION get#acc_num#by#acc_id (
        a#acc_id NUMBER
    ) RETURN VARCHAR2;

-- перенос всех платежей со счета на счет (в параметрах указывать внутренние счета)  

    PROCEDURE transfer#all_pays (
        from_acc_num VARCHAR2,
        to_acc_num VARCHAR2
    );    

-- добавляет и делает текущей площадь для помещения

    PROCEDURE set_rooms_area (
        p_rooms_id NUMBER,
        p_new_area NUMBER
    );


-- открыт дом с заданным ACCOUNT_ID или нет

    FUNCTION house_is_open (
        a#acc_id NUMBER
    ) RETURN VARCHAR2;

-- закрыт ли счет в день открытия

    FUNCTION account_is_open_error (
        a#acc_id NUMBER
    ) RETURN VARCHAR2;


-- тип баковского счета (котел, спец) по id дома

    FUNCTION acc_type_by_house_id (
        a#house_id NUMBER
    ) RETURN VARCHAR2;

    FUNCTION period_in_words (
        p_period VARCHAR2
    ) RETURN VARCHAR2;


-- удаляет для указанного счета все записи из T#MASS_PAY, T#OP, T#OP_VD

    PROCEDURE del#mass_pay_for_acc (
        a#acc_id NUMBER
    );

    PROCEDURE fill_charge_pay_j_tables (
        p_person_id INTEGER
    );

    FUNCTION get_house_balance_2043 (
        p_house_id NUMBER
    ) RETURN NUMBER;

    FUNCTION get_last_pay_str (
        p_acc_id NUMBER,
        p_max_date DATE
    ) RETURN VARCHAR2;

    FUNCTION get_tarif (
        p_date DATE
    ) RETURN NUMBER;

END p#tools;
/


CREATE OR REPLACE PACKAGE BODY p#tools AS

    PROCEDURE fill_accounts_adreses AS
    BEGIN
        DELETE FROM fcr.tt#accounts_adreses;

        INSERT INTO fcr.tt#accounts_adreses
            SELECT
                c#rooms_id,
                c#num,
                v#account.c#date,
                c#end_date,
                fcr.p#utils.get#rooms_addr(c#rooms_id),
                c#out_num
            FROM
                v#account,
                t#account_op
            WHERE
                v#account.c#id = t#account_op.c#account_id (+);

        COMMIT;
    END fill_accounts_adreses;

    FUNCTION get_account_by_adres (
        p_adres IN   VARCHAR2
    ) RETURN SYS_REFCURSOR AS
        cur   SYS_REFCURSOR;
    BEGIN
        OPEN cur FOR SELECT
                         *
                     FROM
                         tt#accounts_adreses
                     WHERE
                         adres LIKE p_adres;

        RETURN cur;
    END get_account_by_adres;

    FUNCTION get_person_name_by_id (
        p_person_id IN   NUMBER
    ) RETURN VARCHAR2 AS
        out_person_name   VARCHAR2(100);
    BEGIN
        WITH tmp#person AS (
            SELECT
                TRIM(c#name)
                || ' (ИНН: '
                || TRIM(c#inn_num)
                || ')' person_name
            FROM
                t#person_j
            WHERE
                c#person_id = p_person_id
            UNION
            SELECT
                TRIM(c#f_name)
                || ' '
                || TRIM(c#i_name)
                || ' '
                || TRIM(c#o_name) person_name
            FROM
                t#person_p
            WHERE
                c#person_id = p_person_id
        )
        SELECT
            person_name
        INTO out_person_name
        FROM
            tmp#person;

        RETURN out_person_name;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END get_person_name_by_id;

    FUNCTION get_person_tip_by_id (
        p_person_id IN   NUMBER
    ) RETURN VARCHAR2 AS
        out_person_tip   VARCHAR2(100);
    BEGIN
        WITH tmp#person AS (
            SELECT
                c#tip_ul   person_tip
            FROM
                t#person_j
            WHERE
                c#person_id = p_person_id
            UNION
            SELECT
                'PER' person_tip
            FROM
                t#person_p
            WHERE
                c#person_id = p_person_id
        )
        SELECT
            person_tip
        INTO out_person_tip
        FROM
            tmp#person;

        RETURN out_person_tip;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END get_person_tip_by_id;

    FUNCTION get_person_sname_by_id (
        p_person_id IN   NUMBER
    ) RETURN VARCHAR2 AS
        out_person_name   VARCHAR2(100);
    BEGIN
        WITH tmp#person AS (
            SELECT
                c#name
                || ' (ИНН: '
                || c#inn_num
                || ')' person_name
            FROM
                t#person_j
            WHERE
                c#person_id = p_person_id
            UNION
            SELECT
                c#f_name   person_name
            FROM
                t#person_p
            WHERE
                c#person_id = p_person_id
        )
        SELECT
            person_name
        INTO out_person_name
        FROM
            tmp#person;

        RETURN nvl(out_person_name, ' ');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN ' ';
    END get_person_sname_by_id;

    FUNCTION get_person_1name_by_id (
        p_person_id IN   NUMBER
    ) RETURN VARCHAR2 AS
        out_person_name   VARCHAR2(100);
    BEGIN
        WITH tmp#person AS (
            SELECT
                c#i_name   person_name
            FROM
                t#person_p
            WHERE
                c#person_id = p_person_id
        )
        SELECT
            person_name
        INTO out_person_name
        FROM
            tmp#person;

        RETURN nvl(out_person_name, ' ');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN ' ';
    END get_person_1name_by_id;

    FUNCTION get_person_2name_by_id (
        p_person_id IN   NUMBER
    ) RETURN VARCHAR2 AS
        out_person_name   VARCHAR2(100);
    BEGIN
        WITH tmp#person AS (
            SELECT
                c#o_name   person_name
            FROM
                t#person_p
            WHERE
                c#person_id = p_person_id
        )
        SELECT
            person_name
        INTO out_person_name
        FROM
            tmp#person;

        RETURN nvl(out_person_name, ' ');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN ' ';
    END get_person_2name_by_id;

    FUNCTION get_new_rkc_date (
        p_acc_id NUMBER,
        p_date DATE
    ) RETURN DATE AS
        nd         DATE;
        beg_date   DATE;
    BEGIN
        beg_date := TO_DATE('01.05.2014', 'dd.mm.yyyy');
        SELECT
            MAX(dd)
        INTO nd
        FROM
            (
                SELECT
                    beg_date + level - 1 dd
                FROM
                    dual
                CONNECT BY
                    level <= p_date - beg_date + 1
            )
        WHERE
            dd NOT IN (
                SELECT
                    c#date
                FROM
                    t#account_op
                WHERE
                    t#account_op.c#account_id = p_acc_id
            );

        RETURN nd;
    END get_new_rkc_date;

    PROCEDURE add_new_erc_accounts_by_id AS
    BEGIN
        FOR new_acc_rec IN (
            WITH ups AS (
                SELECT DISTINCT
                    replace(replace(replace(replace(city, 'КРАСНЕНЬКАЯ, де', 'КРАСНЕНЬКАЯ'), 'ТАМБОВ, город', 'ТАМБОВ'), 'Строитель, посе'
                    , 'СТРОИТЕЛЬ'), 'Бокино, село', 'БОКИНО') city,
                    upper(TRIM(replace(replace(replace(replace(replace(replace(replace(replace(ul_name, 'бульвар', ''), 'мкр.', ''
                    ), 'шоссе', ''), 'пер.', ''), 'пр.', ''), 'ул.', ''), 'пл.', ''), 'им.', ''))) ul_name,
                    upper(TRIM(dom))
                    || CASE
                        WHEN TRIM(dop_name) <> '--' THEN '-'
                                                         || TRIM(replace(dop_name, 'корпус', ''))
                        ELSE ''
                    END dom,
                    lpad(upper(TRIM(kv)), 15, '0') kv,
                    pl_ob,
                    new_account_num,
                    per_beg
                FROM
                    v#erc_new_accounts v
            ), erc AS (
                SELECT
                    city
                    || ','
                    || ul_name
                    || ','
                    || dom dom,
                    pl_ob,
                    kv,
                    new_account_num,
                    per_beg
                FROM
                    ups
            ), rooms AS (
                SELECT
                    t#rooms.c#id         rooms_id,
                    t#account.c#id       account_id,
                    t#rooms.c#flat_num   flat_num,
                    t#rooms.c#house_id   house_id,
                    c#area_val           area
                FROM
                    t#rooms
                    JOIN t#rooms_spec ON ( t#rooms_spec.c#rooms_id = t#rooms.c#id )
                    JOIN t#rooms_spec_vd ON ( t#rooms_spec_vd.c#id = t#rooms_spec.c#id )
                    JOIN t#account ON ( t#account.c#rooms_id = t#rooms.c#id )
            ), kvs AS (
                SELECT
                    r.house_id,
                    addr2   dom,
                    r.rooms_id,
                    lpad(upper(TRIM(r.flat_num)), 15, '0') kv,
                    r.area,
                    account_id
                FROM
                    mv_houses_adreses m
                    JOIN rooms r ON ( m.house_id = r.house_id )
            ), eq AS (
                SELECT
                    *
                FROM
                    erc
                    JOIN kvs ON ( kvs.dom LIKE '%' || erc.dom
                                  AND erc.kv = kvs.kv
                                  AND kvs.area = erc.pl_ob )
            )
            SELECT DISTINCT
                account_id,
                TO_DATE(per_beg || '01', 'yyyymmdd') new_date,
                new_account_num
            FROM
                eq
        ) LOOP
            BEGIN
                p#fcr.ins#account_op(a#account_id => new_acc_rec.account_id, a#date => get_new_rkc_date(new_acc_rec.account_id, new_acc_rec
                .new_date), a#out_proc_id => 1, a#out_num => new_acc_rec.new_account_num, a#note => 'ADD_NEW_ERC_ACCOUNTS_BY_ID: '
                || SYSDATE);

            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
        END LOOP;
    END add_new_erc_accounts_by_id;

    PROCEDURE add_new_erc_accounts AS
    BEGIN
--        FOR new_acc_rec IN (
--            SELECT DISTINCT
--                c#account_id account_id,
--                TO_DATE(per_beg
--                || '01','yyyymmdd') new_date,
--                new_account_num
--            FROM
--                v#erc_new_accounts
--                JOIN t#account_op ON ( old_account_num = c#out_num )
--            WHERE
--                c#out_num IN (
--                    SELECT
--                        c#out_num
--                    FROM
--                        t#account_op
--                    GROUP BY
--                        c#out_num
--                    HAVING
--                        COUNT(*) = 1
--                )
--        ) LOOP
--            BEGIN
--                p#fcr.ins#account_op(a#account_id => new_acc_rec.account_id,a#date => get_new_rkc_date(new_acc_rec.account_id,new_acc_rec.new_date),a#out_proc_id
--=> 1,a#out_num => new_acc_rec.new_account_num,a#note => 'ADD_NEW_ERC_ACCOUNTS: '
--                || SYSDATE);
        NULL;
--            EXCEPTION
--                WHEN OTHERS THEN
--                    NULL;
--            END;
--        END LOOP;
    END add_new_erc_accounts;

    PROCEDURE add_new_fcr_accounts AS
    BEGIN
        FOR new_acc_rec IN (
            SELECT DISTINCT
                a.c#id     account_id,
                a.c#date   new_date,
                c#num      new_account_num
            FROM
                t#account a
                LEFT JOIN t#account_op o ON ( a.c#id = o.c#account_id )
            WHERE
                o.c#account_id IS NULL
--          C#OUT_NUM is null
        ) LOOP
            BEGIN
                p#fcr.ins#account_op(a#account_id => new_acc_rec.account_id, a#date => get_new_rkc_date(new_acc_rec.account_id, new_acc_rec
                .new_date), a#out_proc_id => 10, a#out_num => new_acc_rec.new_account_num, a#note => 'ADD_NEW_FCR_ACCOUNTS: ' || SYSDATE
                ); 
--        EXCEPTION
--            WHEN OTHERS THEN NULL;

            END;
        END LOOP;
    END add_new_fcr_accounts;

    FUNCTION get#acc_area (
        a#acc_id   NUMBER,
        a#date     DATE DEFAULT SYSDATE
    ) RETURN NUMBER AS
        res   NUMBER;
    BEGIN
        SELECT
            SUM(rsvd.c#area_val)
        INTO res
        FROM
            t#account a,
            t#rooms r,
            t#rooms_spec rs,
            (
                SELECT
                    *
                FROM
                    t#rooms_spec_vd rsvd
                WHERE
                    1 = 1
                    AND rsvd.c#valid_tag = 'Y'
                    AND rsvd.c#vn = (
                        SELECT
                            MAX(t.c#vn)
                        FROM
                            t#rooms_spec_vd t
                        WHERE
                            t.c#id = rsvd.c#id
                    )
            ) rsvd
        WHERE
            1 = 1
            AND a.c#id = a#acc_id
            AND a.c#rooms_id = r.c#id
            AND rs.c#rooms_id = r.c#id
            AND rs.c#id = rsvd.c#id
            AND rs.c#date <= a#date;

        RETURN res;
    END;

    FUNCTION get#acc_addr (
        a#acc_id NUMBER
    ) RETURN VARCHAR2 AS
        ret   VARCHAR2(500);
    BEGIN
        SELECT
            p#utils.get#rooms_addr(c#rooms_id)
        INTO ret
        FROM
            t#account
        WHERE
            c#id = a#acc_id
            AND ROWNUM < 2;

        RETURN ret;
    END get#acc_addr;

    FUNCTION get#end_account_mn (
        a#acc_id NUMBER
    ) RETURN NUMBER AS
        ret   NUMBER;
    BEGIN
        SELECT
            nvl(p#mn_utils.get#mn(l.c#end_date), 1000)
        INTO ret
        FROM
            v#acc_last_end l
        WHERE
            l.c#account_id = a#acc_id;

        RETURN ret;
    END get#end_account_mn;

    FUNCTION get#count_88 (
        a#acc_id NUMBER
    ) RETURN NUMBER AS
        ret   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO ret
        FROM
            t#pay_source
        WHERE
            c#cod_rkc = '88'
            AND nvl(c#acc_id, c#acc_id_close) = a#acc_id;

        RETURN ret;
    END get#count_88;

    FUNCTION get#acc_id#by#acc_num (
        a#acc_num VARCHAR2
    ) RETURN NUMBER AS
        ret   NUMBER;
    BEGIN
        SELECT
            c#id
        INTO ret
        FROM
            v#account
        WHERE
            c#num = a#acc_num;

        RETURN ret;
    END get#acc_id#by#acc_num;

    FUNCTION get#acc_num#by#acc_id (
        a#acc_id NUMBER
    ) RETURN VARCHAR2 AS
        ret   VARCHAR2(50);
    BEGIN
        SELECT
            c#num
        INTO ret
        FROM
            v#account
        WHERE
            c#id = a#acc_id;

        RETURN ret;
    END get#acc_num#by#acc_id;

-- перенос всех платежей со счета на счет (в параметрах указывать внутренние счета)  

    PROCEDURE transfer#all_pays (
        from_acc_num VARCHAR2,
        to_acc_num VARCHAR2
    ) AS

        CURSOR pays IS
        SELECT
            p.c#id    ps_id,
            p#tools.get#acc_id#by#acc_num(to_acc_num) to_acc_id,
            SYSDATE   tr_date,
            p#utils.get#open_mn() tr_mn
        FROM
            t#pay_source p
            JOIN v#account a ON ( nvl(c#acc_id, c#acc_id_close) = a.c#id )
        WHERE
            a.c#num = from_acc_num
            AND p.c#storno_id IS NULL
            AND p.c#id NOT IN (
                SELECT
                    c#storno_id
                FROM
                    t#pay_source
                WHERE
                    c#storno_id IS NOT NULL
            );

    BEGIN
        FOR p IN pays LOOP
            transfer#pay(p.ps_id, p.to_acc_id, p.tr_date, p.tr_mn);
        END LOOP;
    END transfer#all_pays;

    PROCEDURE set_rooms_area (
        p_rooms_id NUMBER,
        p_new_area NUMBER
    ) AS
        a#id    NUMBER;
        a#vn    NUMBER;
        a#lt    VARCHAR2(1);
        a#ott   VARCHAR2(1);
    BEGIN
        SELECT
            c#id
        INTO a#id
        FROM
            t#rooms_spec
        WHERE
            c#rooms_id = p_rooms_id
            AND c#date = (
                SELECT
                    MAX(c#date)
                FROM
                    t#rooms_spec
                WHERE
                    c#rooms_id = p_rooms_id
            );

        SELECT
            MAX(c#vn)
        INTO a#vn
        FROM
            t#rooms_spec_vd
        WHERE
            c#id = a#id;

        SELECT
            c#living_tag,
            c#own_type_tag
        INTO
            a#lt,
            a#ott
        FROM
            t#rooms_spec_vd
        WHERE
            c#id = a#id
            AND c#vn = a#vn;

        INSERT INTO t#rooms_spec_vd (
            c#id,
            c#vn,
            c#valid_tag,
            c#living_tag,
            c#own_type_tag,
            c#area_val
        ) VALUES (
            a#id,
            a#vn + 1,
            'Y',
            a#lt,
            a#ott,
            p_new_area
        );

        COMMIT;
    END set_rooms_area;

    FUNCTION house_is_open (
        a#acc_id NUMBER
    ) RETURN VARCHAR2 AS
        res   VARCHAR2(1);
    BEGIN
        SELECT
            CASE
                WHEN hi.c#end_date IS NULL THEN 'Y'
                ELSE 'N'
            END
        INTO res
        FROM
            v#account a
            JOIN v#rooms r ON ( a.c#rooms_id = r.c#rooms_id )
            JOIN t#house_info hi ON ( r.c#house_id = hi.c#house_id )
        WHERE
            a.c#id = a#acc_id;

        RETURN res;
    END house_is_open;

    PROCEDURE del#mass_pay_for_acc (
        a#acc_id NUMBER
    ) AS
        a#num   VARCHAR2(50);
    BEGIN
        SELECT
            c#num
        INTO a#num
        FROM
            fcr.v#account
        WHERE
            c#id = a#acc_id
            AND c#end_date IS NOT NULL;

        IF a#num IS NOT NULL THEN
            EXECUTE IMMEDIATE 'ALTER TRIGGER TR#OP_VD#STOP_MOD DISABLE';
            EXECUTE IMMEDIATE 'ALTER TRIGGER TR#OP#STOP_MOD DISABLE';
            DELETE FROM t#op
            WHERE
                c#id IN (
                    SELECT
                        o.c#id
                    FROM
                        t#op o
                        LEFT JOIN t#pay_source p ON ( p.c#ops_id = o.c#ops_id )
                    WHERE
                        o.c#account_id = a#acc_id
                        AND p.c#id IS NULL
                );

            DELETE FROM t#mass_pay
            WHERE
                c#acc_id = a#acc_id;

            COMMIT;
            EXECUTE IMMEDIATE 'ALTER TRIGGER TR#OP_VD#STOP_MOD ENABLE';
            EXECUTE IMMEDIATE 'ALTER TRIGGER TR#OP#STOP_MOD ENABLE';
            do#recalc_account(a#num, TO_DATE('01.06.2014', 'dd.mm.yyyy'));
            COMMIT;
        END IF;

    END del#mass_pay_for_acc;

    FUNCTION account_is_open_error (
        a#acc_id NUMBER
    ) RETURN VARCHAR2 AS
        res   VARCHAR2(1);
    BEGIN
        SELECT
            CASE COUNT(*)
                WHEN 0   THEN 'N'
                ELSE 'Y'
            END
        INTO res
        FROM
            v#account
        WHERE
            c#id = a#acc_id
            AND c#date = c#end_date;

        RETURN res;
    END account_is_open_error;

    PROCEDURE fill_charge_pay_j_tables (
        p_person_id INTEGER
    ) AS
    BEGIN
        DELETE FROM tt#akt_j;

        INSERT INTO tt#akt_j
            SELECT
                ch.c#account_id,
                ch.m,
                nach,
                sum_op
            FROM
                (
                    SELECT
                        t1.c#person_id,
                        t1.m,
                        t1.c#account_id,
                        MAX(t1.c#tar_val) c#tar_val,
                        SUM(nach) nach
                    FROM
                        (
                            SELECT
                                t.c#person_id,
                                TO_CHAR(p#mn_utils.get#date(tc.c#a_mn), 'mm.yyyy') m,
                                tc.c#account_id,
                                MAX(v.c#tar_val) c#tar_val,
                                SUM(tc.c#sum) nach
                            FROM
                                fcr.t#charge tc
                                INNER JOIN (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                asp.c#person_id,
                                                asp.c#account_id,
                                                a.c#num,
                                                asp.c#date,
                                                nvl(LEAD(asp.c#date) OVER(
                                                    PARTITION BY asp.c#account_id
                                                    ORDER BY
                                                        asp.c#date
                                                ), fcr.p#mn_utils.get#date(fcr.p#utils.get#open_mn + 1)) "C#NEXT_DATE"
                                            FROM
                                                v#account_spec asp
                                                INNER JOIN t#account a ON ( a.c#id = asp.c#account_id )
                                            WHERE
                                                1 = 1
                                                AND asp.c#valid_tag = 'Y'
                                                AND asp.c#account_id IN (
                                                    SELECT
                                                        c#account_id
                                                    FROM
                                                        v#account_spec
                                                    WHERE
                                                        1 = 1
                                                        AND c#valid_tag = 'Y'
                                                        AND c#person_id = p_person_id
                                                )
                                        ) t2
                                    WHERE
                                        c#person_id = p_person_id
                                ) t ON ( tc.c#account_id = t.c#account_id
                                         AND tc.c#a_mn <= fcr.p#mn_utils.get#mn(t.c#next_date) )
                                LEFT JOIN (
                                    SELECT
                                        vw.c#id,
                                        vw.c#date,
                                        tobj.c#account_id,
                                        vw.c#tar_val
                                    FROM
                                        fcr.v#obj tobj
                                        INNER JOIN fcr.v#work vw ON ( tobj.c#work_id = vw.c#id )
                                ) v ON ( v.c#account_id = tc.c#account_id
                                         AND tc.c#work_id = v.c#id )
                            WHERE
                                1 = 1
                            GROUP BY
                                t.c#person_id,
                                TO_CHAR(p#mn_utils.get#date(tc.c#a_mn), 'mm.yyyy'),
                                tc.c#account_id
                        ) t1
                    GROUP BY
                        t1.c#person_id,
                        t1.m,
                        t1.c#account_id
                ) ch
                LEFT JOIN (
                    SELECT
                        c#account_id,
                        m,
                        SUM(sum_op) sum_op
                    FROM
                        (
                            SELECT
                                vop.c#account_id,
                                TO_CHAR(CASE
                                    WHEN(
                                        SELECT
                                            c#date
                                        FROM
                                            v#account va
                                        WHERE
                                            va.c#id = vop.c#account_id
                                    ) > c#real_date THEN(
                                        SELECT
                                            c#date
                                        FROM
                                            v#account va
                                        WHERE
                                            va.c#id = vop.c#account_id
                                    )
                                    WHEN months_between(c#real_date,(
                                        SELECT
                                            c#end_date
                                        FROM
                                            v#account va
                                        WHERE
                                            va.c#id = vop.c#account_id
                                    )) > - 1 THEN CASE
                                        WHEN(
                                            SELECT
                                                c#end_date
                                            FROM
                                                v#account va
                                            WHERE
                                                va.c#id = vop.c#account_id
                                        ) >(
                                            SELECT
                                                c#date
                                            FROM
                                                v#account va
                                            WHERE
                                                va.c#id = vop.c#account_id
                                        ) THEN add_months((
                                            SELECT
                                                c#end_date
                                            FROM
                                                v#account va
                                            WHERE
                                                va.c#id = vop.c#account_id
                                        ), - 1)
                                        ELSE(
                                            SELECT
                                                c#end_date
                                            FROM
                                                v#account va
                                            WHERE
                                                va.c#id = vop.c#account_id
                                        )
                                    END
                                    ELSE CASE
                                        WHEN months_between(c#real_date, t.c#next_date) > - 1 THEN add_months(t.c#next_date, - 1)
                                        ELSE c#real_date
                                    END
                                END, 'mm.yyyy') m,
                                SUM(c#sum) sum_op
                            FROM
                                fcr.v#op vop
                                INNER JOIN (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                asp.c#person_id,
                                                asp.c#account_id,
                                                a.c#num,
                                                asp.c#date,
                                                nvl(LEAD(asp.c#date) OVER(
                                                    PARTITION BY asp.c#account_id
                                                    ORDER BY
                                                        asp.c#date
                                                ), fcr.p#mn_utils.get#date(fcr.p#utils.get#open_mn + 1)) "C#NEXT_DATE"
                                            FROM
                                                v#account_spec asp
                                                INNER JOIN t#account a ON ( a.c#id = asp.c#account_id )
                                            WHERE
                                                1 = 1
                                                AND asp.c#valid_tag = 'Y'
                                                AND asp.c#account_id IN (
                                                    SELECT
                                                        c#account_id
                                                    FROM
                                                        v#account_spec
                                                    WHERE
                                                        1 = 1
                                                        AND c#valid_tag = 'Y'
                                                        AND c#person_id = p_person_id
                                                )
                                        ) t2
                                    WHERE
                                        c#person_id = p_person_id
                                ) t ON ( vop.c#account_id = t.c#account_id
                                         AND vop.c#a_mn <= fcr.p#mn_utils.get#mn(t.c#next_date) )
                            WHERE
                                1 = 1
                            GROUP BY
                                vop.c#account_id,
                                c#real_date,
                                t.c#next_date
                        ) t
                    GROUP BY
                        c#account_id,
                        m
                ) op ON ( ch.m = op.m
                          AND ch.c#account_id = op.c#account_id );

        COMMIT;
        DELETE FROM tt#charge_pay_j;

        INSERT INTO tt#charge_pay_j
            WITH acc AS (
                SELECT
                    c#account_id,
                    c#acc_num
                FROM
                    v#acc_last2
                WHERE
                    c#person_id = p_person_id
            ), ch AS (
                SELECT
                    c#account_id,
                    c#a_mn,
                    SUM(c#sum) charge_sum
                FROM
                    t#charge
                WHERE
                    c#account_id IN (
                        SELECT
                            c#account_id
                        FROM
                            acc
                    )
                GROUP BY
                    c#account_id,
                    c#a_mn
            ), pay AS (
                SELECT
                    c#account_id,
                    c#a_mn,
                    SUM(c#sum) pay_sum
                FROM
                    v#op
                WHERE
                    c#account_id IN (
                        SELECT
                            c#account_id
                        FROM
                            acc
                    )
                GROUP BY
                    c#account_id,
                    c#a_mn
            ), alls AS (
                SELECT
                    acc.*,
                    ch.c#a_mn,
                    ch.charge_sum,
                    pay.pay_sum
                FROM
                    acc left
                    JOIN ch ON ( acc.c#account_id = ch.c#account_id )
                    LEFT JOIN pay ON ( ch.c#account_id = pay.c#account_id
                                       AND ch.c#a_mn = pay.c#a_mn )
            )
            SELECT
                *
            FROM
                alls;

        COMMIT;
        p#reports.lst#reestr2(p_person_id);
        p#print_bill_j.do#prepare2(TO_DATE('01.06.2014', 'dd.mm.yyyy'), SYSDATE, p_person_id);
    END fill_charge_pay_j_tables;

    FUNCTION acc_type_by_house_id (
        a#house_id NUMBER
    ) RETURN VARCHAR2 AS
        res   VARCHAR2(3);
    BEGIN
        SELECT
            acc_type
        INTO res
        FROM
            v4_bank_vd
        WHERE
            house_id = a#house_id;

        RETURN res;
    END acc_type_by_house_id;

    FUNCTION get_house_balance_2043 (
        p_house_id NUMBER
    ) RETURN NUMBER AS
        curmn      NUMBER;
        totalpay   NUMBER;
        mnpay      NUMBER;
        res        NUMBER;
    BEGIN
        SELECT
            p#utils.get#open_mn()
        INTO curmn
        FROM
            dual;
--        select CHARGE_SUM_MN, PAY_SUM_TOTAL into mnPay, totalPay from T#TOTAL_HOUSE where MN = curMN and HOUSE_ID = p_house_id;

        SELECT
            charge_sum_mn,
            pay_sum_total
        INTO
            mnpay,
            totalpay
        FROM
            v3_house_balance
        WHERE
            mn = curmn
            AND house_id = p_house_id;

        res := totalpay + ( 516 - curmn ) * mnpay;
        RETURN res;
    END get_house_balance_2043;

    FUNCTION period_in_words (
        p_period VARCHAR2
    ) RETURN VARCHAR2 AS
        m    NUMBER;
        mw   VARCHAR2(10);
    BEGIN
        m := substr(p_period, 0, 2);
        mw :=
            CASE m
                WHEN 1 THEN 'Январь'
                WHEN 2 THEN 'Февраль'
                WHEN 3 THEN 'Март'
                WHEN 4 THEN 'Апрель'
                WHEN 5 THEN 'Май'
                WHEN 6 THEN 'Июнь'
                WHEN 7 THEN 'Июль'
                WHEN 8 THEN 'Август'
                WHEN 9 THEN 'Сентябрь'
                WHEN 10 THEN 'Октябрь'
                WHEN 11 THEN 'Ноябрь'
                WHEN 12 THEN 'Декабрь'
            END;

        RETURN mw
               || ' '
               || substr(p_period, 4, 4);
    END period_in_words;
--------------------------------

--    FUNCTION get_last_pay_str (
--        p_acc_id NUMBER,
--        p_max_date DATE
--    ) RETURN VARCHAR2 AS
--        res   VARCHAR2(500);
--    BEGIN
--        SELECT
--            CASE
--                WHEN ( pay_sum IS NULL ) THEN ''
--                ELSE 'Последняя оплата: '
--                     || pay_sum
--                     || ' руб. от '
--                     || TO_CHAR(pay_date, 'dd.mm.yyyy')
--                     || ', '
--                     || p.pay_agent
--            END
--        INTO res
--        FROM
--            v_all_pays p
--        WHERE
--            acc_id = p_acc_id
--            AND pay_date = (
--                SELECT
--                    MAX(pay_date)
--                FROM
--                    v_all_pays
--                WHERE
--                    acc_id = p_acc_id
--                    AND pay_sum <> 0
--                    AND pay_date <= p_max_date
--            )
--            AND pay_sum > 0
--            AND ROWNUM < 2;
--
--        RETURN res;
--    END get_last_pay_str;
-----------------------------

    FUNCTION get_last_pay_str (
        p_acc_id NUMBER,
        p_max_date DATE
    ) RETURN VARCHAR2 AS
        res   VARCHAR2(500);
    BEGIN
        WITH payd AS (
            SELECT
                c#real_date   real_date,
                SUM(c#summa) summ,
                MAX(c#cod_rkc) cod_rkc
            FROM
                t#pay_source
            WHERE
                coalesce(c#acc_id, c#acc_id_close, c#acc_id_tter) = p_acc_id
            GROUP BY
                c#real_date
        )
        SELECT
            CASE
                WHEN ( summ IS NULL ) THEN ''
                ELSE 'Последняя оплата: '
                     || summ
                     || ' руб., '
                     || TO_CHAR(real_date, 'dd.mm.yyyy')
                     || ', '
                     || d.c#name
            END
        INTO res
        FROM
            payd p
            LEFT JOIN t#ops_kind d ON ( p.cod_rkc = d.c#cod )
        WHERE
            real_date = (
                SELECT
                    MAX(real_date)
                FROM
                    payd
                WHERE
                    summ <> 0
                    AND real_date <= p_max_date
            );

        RETURN res;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '';
    END get_last_pay_str;
-----------------------------

    FUNCTION get_tarif (
        p_date DATE
    ) RETURN NUMBER AS
        res   NUMBER;
    BEGIN
        SELECT
            c#tar_val
        INTO res
        FROM
            v#work
        WHERE
            c#works_id = 1
            AND c#date = (
                SELECT
                    MAX(c#date)
                FROM
                    v#work
                WHERE
                    c#works_id = 1
                    AND c#date <= p_date
            );

        RETURN res;
    END get_tarif;
END p#tools;
/
