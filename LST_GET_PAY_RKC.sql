--------------------------------------------------------
--  DDL for Function LST#GET_PAY_RKC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#GET_PAY_RKC" ( a#date DATE,a#code_rkc NUMBER ) RETURN SYS_REFCURSOR IS
    result   SYS_REFCURSOR;
BEGIN
    OPEN result FOR
        SELECT
            f.c#id,
            t.c#id account_id,
            t.c#date,
            t.c#end_date,
            t.c#living_tag,
            t.c#own_type_tag,
            t.c#area_val,
            t.oa.f#house_id house_id,
            t.oa.f#person_id person_id,
            t.c#out_num out_account_num,
            t.oa.f#num account_num,
            p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path -- rooms_addr(t.oa.f#rooms_id) address
            ,
            t.c#house_num,
            t.c#flat_num,
            t.room_id,
            p#utils.get#person_name(t.oa.f#person_id) person,
            (
                SELECT
                    MAX('—чет юр лица')
                FROM
                    fcr.t#person_j p
                WHERE
                    p.c#person_id = t.oa.f#person_id
            ) AS urfiz,
            c#out_proc_id,
            c#code,
            f.c#real_date,
            f.c#summa,
            f.c#account,
            f.c#period,
            f.c#cod_rkc,
            f.c#file_id,
            ok.c#name,
            ok.c#cod,
            uk.UK_NAME
        FROM
            (
                SELECT
                    a.c#id,
                    rs.c#living_tag,
                    rs.c#own_type_tag,
                    rs.c#area_val,
                    a.c#num,
                    p#utils.get_obj#account(op.c#account_id,SYSDATE) oa,
                    h.c#addr_obj_id,
                    a.c#date,
                    a.c#end_date,
                    h.c#num
                     || rtrim(
                        '-'
                         || h.c#b_num
                         || '-'
                         || h.c#s_num,
                        '-'
                    ) c#house_num,
                    r.c#id AS room_id,
                    r.c#flat_num,
                    op.c#out_num,
                    op.c#out_proc_id,
                    oo.c#code
                FROM
                    fcr.t#account_op op,
                    fcr.v#account a,
                    fcr.v#rooms_spec rs,
                    fcr.t#rooms r,
                    fcr.t#house h,
                    fcr.t#out_proc oo
                WHERE
                        op.c#date = (
                            SELECT
                                MAX(o.c#date)
                            FROM
                                fcr.t#account_op o
                            WHERE
                                    1 = 1
                                AND
                                    o.c#account_id = op.c#account_id
                                AND
                                    o.c#date < a#date
                        )
                    AND
                        a.c#id = op.c#account_id
                    AND
                        a.c#date = (
                            SELECT
                                MAX(a1.c#date)
                            FROM
                                fcr.v#account a1
                            WHERE
                                    1 = 1
                                AND
                                    a1.c#id = a.c#id
                                AND
                                    a1.c#date < a#date
                                AND
                                    a1.c#valid_tag = 'Y'
                        )
                    AND
                        op.c#out_proc_id IN (
                            a#code_rkc
                        )
                    AND
                        oo.c#id = op.c#out_proc_id
                    AND
                        rs.c#rooms_id = a.c#rooms_id
                    AND
                        rs.c#valid_tag = 'Y'
                    AND
                        a.c#valid_tag = 'Y'
                    AND
                        r.c#id = rs.c#rooms_id
                    AND
                        r.c#house_id = h.c#id
                    AND
                        rs.c#date = (
                            SELECT
                                MAX(rs1.c#date)
                            FROM
                                fcr.v#rooms_spec rs1
                            WHERE
                                    rs1.c#rooms_id = rs.c#rooms_id
                                AND
                                    rs1.c#date < a#date
                        )
            ) t left join V#ERC_ACC_UK_NAMES uk on (t.c#out_num = uk.ACCAUNT_NUM),
            fcr.t#pay_source f,
            fcr.t#ops_kind ok
        WHERE
                coalesce(
                    f.c#acc_id,
                    f.c#acc_id_close,
                    f.c#acc_id_tter
                ) = t.c#id
            AND
                TO_CHAR(t.c#code,'00') <> TO_CHAR(f.c#cod_rkc,'00')
            AND
                f.c#kind_id = ok.c#id
            AND
                ok.c#cod <> '88'
            AND
                f.c#upload_flg IS NULL;

    return(result);
END lst#get_pay_rkc;

/
