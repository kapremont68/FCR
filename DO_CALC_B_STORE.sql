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
