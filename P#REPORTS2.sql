CREATE OR REPLACE PACKAGE p#reports2 AS

-- долги по муниципальному и региональному жилью за период
    FUNCTION lst#mun_dolg (
        a#period VARCHAR2 -- mm.yyyy
    ) RETURN SYS_REFCURSOR;

END p#reports2;
/


CREATE OR REPLACE PACKAGE BODY p#reports2 AS

    FUNCTION lst#mun_dolg (
        a#period VARCHAR2 -- mm.yyyy
    ) RETURN SYS_REFCURSOR AS
        ret   SYS_REFCURSOR;
    BEGIN
        OPEN ret FOR SELECT
                CASE
                    WHEN j.c#tip_ul IN (
                        'MBU',
                        'MKU',
                        'MUP',
                        'OMS'
                    ) THEN 'M'
                    WHEN j.c#tip_ul IN (
                        'GUP',
                        'OBL'
                    ) THEN 'R'
                END
            type,
                j.c#name name,
                MAX(t.period) per,
                SUM(charge_sum_total) charge_sum,
                SUM(pay_sum_total) pay_sum,
                SUM(dolg_sum_total) dolg_sum
                     FROM
            v#acc_last2 l
            JOIN t#person_j j ON ( l.c#person_id = j.c#person_id )
            JOIN t#total_account t ON ( l.c#account_id = t.account_id )
                     WHERE
                CASE
                    WHEN j.c#tip_ul IN (
                        'MBU',
                        'MKU',
                        'MUP',
                        'OMS'
                    ) THEN 'M'
                    WHEN j.c#tip_ul IN (
                        'GUP',
                        'OBL'
                    ) THEN 'R'
                END
            IN (
                'M',
                'R'
            )
                AND   t.period = a#period
                     GROUP BY
                CASE
                    WHEN j.c#tip_ul IN (
                        'MBU',
                        'MKU',
                        'MUP',
                        'OMS'
                    ) THEN 'M'
                    WHEN j.c#tip_ul IN (
                        'GUP',
                        'OBL'
                    ) THEN 'R'
                END,
                j.c#name,
                t.mn
        ORDER BY
            CASE
                WHEN j.c#tip_ul IN (
                    'MBU',
                    'MKU',
                    'MUP',
                    'OMS'
                ) THEN 'M'
                WHEN j.c#tip_ul IN (
                    'GUP',
                    'OBL'
                ) THEN 'R'
            END,
            j.c#name,
            t.mn;

        RETURN ret;
    END lst#mun_dolg;

END p#reports2;
/
