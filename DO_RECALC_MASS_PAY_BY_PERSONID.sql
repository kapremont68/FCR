--------------------------------------------------------
--  DDL for Procedure DO#RECALC_MASS_PAY_BY_PERSONID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_MASS_PAY_BY_PERSONID" (
    p_person_id          IN NUMBER,
    p_do_charge_recalc   IN VARCHAR2 DEFAULT 'N',
    p_do_pay_recalc      IN VARCHAR2 DEFAULT 'N',
    p_do_reset           IN VARCHAR2 DEFAULT 'Y',
    p_del_rkc            IN VARCHAR2 DEFAULT 'N'
) AS
    ps_count NUMBER;
BEGIN
    IF
        ( p_do_reset = 'Y' )
    THEN
        EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD disable';
        EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD disable';

-- ������� ��� ��� �� ������ �������������� ����� ������
        DELETE FROM t#op
        WHERE
            c#id IN (
                SELECT
                    o.c#id
                FROM
                    v#acc_last2 l
                    JOIN v#op o ON ( l.c#account_id = o.c#account_id )
                WHERE
                    c#person_id = p_person_id
            );

        COMMIT;
        EXECUTE IMMEDIATE 'alter trigger TR#OP#STOP_MOD enable';
        EXECUTE IMMEDIATE 'alter trigger TR#OP_VD#STOP_MOD enable';
-- ������� ��� ������ � MASS_PAY ����� ��������������� (��� �� ��� ��������� ��������)
        DELETE FROM t#mass_pay
        WHERE
            c#person_id = p_person_id
            AND   c#id NOT IN (
                SELECT
                    c#id
                FROM
                    t#mass_pay
                WHERE
                    c#parent_id IS NULL
                    AND   c#cod_rkc = 90
                    AND   c#person_id = p_person_id
            );

        DELETE FROM t#mass_pay
        WHERE
            c#person_id = p_person_id
            AND   lower(c#comment) LIKE '%������������%';

        DELETE FROM t#mass_pay
        WHERE
            c#person_id = p_person_id
            AND   lower(c#comment) LIKE '%�����%'; 

-- ������� �������� ���������� �� ����� ������� ����� ������ ���
        if (p_del_rkc = 'Y') then 
            DELETE FROM t#account_op
            WHERE
                c#id IN (
                    SELECT
                        c#id
                    FROM
                        t#account_op
                    WHERE
                        c#account_id IN (
                            SELECT
                                c#account_id
                            FROM
                                v#acc_last2
                            WHERE
                                c#person_id = p_person_id
                        )
                        AND   c#out_proc_id <> 10
                );
        end if;
        
-- ���������� ������ MASS_PAY (��������������) �������� ��� �������������

        UPDATE t#mass_pay
            SET
                c#remove_flg = NULL,
                �#ostatok = 0,
                c#ops_id = NULL
        WHERE
            c#person_id = p_person_id;

-- ��� ����� � PAY_SOURCE, ������� � ��������� ����� ��������� � �������� ������ �����, �������� ��� �������������

        ps_count := 0;
        UPDATE t#pay_source
            SET
                c#acc_id = NULL,
                c#acc_id_close = NULL,
                c#acc_id_tter = NULL,
                c#ops_id = NULL
        WHERE
            coalesce(c#acc_id,c#acc_id_close,c#acc_id_tter) IN (
                SELECT
                    c#account_id
                FROM
                    v#acc_last2
                WHERE
                    c#person_id = p_person_id
            );

        ps_count := SQL%rowcount;
        COMMIT;

-- ���� � ����� ���� ������� ����� PAY_SOURCE, �������� ��� ������������� �������
        IF
            ( ps_count > 0 )
        THEN
            p#fcr_load_outer_data.execallfunctioncycle;
            COMMIT;
        END IF;
    END IF;
    
-- ������������� ���������� �� ���� ������ ������������� ����� ������

    IF
        p_do_charge_recalc = 'Y'
    THEN
        do#recalc_charge_by_personid(p_person_id);
        COMMIT;
    END IF;    

-- �������� ������� �� ����� ������
    if (p_do_pay_recalc = 'Y') then 
        do#3bypersonid ( p_person_id ); 
        commit; 
    end if; 
end
do#recalc_mass_pay_by_personid;

/
