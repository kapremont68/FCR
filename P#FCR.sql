CREATE OR REPLACE PACKAGE "P#FCR"
  IS

  /**
  *  Все адреса с ФИАС
  */
  FUNCTION lst#addr_tree_FIAS(a#parent_id NUMBER)
    RETURN sys_refcursor;

  /**
  *  Все дома с ФИАС
  */
  FUNCTION lst#house_FIAS(a#addr_obj_id NUMBER)
    RETURN sys_refcursor;

  PROCEDURE upd#room_date(a#room_id NUMBER,
                          a#date    DATE);

  FUNCTION lst#turnover_for_report(a#date_begin DATE,
                                   a#date_end   DATE)
    RETURN sys_refcursor;

  PROCEDURE INS#SUPPORT_DOCUMS(a#id_record INTEGER);

  FUNCTION lst#turnover_all_house(a#date_begin DATE,
                                  a#date_end   DATE)
    RETURN sys_refcursor;

  FUNCTION lst#search_j(a#date   DATE,
                        a#person VARCHAR2,
                        a#inn    NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#search_p(a#date   DATE,
                        a#f_name VARCHAR2,
                        a#i_name VARCHAR2,
                        a#o_name VARCHAR2)
    RETURN sys_refcursor;
  FUNCTION lst#addr_tree(a#parent_id NUMBER)
    RETURN sys_refcursor;
  FUNCTION lst#house(a#addr_obj_id NUMBER)
    RETURN sys_refcursor;
  FUNCTION lst#accounts(a#house_id NUMBER,
                        a#date     DATE)
    RETURN sys_refcursor;
  FUNCTION get#house_area(a#house_id NUMBER,
                          a#date     DATE)
    RETURN NUMBER;

  FUNCTION lst#turnover(a#house_id   NUMBER,
                        a#date_begin DATE,
                        a#date_end   DATE)
    RETURN sys_refcursor;

  FUNCTION lst#turnover2(a#house_id   NUMBER,
                         a#date_begin DATE,
                         a#date_end   DATE)
    RETURN sys_refcursor;

  PROCEDURE set#work_date(a#date DATE);
  FUNCTION lst#account_vd_history(a#account_num NUMBER)
    RETURN sys_refcursor;
  PROCEDURE ins#account_vd(a#id          NUMBER,
                           a#person_id   NUMBER,
                           a#c#part_coef NUMBER);
  FUNCTION ins#person(a#f_name      VARCHAR2,
                      a#i_name      VARCHAR2,
                      a#o_name      VARCHAR2,
                      a#j_name      VARCHAR2,
                      a#inn_num     NUMBER,
                      a#kpp_num     NUMBER,
                      a#phone   IN  VARCHAR2 DEFAULT '',
                      a#contact IN  VARCHAR2 DEFAULT '',
                      a#mail    IN  VARCHAR2 DEFAULT '',
                      a#note    IN  VARCHAR2 DEFAULT '',
                      a#person_type VARCHAR2)
    RETURN NUMBER;

  PROCEDURE ins#person_addr(a#person_id NUMBER,
                            a#post_code VARCHAR2,
                            a#1_text    VARCHAR2,
                            a#2_text    VARCHAR2);

  PROCEDURE upd#person(a#person_id    NUMBER,
                       a#f_name       VARCHAR2,
                       a#i_name       VARCHAR2,
                       a#o_name       VARCHAR2,
                       a#j_name       VARCHAR2,
                       a#inn_num      NUMBER,
                       a#kpp_num      NUMBER,
                       a#phone     IN VARCHAR2 DEFAULT '',
                       a#contact   IN VARCHAR2 DEFAULT '',
                       a#mail      IN VARCHAR2 DEFAULT '',
                       a#note      IN VARCHAR2 DEFAULT '',
                       a#person_type  VARCHAR2);

  FUNCTION lst#person_addr(a#person_id NUMBER)
    RETURN sys_refcursor;

  PROCEDURE upd#person_addr(a#person_id NUMBER,
                            a#post_code VARCHAR2,
                            a#1_text    VARCHAR2,
                            a#2_text    VARCHAR2);

  FUNCTION lst#room_data(a#rooms_id NUMBER)
    RETURN sys_refcursor;

  PROCEDURE ins#room_spec(a#room_id      NUMBER,
                          a#date         DATE,
                          a#living_tag   VARCHAR2,
                          a#own_type_tag VARCHAR2,
                          a#area_val     NUMBER);

  FUNCTION ins#room(a#flat_num     string,
                    a#house_id     NUMBER,
                    a#date         DATE,
                    a#living_tag   VARCHAR2,
                    a#own_type_tag VARCHAR2,
                    a#area_val     NUMBER)
    RETURN NUMBER;

  PROCEDURE upd#room(a#room_id  NUMBER,
                     a#date     DATE,
                     a#flat_num VARCHAR2);

  PROCEDURE del#room(a#room_id NUMBER);

  FUNCTION get#vn_rsvd(a#id NUMBER)
    RETURN NUMBER;

  PROCEDURE upd#room_spec_vd(a#room_id          NUMBER,
                             a#room_spec_id     NUMBER,
                             a#living_tag_old   VARCHAR2,
                             a#own_type_tag_old VARCHAR2,
                             a#area_val_old     NUMBER,
                             a#living_tag_new   VARCHAR2,
                             a#own_type_tag_new VARCHAR2,
                             a#area_val_new     NUMBER,
                             a#vn_new           NUMBER);

  PROCEDURE del#room_spec_vd(a#room_spec_id NUMBER,
                             a#living_tag   VARCHAR2,
                             a#own_type_tag VARCHAR2,
                             a#area_val     NUMBER,
                             a#vn_new       NUMBER);

  FUNCTION lst#rooms_part(a#room_id NUMBER,
                          a#date    DATE)
    RETURN sys_refcursor;

  FUNCTION get#room_pn(a#room_id NUMBER)
    RETURN NUMBER;

  FUNCTION lst#rooms_part(a#room_id NUMBER)
    RETURN sys_refcursor;

  PROCEDURE ins#rooms_part(a#room_id NUMBER);

  PROCEDURE del#rooms_part(a#rooms_id NUMBER,
                           a#rooms_pn NUMBER);

  FUNCTION get#account_pn(a#rooms_id NUMBER,
                          a#rooms_pn NUMBER)
    RETURN NUMBER;

  FUNCTION get#account_num(a#house_id NUMBER)
    RETURN VARCHAR2;

  PROCEDURE do#account(a#rooms_id  NUMBER,
                       a#rooms_pn  NUMBER,
                       a#date      DATE,
                       a#num       VARCHAR2,
                       a#sn        NUMBER,
                       a#person_id NUMBER,
                       a#part_coef NUMBER);

  PROCEDURE upd#account(a#account_id      NUMBER,
                        a#rooms_id        NUMBER,
                        a#rooms_pn        NUMBER,
                        a#date_beg        DATE,
                        a#date_end        DATE,
                        a#num             VARCHAR2,
                        a#sn              NUMBER,
                        a#person_id       NUMBER,
                        a#part_coef       NUMBER,
                        a#account_spec_id NUMBER);

  FUNCTION lst#outproc
    RETURN sys_refcursor;

  PROCEDURE ins#outproc(a#code NUMBER,
                        a#name VARCHAR2);

  PROCEDURE upd#outproc(a#id   NUMBER,
                        a#code NUMBER,
                        a#name VARCHAR2);

  PROCEDURE del#outproc(a#id NUMBER);

  FUNCTION lst#bank
    RETURN sys_refcursor;

  PROCEDURE ins#bank(a#name    VARCHAR2,
                     a#bic_num VARCHAR2,
                     a#ca_num  VARCHAR2);


  PROCEDURE upd#bank(a#id      NUMBER,
                     a#name    VARCHAR2,
                     a#bic_num VARCHAR2,
                     a#ca_num  VARCHAR2);

  PROCEDURE del#bank(a#id NUMBER);

  FUNCTION lst#doer
    RETURN sys_refcursor;

  PROCEDURE ins#doer(a#name       VARCHAR2,
                     a#code       VARCHAR2,
                     a#charge_tag VARCHAR2);

  PROCEDURE upd#doer(a#id         NUMBER,
                     a#name       VARCHAR2,
                     a#code       VARCHAR2,
                     a#charge_tag VARCHAR2);

  PROCEDURE del#doer(a#id NUMBER);

  FUNCTION lst#ops_kind
    RETURN sys_refcursor;

  PROCEDURE ins#ops_kind(a#name VARCHAR2,
                         a#code VARCHAR2);

  PROCEDURE upd#ops_kind(a#id   NUMBER,
                         a#name VARCHAR2,
                         a#code VARCHAR2);

  PROCEDURE del#ops_kind(a#id NUMBER);

  FUNCTION lst#bank_exp(a#date DATE default sysdate)
    RETURN sys_refcursor;

  FUNCTION lst#account_debt(a#num_id     NUMBER,
                            a#date_begin DATE,
                            a#date_end   DATE)
    RETURN sys_refcursor;

  FUNCTION get#postamt_code(a#post_code VARCHAR2,
                            a#type_tag  NUMBER)
    RETURN VARCHAR2;

  PROCEDURE do#post_data(a#date DATE);

  FUNCTION lst#postamt
    RETURN sys_refcursor;

  FUNCTION lst#post_codes(a#name VARCHAR2,
                          a#area VARCHAR2)
    RETURN sys_refcursor;

  FUNCTION lst#post_account(a#p_code NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#post_account_other
    RETURN sys_refcursor;

  FUNCTION lst#addr_obj_level0
    RETURN sys_refcursor;

  FUNCTION lst#addr_obj_level1(a#id NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#addr_obj_level2(a#addr_obj_id NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#search_by_address(a#addr_obj_id NUMBER,
                                 a#house_id    NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#search_by_account(a#num      string,
                                 a#flg_type NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#search_by_person_j(a#person string,
                                  a#inn    string)
    RETURN sys_refcursor;

  FUNCTION lst#search_by_person_p(a#f_name string,
                                  a#i_name string,
                                  a#o_name string)
    RETURN sys_refcursor;

  FUNCTION lst#account_info(a#account_id NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#rooms(a#house_id NUMBER,
                     a#date     DATE)
    RETURN sys_refcursor;

  FUNCTION lst#pay_info(a#account_id  NUMBER,
                        a#account_num VARCHAR2)
    RETURN sys_refcursor;

  FUNCTION lst#pay_info_other(a#account_id  NUMBER,
                              a#account_num VARCHAR2)
    RETURN sys_refcursor;

  FUNCTION lst#pay_info_without_transfer(a#account_id  NUMBER,
                                         a#account_num VARCHAR2,
                                         a#flag        BOOLEAN)
    RETURN sys_refcursor;

  FUNCTION get#account_data(a#account_id NUMBER,
                            a#date       DATE)
    RETURN sys_refcursor;

  FUNCTION lst#person_j
    RETURN sys_refcursor;

  PROCEDURE ins#person_j(a#name      VARCHAR2,
                         a#inn_num   VARCHAR2,
                         a#kpp_num   VARCHAR2,
                         a#post_code VARCHAR2,
                         a#text_1    VARCHAR2,
                         a#text_2    VARCHAR2);

  PROCEDURE upd#person_j(a#person_id NUMBER,
                         a#name      VARCHAR2,
                         a#inn_num   VARCHAR2,
                         a#kpp_num   VARCHAR2,
                         a#post_code VARCHAR2,
                         a#text_1    VARCHAR2,
                         a#text_2    VARCHAR2);

  PROCEDURE del#person_j(a#person_id NUMBER);

  FUNCTION lst#account_op(a#account_id NUMBER)
    RETURN sys_refcursor;

  PROCEDURE ins#account_op(a#account_id  NUMBER,
                           a#date        DATE,
                           a#out_proc_id NUMBER,
                           a#out_num     VARCHAR,
                           a#note VARCHAR default null);

  PROCEDURE upd#account_op(a#id          NUMBER,
                           a#date        DATE,
                           a#out_proc_id NUMBER,
                           a#out_num     VARCHAR);

  PROCEDURE del#account_op(a#id NUMBER);

  FUNCTION lst#house_info(a#house_id NUMBER)
    RETURN sys_refcursor;

  PROCEDURE do#calc(a#date DATE);
  FUNCTION get#open_mn
    RETURN DATE;
  FUNCTION get#acc_count
    RETURN NUMBER;
  FUNCTION lst#account_all
    RETURN sys_refcursor;
  PROCEDURE do#calc_account(a#date       DATE,
                            a#account_id NUMBER,
                            a#type       NUMBER);

  FUNCTION lst#adr_obj_house(a#house_id NUMBER)
    RETURN sys_refcursor;

  FUNCTION lst#account_changed
    RETURN sys_refcursor;


    procedure ins#pay_source(
        a#account varchar2,
        a#real_date varchar2,
        a#summa number,
        a#fine number,
        a#period varchar2,
        a#cod_rkc varchar2,
        a#pay_num varchar2,
        a#comment varchar2,
        a#file_id varchar2
    );
    
  function add#rooms_part(a#room_id NUMBER) return NUMBER;
    
END p#fcr;
/


CREATE OR REPLACE PACKAGE BODY "P#FCR"
  IS
  f#work_date DATE;

  PROCEDURE set#work_date(a#date DATE)
    IS
    BEGIN
      f#work_date := a#date;
    END;

  PROCEDURE ins#support_docums(a#id_record INTEGER)
    IS
    BEGIN
      INSERT INTO t#support_docums (
        c#id_record
      )
      VALUES (a#id_record);
      COMMIT;
    END;

  FUNCTION lst#search_j(a#date   DATE,
                        a#person VARCHAR2,
                        a#inn    NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT pj.*,
             p#utils.get#house_addr(r.c#house_id) || CASE WHEN r.c#id IS NOT NULL THEN ', ' || r.c#flat_num END address,
             '' c#f_name,
             '' c#i_name,
             '' c#o_name
        FROM t#person_j pj,
             v#account_spec asp,
             v#account a,
             t#rooms r
        WHERE 1 = 1
          AND (a#inn IS NULL
          OR pj.c#inn_num = a#inn
          OR pj.c#inn_num LIKE '%' || a#inn || '%')
          AND (a#person IS NULL
          OR UPPER(pj.c#name) LIKE '%' || UPPER(a#person) || '%')
          AND pj.c#person_id = asp.c#person_id (+)
          AND asp.c#valid_tag (+) = 'Y'
          AND a.c#id (+) = asp.c#account_id
          AND a.c#valid_tag (+) = 'Y'
          AND r.c#id (+) = a.c#rooms_id
        ORDER BY pj.c#name;
      RETURN res;
    END;

  FUNCTION lst#search_p(a#date   DATE,
                        a#f_name VARCHAR2,
                        a#i_name VARCHAR2,
                        a#o_name VARCHAR2)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT pp.*,
             p#utils.get#house_addr(r.c#house_id) || CASE WHEN r.c#id IS NOT NULL THEN ', ' || r.c#flat_num END address,
             '' c#name,
             '' c#inn_num,
             '' c#kpp_num
        FROM t#person_p pp,
             v#account_spec asp,
             v#account a,
             t#rooms r
        WHERE 1 = 1
          AND (a#f_name IS NULL
          OR UPPER(pp.c#f_name) LIKE '%' || UPPER(a#f_name) || '%')
          AND (a#i_name IS NULL
          OR UPPER(pp.c#i_name) LIKE '%' || UPPER(a#i_name) || '%')
          AND (a#o_name IS NULL
          OR UPPER(pp.c#o_name) LIKE '%' || UPPER(a#o_name) || '%')
          AND pp.c#person_id = asp.c#person_id (+)
          AND asp.c#valid_tag (+) = 'Y'
          AND a.c#id (+) = asp.c#account_id
          AND a.c#valid_tag (+) = 'Y'
          AND r.c#id (+) = a.c#rooms_id
        ORDER BY pp.c#f_name;
      RETURN res;
    END;

  FUNCTION lst#addr_tree(a#parent_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT *
        FROM (SELECT ao.c#id,
                     ao.c#parent_id,
                     ao.c#type_id,
                     ao.c#level_tag,
                     ao.c#center_tag,
                     ao.c#name || ' ' || aot.c#abbr_name c#name,
                     ao.c#fias_guid,
                     aot.c#abbr_name,
                     (SELECT SUM((SELECT COUNT(*)
                           FROM t#house
                           WHERE c#addr_obj_id = aoh.c#id))
                         FROM fcr.t#addr_obj aoh
                       START WITH aoh.c#id = ao.c#id
                       CONNECT BY PRIOR aoh.c#id = aoh.c#parent_id) c#house_cnt
            FROM fcr.t#addr_obj ao,
                 fcr.t#addr_obj_type aot
            WHERE 1 = 1
              AND ao.c#type_id = aot.c#id
              AND (ao.c#parent_id = a#parent_id
              OR (a#parent_id IS NULL
              AND ao.c#parent_id IS NULL))
            ORDER BY ao.c#name) t
        WHERE c#house_cnt > 0
      ;
      RETURN res;
    END;

  FUNCTION lst#addr_tree_FIAS(a#parent_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT ao.c#id,
             ao.c#parent_id,
             ao.c#type_id,
             ao.c#level_tag,
             ao.c#center_tag,
             ao.c#name || ' ' || aot.c#abbr_name c#name,
             ao.c#fias_guid,
             aot.c#abbr_name,
             (SELECT SUM((SELECT COUNT(*)
                   FROM t#house
                   WHERE c#addr_obj_id = aoh.c#id))
                 FROM fcr.t#addr_obj aoh
               START WITH aoh.c#id = ao.c#id
               CONNECT BY PRIOR aoh.c#id = aoh.c#parent_id) c#house_cnt
        FROM fcr.t#addr_obj ao,
             fcr.t#addr_obj_type aot
        WHERE 1 = 1
          AND ao.c#type_id = aot.c#id (+)
          AND (ao.c#parent_id = a#parent_id
          OR (a#parent_id IS NULL
          AND ao.c#parent_id IS NULL))
        ORDER BY ao.c#name
      ;
      RETURN res;
    END;

  FUNCTION lst#house_FIAS(a#addr_obj_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT 0 c#id,
             houseNum || CASE WHEN buildnum IS NOT NULL THEN TRIM('-' || buildnum) END || CASE WHEN strucnum IS NOT NULL THEN TRIM('-' || strucnum) END c#num,
             postalcode c#post_code,
             houseguid c#fias_guid,
             NULL c#z
        FROM fcr.t_house68
        WHERE aoguid = (SELECT c#fias_guid
              FROM fcr.t#addr_obj
              WHERE c#id = a#addr_obj_id)
        ORDER BY housenum;
      RETURN res;
    END;

  FUNCTION lst#house(a#addr_obj_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT h.c#id,
             h.c#addr_obj_id
             --            ,h.c#num
             ,
             h.c#b_num,
             h.c#s_num,
             h.c#post_code,
             h.c#fias_guid,
             h.c#num || RTRIM('-' || h.c#b_num || '-' || h.c#s_num, '-') c#num,
             c#end_date c#z
        FROM t#house h
          LEFT JOIN t#house_info c
            ON (h.c#id = c.c#house_id)
        WHERE 1 = 1
          AND h.c#addr_obj_id = a#addr_obj_id
        ORDER BY p#utils.get#addr_num(h.c#num),
                 h.c#id;
      RETURN res;
    END;

  FUNCTION lst#account_vd_history(a#account_num NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT asvd.c#id,
             asvd.c#part_coef,
             TRUNC(asvd.c#sign_date) c#sign_date,
             asvd.c#valid_tag,
             asvd.c#vn,
             CASE WHEN pj.c#person_id IS NOT NULL THEN pj.c#name ELSE pp.c#f_name || ' ' || pp.c#i_name || ' ' || pp.c#o_name END person,
             CASE WHEN pj.c#person_id IS NOT NULL THEN 'J' ELSE 'P' END person_tag
        FROM t#account a,
             t#account_spec as1,
             t#account_spec_vd asvd,
             t#person_j pj,
             t#person_p pp
        WHERE 1 = 1
          AND a.c#num = a#account_num
          AND a.c#id = as1.c#account_id
          AND asvd.c#id = as1.c#id
          AND asvd.c#vn < (SELECT MAX(c#vn)
              FROM t#account_spec_vd
              WHERE c#id = asvd.c#id)
          AND asvd.c#person_id = pj.c#person_id (+)
          AND asvd.c#person_id = pp.c#person_id (+)
        ORDER BY asvd.c#vn DESC;
      RETURN res;
    END;

  FUNCTION lst#accounts(a#house_id NUMBER,
                        a#date     DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT r.c#id room_id,
             r.c#house_id,
             r.c#flat_num,
             rs.c#date rs_date,
             rs.c#living_tag,
             rs.c#own_type_tag,
             rs.c#area_val,
             a.c#rooms_pn,
             a.c#end_date
             --            ,rh.c#end_date rhvd_end_date
             ,
             a.c#person_id,
             a.as_date,
             a.c#part_coef,
             CASE WHEN pj.c#person_id IS NOT NULL THEN 'J' ELSE 'P' END person_tag,
             pj.c#name || pp.c#f_name || ' ' || pp.c#i_name || ' ' || pp.c#o_name person,
             pj.c#name org_name,
             pj.c#inn_num,
             pj.c#kpp_num,
             pp.c#f_name,
             pp.c#i_name,
             pp.c#o_name,
             CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#phone, '') ELSE NVL(pp.c#phone, '') END c#phone,
             CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#contact, '') ELSE NVL(pp.c#contact, '') END c#contact,
             CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#mail, '') ELSE NVL(pp.c#mail, '') END c#mail,
             CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#note, '') ELSE NVL(pp.c#note, '') END c#note,
             a.c#num account,
             a.c#id,
             ao.c#out_num,
             a.account_cpec_id,
             rs.c#area_val * a.c#part_coef area_part,
             (SELECT t.c#code || ' - ' || t.c#name
                 FROM t#out_proc t
                 WHERE t.c#id = ao.c#out_proc_id) || ' адрес доставки: ' ||
             TRIM(NVL2(pa.c#post_code, pa.c#post_code || ', ', '') ||
             NVL2(pa.c#1_text, pa.c#1_text || ' ', '') || pa.c#2_text) out_proc_name,
             NULLIF((select count(*) from T#SUPPORT_DOCUMS where C#TABLE_PARENT = 'T#ACCOUNT' and C#ID_RECORD = a.account_cpec_id),0) DOC_COUNT
        FROM t#rooms r,
             (SELECT r.c#id,
                     rs.c#date,
                     rsvd.c#living_tag,
                     rsvd.c#own_type_tag,
                     rsvd.c#area_val,
                     ROW_NUMBER() OVER (PARTITION BY rs.c#rooms_id ORDER BY rs.c#date DESC) c#rn
                 FROM t#rooms r,
                      t#rooms_spec rs,
                      (SELECT *
                          FROM t#rooms_spec_vd rsvd
                          WHERE 1 = 1
                            AND rsvd.c#valid_tag = 'Y'
                            AND rsvd.c#vn = (SELECT MAX(t.c#vn)
                                FROM t#rooms_spec_vd t
                                WHERE t.c#id = rsvd.c#id)) rsvd
                 WHERE 1 = 1
                   AND r.c#house_id = a#house_id
                   AND rs.c#rooms_id = r.c#id
                   AND rs.c#id = rsvd.c#id
                   AND rs.c#date <= a#date) rs,
             (SELECT a.*,
                     as1.c#id account_cpec_id,
                     avd.c#end_date,
                     as1.c#date as_date,
                     asvd.c#person_id,
                     asvd.c#part_coef,
                     ROW_NUMBER() OVER (PARTITION BY as1.c#account_id ORDER BY as1.c#date DESC) c#rn
                 FROM t#rooms r,
                      t#account a,
                      (SELECT *
                          FROM t#account_vd avd
                          WHERE 1 = 1
                            AND avd.c#valid_tag = 'Y'
                            AND avd.c#vn = (SELECT MAX(t.c#vn)
                                FROM t#account_vd t
                                WHERE t.c#id = avd.c#id)) avd,
                      t#account_spec as1,
                      (SELECT *
                          FROM t#account_spec_vd asvd
                          WHERE 1 = 1
                            AND asvd.c#valid_tag = 'Y'
                            AND asvd.c#vn = (SELECT MAX(t.c#vn)
                                FROM t#account_spec_vd t
                                WHERE t.c#id = asvd.c#id)) asvd
                 WHERE 1 = 1
                   AND r.c#house_id = a#house_id
                   AND a.c#rooms_id = r.c#id
                   AND a.c#id = avd.c#id
                   AND a.c#date <= a#date
                   --and (avd.c#end_date is null or avd.c#end_date > a#date)
                   AND a.c#id = as1.c#account_id
                   AND as1.c#id = asvd.c#id
                   AND as1.c#date <= a#date) a,
             t#person_j pj,
             t#person_p pp,
             (SELECT aop.c#account_id,
                     aop.c#out_proc_id,
                     aop.c#out_num,
                     CASE WHEN MAX(aop.c#date) OVER (PARTITION BY aop.c#account_id) = aop.c#date THEN 'Y' END c#max_tag
                 FROM t#account_op aop
                 WHERE 1 = 1
                   AND aop.c#date <= a#date) ao,
             t#person_addr pa
        WHERE 1 = 1
          AND r.c#house_id = a#house_id
          AND r.c#id = rs.c#id (+)
          AND rs.c#rn (+) = 1
          AND a.c#rooms_id (+) = r.c#id
          AND a.c#rn (+) = 1
          AND a.c#person_id = pj.c#person_id (+)
          AND a.c#person_id = pp.c#person_id (+)
          AND ao.c#account_id (+) = a.c#id
          AND ao.c#max_tag (+) = 'Y'
          AND a.c#person_id = pa.c#person_id (+)
        ORDER BY p#utils.get#addr_num(r.c#flat_num),
                 r.c#id;
      RETURN res;
    END;

  FUNCTION get#house_area(a#house_id NUMBER,
                          a#date     DATE)
    RETURN NUMBER
    IS
    BEGIN
      RETURN p#fcr_utils.get#house_area(a#house_id, a#date);
    END;

  FUNCTION lst#turnover_for_report(a#date_begin DATE,
                                   a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res     sys_refcursor;
      a#lo_mn NUMBER;
      a#hi_mn NUMBER;
    BEGIN
      a#lo_mn := p#mn_utils.get#mn(a#date_begin);
      a#hi_mn := p#mn_utils.get#mn(a#date_end);
      OPEN res FOR
      SELECT P#UTILS.GET#HOUSE_ADDR(r.c#house_id),
             r.c#flat_num
             --,a.c#rooms_id
             --,a.c#rooms_pn
             --,a.c#date
             --,a.c#end_date
             ,
             a.c#num
             --,a.c#sn
             --,aop.c#out_num
             --,t.c#account_id
             --  ,p#mn_utils.get#date(tt.c#mn) mn
             --  ,sg.c#0_c_vol --накопл. вх. объем
             --  ,sg.c#0_c_sum --накопл. вх. сальдо
             --  ,sg.c#0_mc_sum
             --  ,sg.c#0_m_sum
             --  ,sg.c#0_mp_sum
             --  ,sg.c#0_p_sum
             --  ,sg.c#0_fc_sum            
             --  ,sg.c#0_fp_sum            
             --  ,ch.c#1_c_vol --объем
             --  ,ch.c#1_c_sum --начислено
             --  ,op.c#1_mc_sum --изм. начисления
             --  ,op.c#1_m_sum --изменения
             --  ,op.c#1_mp_sum --изм. оплаты
             --  ,op.c#1_p_sum --оплачено
             --  ,op.c#1_fc_sum --начислено пени
             --  ,op.c#1_fp_sum --оплачено пени
             ,
             NVL(c#0_c_sum, 0) + NVL(c#0_mc_sum, 0) + NVL(c#0_m_sum, 0) - NVL(c#0_mp_sum, 0) -
             NVL(c#0_p_sum, 0) saldo_begin,
             ch.c#1_c_sum charging,
             NVL(c#1_mp_sum, 0) + NVL(c#1_p_sum, 0) payment,
             NVL(c#1_c_sum, 0) + NVL(c#1_mc_sum, 0) + NVL(c#1_m_sum, 0) - NVL(c#1_mp_sum, 0) -
             NVL(c#1_p_sum, 0) saldo_end,
             op.c#1_fp_sum peni --оплачено пени 
        FROM (SELECT DISTINCT c#account_id
                 FROM t#obj) t

             --    ,(select 181 + level - 1 "C#MN"
             --        from table(ttab#number(0))
             --       where 181 <= 183
             --      connect by level <= 183 - 181 + 1) tt

             ,
             (SELECT t.c#account_id
                     --,t.c#mn
                     ,
                     SUM(tt.c#c_vol) "C#0_C_VOL",
                     SUM(tt.c#c_sum) "C#0_C_SUM",
                     SUM(tt.c#mc_sum) "C#0_MC_SUM",
                     SUM(tt.c#m_sum) "C#0_M_SUM",
                     SUM(tt.c#mp_sum) "C#0_MP_SUM",
                     SUM(tt.c#p_sum) "C#0_P_SUM",
                     SUM(tt.c#fc_sum) "C#0_FC_SUM",
                     SUM(tt.c#fp_sum) "C#0_FP_SUM"

                 FROM t#store t,
                      t#storage tt,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   -- and t.c#mn >= 181
                   AND t.c#mn = 181
                   AND tt.c#account_id = t.c#account_id
                   AND tt.c#work_id = t.c#work_id
                   AND tt.c#doer_id = t.c#doer_id
                   AND tt.c#mn = (SELECT MAX(c#mn)
                       FROM t#storage
                       WHERE c#account_id = t.c#account_id
                         AND c#work_id = t.c#work_id
                         AND c#doer_id = t.c#doer_id
                         AND c#mn <= t.c#mn)
                   --and r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id
             --,t.c#mn
             ) sg -- накопления (входящие)
             ,
             (SELECT t.c#account_id
                     -- ,t.c#mn
                     ,
                     SUM(t.c#vol) "C#1_C_VOL",
                     SUM(t.c#sum) "C#1_C_SUM"
                 FROM t#charge t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#mn >= 181
                   AND t.c#mn <= 183
                   --     and r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id
             --,t.c#mn
             ) ch -- начисления
             ,
             (SELECT t.c#account_id
                     --,p#mn_utils.get#mn(t.c#date) "C#MN"
                     ,
                     SUM(CASE WHEN t.c#type_tag = 'MC' THEN t.c#sum END) "C#1_MC_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'M' THEN t.c#sum END) "C#1_M_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'MP' THEN t.c#sum END) "C#1_MP_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'P' THEN t.c#sum END) "C#1_P_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'FC' THEN t.c#sum END) "C#1_FC_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'FP' THEN t.c#sum END) "C#1_FP_SUM"

                 FROM v#op t,
                      t#account a,
                      t#rooms r,
                      t#account_op aop
                 WHERE 1 = 1
                   AND t.c#date >= p#mn_utils.get#date(181)
                   AND t.c#date < p#mn_utils.get#date(183 + 1)
                   AND t.c#valid_tag = 'Y'
                   --and r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                   AND a.c#id = aop.c#account_id (+)
                   AND a.c#date = aop.c#date (+)
                 GROUP BY t.c#account_id
             --,p#mn_utils.get#mn(t.c#date)
             ) op -- изменения и оплата
             ,
             v#account a,
             t#rooms r,
             t#account_op aop
        WHERE 1 = 1
          AND ((a.c#end_date IS NULL)
          OR (a.c#end_date > TO_DATE(TRIM('01.06.2014'), 'dd.mm.yyyy')))
          --and r.c#house_id = 1091
          AND (sg.c#account_id IS NOT NULL
          OR ch.c#account_id IS NOT NULL
          OR op.c#account_id IS NOT NULL)
          -- and r.c#house_id = a#house_id
          AND t.c#account_id = sg.c#account_id (+)
          --and tt.c#mn = sg.c#mn(+)
          AND t.c#account_id = ch.c#account_id (+)
          --and tt.c#mn = ch.c#mn(+)
          AND t.c#account_id = op.c#account_id (+)
          --and tt.c#mn = op.c#mn(+)
          AND a.c#id = t.c#account_id
          AND r.c#id = a.c#rooms_id
          AND a.c#id = aop.c#account_id (+)
          AND a.c#date = aop.c#date (+)
        ORDER BY t.c#account_id,
                 r.c#flat_num
      ;
      RETURN res;
    END;

  FUNCTION lst#turnover_all_house(a#date_begin DATE,
                                  a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res     sys_refcursor;
      a#lo_mn NUMBER;
      a#hi_mn NUMBER;
    BEGIN
      a#lo_mn := p#mn_utils.get#mn(a#date_begin);
      a#hi_mn := p#mn_utils.get#mn(a#date_end);
      OPEN res FOR
      SELECT r.c#house_id,
             r.c#flat_num,
             a.c#rooms_id,
             a.c#rooms_pn,
             a.c#date,
             a.c#end_date,
             a.c#num,
             a.c#sn,
             aop.c#out_num,
             t.c#account_id,
             p#mn_utils.get#date(tt.c#mn) mn,
             sg.c#0_c_vol --накопл. вх. объем
             ,
             sg.c#0_c_sum --накопл. вх. сальдо
             ,
             sg.c#0_mc_sum,
             sg.c#0_m_sum,
             sg.c#0_mp_sum,
             sg.c#0_p_sum,
             ch.c#1_c_vol --объем
             ,
             ch.c#1_c_sum --начислено
             ,
             op.c#1_mc_sum --изм. начисления
             ,
             op.c#1_m_sum --изменения
             ,
             op.c#1_mp_sum --изм. оплаты
             ,
             op.c#1_p_sum --оплачено
             ,
             NVL(c#0_c_sum, 0) + NVL(c#0_mc_sum, 0) + NVL(c#0_m_sum, 0) - NVL(c#0_mp_sum, 0) -
             NVL(c#0_p_sum, 0) debt,
             NVL(c#1_c_sum, 0) + NVL(c#1_mc_sum, 0) + NVL(c#1_m_sum, 0) - NVL(c#1_mp_sum, 0) -
             NVL(c#1_p_sum, 0) debt1
        FROM (SELECT DISTINCT c#account_id
                 FROM t#obj) t,
             (SELECT a#lo_mn + LEVEL - 1 "C#MN"
                 FROM TABLE (ttab#number(0))
                 WHERE a#lo_mn <= a#hi_mn
               CONNECT BY LEVEL <= a#hi_mn - a#lo_mn + 1) tt,
             (SELECT t.c#account_id,
                     t.c#mn,
                     SUM(tt.c#c_vol) "C#0_C_VOL",
                     SUM(tt.c#c_sum) "C#0_C_SUM",
                     SUM(tt.c#mc_sum) "C#0_MC_SUM",
                     SUM(tt.c#m_sum) "C#0_M_SUM",
                     SUM(tt.c#mp_sum) "C#0_MP_SUM",
                     SUM(tt.c#p_sum) "C#0_P_SUM"
                 FROM t#store t,
                      t#storage tt,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#mn >= a#lo_mn
                   AND t.c#mn <= a#hi_mn
                   AND tt.c#account_id = t.c#account_id
                   AND tt.c#work_id = t.c#work_id
                   AND tt.c#doer_id = t.c#doer_id
                   AND tt.c#mn = (SELECT MAX(c#mn)
                       FROM t#storage
                       WHERE c#account_id = t.c#account_id
                         AND c#work_id = t.c#work_id
                         AND c#doer_id = t.c#doer_id
                         AND c#mn <= t.c#mn)
                   --and r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#mn) sg -- накопления (входящие)
             ,
             (SELECT t.c#account_id,
                     t.c#mn,
                     SUM(t.c#vol) "C#1_C_VOL",
                     SUM(t.c#sum) "C#1_C_SUM"
                 FROM t#charge t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#mn >= a#lo_mn
                   AND t.c#mn <= a#hi_mn
                   --     and r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#mn) ch -- начисления
             ,
             (SELECT t.c#account_id,
                     p#mn_utils.get#mn(t.c#date) "C#MN",
                     SUM(CASE WHEN t.c#type_tag = 'MC' THEN t.c#sum END) "C#1_MC_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'M' THEN t.c#sum END) "C#1_M_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'MP' THEN t.c#sum END) "C#1_MP_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'P' THEN t.c#sum END) "C#1_P_SUM"
                 FROM v#op t,
                      t#account a,
                      t#rooms r,
                      t#account_op aop
                 WHERE 1 = 1
                   AND t.c#date >= p#mn_utils.get#date(a#lo_mn)
                   AND t.c#date < p#mn_utils.get#date(a#hi_mn + 1)
                   AND t.c#valid_tag = 'Y'
                   --and r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                   AND a.c#id = aop.c#account_id (+)
                   AND a.c#date = aop.c#date (+)
                 GROUP BY t.c#account_id,
                          p#mn_utils.get#mn(t.c#date)) op -- изменения и оплата
             ,
             v#account a,
             t#rooms r,
             t#account_op aop
        WHERE 1 = 1
          AND (sg.c#account_id IS NOT NULL
          OR ch.c#account_id IS NOT NULL
          OR op.c#account_id IS NOT NULL)
          -- and r.c#house_id = a#house_id
          AND t.c#account_id = sg.c#account_id (+)
          AND tt.c#mn = sg.c#mn (+)
          AND t.c#account_id = ch.c#account_id (+)
          AND tt.c#mn = ch.c#mn (+)
          AND t.c#account_id = op.c#account_id (+)
          AND tt.c#mn = op.c#mn (+)
          AND a.c#id = t.c#account_id
          AND r.c#id = a.c#rooms_id
          AND a.c#id = aop.c#account_id (+)
          AND a.c#date = aop.c#date (+)
        ORDER BY t.c#account_id,
                 tt.c#mn;
      RETURN res;
    END;

  FUNCTION lst#turnover(a#house_id   NUMBER,
                        a#date_begin DATE,
                        a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res     sys_refcursor;
      a#lo_mn NUMBER;
      a#hi_mn NUMBER;
    BEGIN
      a#lo_mn := p#mn_utils.get#mn(a#date_begin);
      a#hi_mn := p#mn_utils.get#mn(a#date_end);
      OPEN res FOR
      
      SELECT r.c#flat_num,
             a.c#rooms_id,
             a.c#rooms_pn,
             a.c#date,
             a.c#end_date,
             a.c#num,
             a.c#sn,
             aop.c#out_num,
             t.c#account_id,
             p#mn_utils.get#date(tt.c#mn) mn,
             sg.c#0_c_vol --накопл. вх. объем
             ,
             sg.c#0_c_sum --накопл. вх. сальдо
             ,
             sg.c#0_mc_sum,
             sg.c#0_m_sum,
             sg.c#0_mp_sum,
             sg.c#0_p_sum,
             ch.c#1_c_vol --объем
             ,
             ch.c#1_c_sum --начислено
             ,
             op.c#1_mc_sum --изм. начисления
             ,
             op.c#1_m_sum --изменения
             ,
             op.c#1_mp_sum --изм. оплаты
             ,
             op.c#1_p_sum --оплачено
             ,
             NVL(c#0_c_sum, 0) + NVL(c#0_mc_sum, 0) + NVL(c#0_m_sum, 0) - NVL(c#0_mp_sum, 0) -
             NVL(c#0_p_sum, 0) debt,
             NVL(c#1_c_sum, 0) + NVL(c#1_mc_sum, 0) + NVL(c#1_m_sum, 0) - NVL(c#1_mp_sum, 0) -
             NVL(c#1_p_sum, 0) debt1
        FROM (SELECT DISTINCT c#account_id
                 FROM t#obj) t,
             (SELECT a#lo_mn + LEVEL - 1 "C#MN"
                 FROM TABLE (ttab#number(0))
                 WHERE a#lo_mn <= a#hi_mn
               CONNECT BY LEVEL <= a#hi_mn - a#lo_mn + 1) tt,
             (
                          
                    SELECT
                        account_id c#account_id,
                        mn C#mn,
                        0  "C#0_C_VOL",
                        CHARGE_SUM_TOTAL  "C#0_C_SUM",
                        0 "C#0_MC_SUM",
                        0  "C#0_M_SUM",
                        0 "C#0_MP_SUM",
                        PAY_SUM_TOTAL  "C#0_P_SUM"
                    FROM
                        T#TOTAL_ACCOUNT
                    WHERE  mn BETWEEN a#lo_mn and a#hi_mn
                          AND house_id = a#house_id
                          
                          
                          ) sg -- накопления (входящие)
             ,
             (SELECT t.c#account_id,
                     t.c#a_mn c#mn,
                     SUM(t.c#vol) "C#1_C_VOL",
                     SUM(t.c#sum) "C#1_C_SUM"
                 FROM t#charge t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#a_mn >= a#lo_mn
                   AND t.c#a_mn <= a#hi_mn
                   AND r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#a_mn) ch -- начисления
             ,
             (SELECT t.c#account_id,
                     p#mn_utils.get#mn(t.c#real_date) "C#MN",
                     SUM(CASE WHEN t.c#type_tag = 'MC' THEN t.c#sum END) "C#1_MC_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'M' THEN t.c#sum END) "C#1_M_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'MP' THEN t.c#sum END) "C#1_MP_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'P' THEN t.c#sum END) "C#1_P_SUM"
                 FROM v#op t,
                      t#account a,
                      t#rooms r,
                      t#account_op aop
                 WHERE 1 = 1
                   AND t.c#real_date >= p#mn_utils.get#date(a#lo_mn)
                   AND t.c#real_date < p#mn_utils.get#date(a#hi_mn + 1)
                   AND t.c#valid_tag = 'Y'
                   AND r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                   AND a.c#id = aop.c#account_id (+)
                   AND a.c#date = aop.c#date (+)
                 GROUP BY t.c#account_id,
                          p#mn_utils.get#mn(t.c#real_date)) op -- изменения и оплата
             ,
             v#account a,
             t#rooms r,
             t#account_op aop
        WHERE 1 = 1
          AND (sg.c#account_id IS NOT NULL
          OR ch.c#account_id IS NOT NULL
          OR op.c#account_id IS NOT NULL)
          AND r.c#house_id = a#house_id
          AND t.c#account_id = sg.c#account_id (+)
          AND tt.c#mn = sg.c#mn (+)
          AND t.c#account_id = ch.c#account_id (+)
          AND tt.c#mn = ch.c#mn (+)
          AND t.c#account_id = op.c#account_id (+)
          AND tt.c#mn = op.c#mn (+)
          AND a.c#id = t.c#account_id
          AND r.c#id = a.c#rooms_id
          AND a.c#id = aop.c#account_id (+)
          AND a.c#date = aop.c#date (+)
        ORDER BY t.c#account_id,
                 tt.c#mn;

      RETURN res;
    END;

  FUNCTION lst#turnover2(a#house_id   NUMBER,
                         a#date_begin DATE,
                         a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res     sys_refcursor;
      a#lo_mn NUMBER;
      a#hi_mn NUMBER;
    BEGIN
    return res;
      a#lo_mn := p#mn_utils.get#mn(a#date_begin);
      a#hi_mn := p#mn_utils.get#mn(a#date_end);
      OPEN res FOR
      SELECT r.c#flat_num,
             a.c#rooms_id,
             a.c#rooms_pn,
             a.c#date,
             a.c#end_date,
             a.c#num,
             a.c#sn,
             aop.c#out_num,
             t.c#account_id,
             p#mn_utils.get#date(tt.c#mn) mn,
             NULL c#0_c_vol --накопл. вх. объем
             ,
             NULL c#0_c_sum --накопл. вх. сальдо
             ,
             NULL c#0_mc_sum,
             NULL c#0_m_sum,
             NULL c#0_mp_sum,
             NULL c#0_p_sum,
             ch.c#1_c_vol --объем
             ,
             ch.c#1_c_sum --начислено
             ,
             op.c#1_mc_sum --изм. начисления
             ,
             op.c#1_m_sum --изменения
             ,
             op.c#1_mp_sum --изм. оплаты
             ,
             op.c#1_p_sum --оплачено
             ,
             NULL debt,
             NVL(c#1_c_sum, 0) + NVL(c#1_mc_sum, 0) + NVL(c#1_m_sum, 0) - NVL(c#1_mp_sum, 0) -
             NVL(c#1_p_sum, 0) debt1
        FROM (SELECT DISTINCT c#account_id
                 FROM t#obj) t,
             (SELECT a#lo_mn + LEVEL - 1 "C#MN"
                 FROM TABLE (ttab#number(0))
                 WHERE a#lo_mn <= a#hi_mn
               CONNECT BY LEVEL <= a#hi_mn - a#lo_mn + 1) tt,
             (SELECT t.c#account_id,
                     t.c#a_mn "C#MN",
                     SUM(t.c#vol) "C#1_C_VOL",
                     SUM(t.c#sum) "C#1_C_SUM"
                 FROM t#charge t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#a_mn >= a#lo_mn
                   AND t.c#a_mn <= a#hi_mn
                   AND r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#a_mn) ch -- начисления
             ,
             (SELECT t.c#account_id,
                     t.c#a_mn "C#MN",
                     SUM(CASE WHEN t.c#type_tag = 'MC' THEN t.c#sum END) "C#1_MC_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'M' THEN t.c#sum END) "C#1_M_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'MP' THEN t.c#sum END) "C#1_MP_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'P' THEN t.c#sum END) "C#1_P_SUM"
                 FROM v#op t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#a_mn >= a#lo_mn
                   AND t.c#a_mn <= a#hi_mn
                   AND t.c#valid_tag = 'Y'
                   AND r.c#house_id = a#house_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#a_mn) op -- изменения и оплата
             ,
             v#account a,
             t#rooms r,
             t#account_op aop
        WHERE 1 = 1
          AND (ch.c#account_id IS NOT NULL
          OR op.c#account_id IS NOT NULL)
          AND r.c#house_id = a#house_id
          AND t.c#account_id = ch.c#account_id (+)
          AND tt.c#mn = ch.c#mn (+)
          AND t.c#account_id = op.c#account_id (+)
          AND tt.c#mn = op.c#mn (+)
          AND a.c#id = t.c#account_id
          AND r.c#id = a.c#rooms_id
          AND a.c#id = aop.c#account_id (+)
          AND a.c#date = aop.c#date (+)
        ORDER BY t.c#account_id,
                 tt.c#mn;

      RETURN res;
    END;

  PROCEDURE ins#account_vd(a#id          NUMBER,
                           a#person_id   NUMBER,
                           a#c#part_coef NUMBER)
    IS
      vn NUMBER;
    BEGIN
      SELECT MAX(t.c#vn) + 1
        INTO vn
        FROM t#account_spec_vd t
        WHERE t.c#id = a#id;
      INSERT INTO t#account_spec_vd (
        c#id, c#vn, c#valid_tag, c#person_id, c#part_coef, c#sign_date, c#sign_s_id
      )
      VALUES (a#id, NVL(vn, 1), 'Y', a#person_id, a#c#part_coef, sysdate, 1);
      COMMIT;
    END;

  FUNCTION ins#person(a#f_name      VARCHAR2,
                      a#i_name      VARCHAR2,
                      a#o_name      VARCHAR2,
                      a#j_name      VARCHAR2,
                      a#inn_num     NUMBER,
                      a#kpp_num     NUMBER,
                      a#phone   IN  VARCHAR2 DEFAULT '',
                      a#contact IN  VARCHAR2 DEFAULT '',
                      a#mail    IN  VARCHAR2 DEFAULT '',
                      a#note    IN  VARCHAR2 DEFAULT '',
                      a#person_type VARCHAR2)
    RETURN NUMBER
    IS
      person_id NUMBER;
    BEGIN
      INSERT INTO t#person (
        c#id
      )
      VALUES (s#person.NEXTVAL) RETURNING c#id INTO person_id;
      CASE
        WHEN a#person_type = 'P' THEN INSERT INTO t#person_p (
              c#person_id, c#f_name, c#i_name, c#o_name, c#phone, c#note, c#contact, c#mail
            )
            VALUES (person_id, a#f_name, a#i_name, a#o_name, a#phone, a#note, a#contact, a#mail);
        WHEN a#person_type = 'J' THEN INSERT INTO t#person_j (
              c#person_id, c#name, c#inn_num, c#kpp_num, c#phone, c#note, c#contact, c#mail
            )
            VALUES (person_id, a#j_name, a#inn_num, a#kpp_num, a#phone, a#note, a#contact, a#mail);
      END CASE;
      RETURN person_id;
    END;

  PROCEDURE ins#person_addr(a#person_id NUMBER,
                            a#post_code VARCHAR2,
                            a#1_text    VARCHAR2,
                            a#2_text    VARCHAR2)
    IS
    BEGIN
      INSERT INTO t#person_addr (
        c#person_id, c#post_code, c#1_text, c#2_text
      )
      VALUES (a#person_id, a#post_code, a#1_text, a#2_text);
    END;

  PROCEDURE upd#person_addr(a#person_id NUMBER,
                            a#post_code VARCHAR2,
                            a#1_text    VARCHAR2,
                            a#2_text    VARCHAR2)
    IS
    BEGIN
      MERGE INTO t#person_addr p
      USING dual
      ON (p.c#person_id = a#person_id)
      WHEN MATCHED THEN UPDATE
        SET p.c#post_code = a#post_code, p.c#1_text = a#1_text, p.c#2_text = a#2_text
      WHEN NOT MATCHED THEN INSERT
      VALUES (a#person_id, a#post_code, a#1_text, a#2_text);
      COMMIT;
    END;

  PROCEDURE upd#person(a#person_id    NUMBER,
                       a#f_name       VARCHAR2,
                       a#i_name       VARCHAR2,
                       a#o_name       VARCHAR2,
                       a#j_name       VARCHAR2,
                       a#inn_num      NUMBER,
                       a#kpp_num      NUMBER,
                       a#phone     IN VARCHAR2 DEFAULT '',
                       a#contact   IN VARCHAR2 DEFAULT '',
                       a#mail      IN VARCHAR2 DEFAULT '',
                       a#note      IN VARCHAR2 DEFAULT '',
                       a#person_type  VARCHAR2)
    IS
    BEGIN
      CASE
        WHEN a#person_type = 'P' THEN UPDATE t#person_p
              SET c#f_name = a#f_name, c#i_name = a#i_name, c#o_name = a#o_name, c#phone = a#phone, c#contact = a#contact, c#mail = a#mail, c#note = a#note
              WHERE c#person_id = a#person_id;
        WHEN a#person_type = 'J' THEN UPDATE t#person_j
              SET c#name = a#j_name, c#inn_num = a#inn_num, c#kpp_num = a#kpp_num, c#phone = a#phone, c#contact = a#contact, c#mail = a#mail, c#note = a#note
              WHERE c#person_id = a#person_id;
      END CASE;
      COMMIT;
    END;

  FUNCTION lst#person_addr(a#person_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT pa.c#post_code,
             pa.c#1_text,
             pa.c#2_text
        FROM t#person_addr pa
        WHERE pa.c#person_id = a#person_id;
      RETURN res;
    END;

  FUNCTION lst#room_data(a#rooms_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT rs.c#id,
             rs.c#rooms_id,
             rs.c#date,
             rsvd.c#living_tag,
             rsvd.c#own_type_tag,
             rsvd.c#area_val,
             rsvd.c#vn,
             CASE WHEN rsvd.c#valid_tag = 'Y' THEN 1 ELSE 0 END v,
             r.c#flat_num
        FROM t#rooms_spec rs,
             (SELECT *
                 FROM t#rooms_spec_vd rsvd
                 WHERE 1 = 1
                   AND rsvd.c#vn = (SELECT MAX(t.c#vn)
                       FROM t#rooms_spec_vd t
                       WHERE t.c#id = rsvd.c#id)) rsvd,
             t#rooms r
        WHERE 1 = 1
          AND r.c#id = a#rooms_id
          AND rs.c#rooms_id = r.c#id
          AND rs.c#id = rsvd.c#id;
      RETURN res;
    END;

  PROCEDURE ins#room_spec_vd(a#room_spec_id NUMBER,
                             a#living_tag   VARCHAR2,
                             a#own_type_tag VARCHAR2,
                             a#area_val     NUMBER,
                             a#valid_tag    VARCHAR2,
                             a#vn           NUMBER)
    IS
      vn NUMBER;
    BEGIN
      INSERT INTO t#rooms_spec_vd (
        c#id, c#vn, c#valid_tag, c#sign_date, c#sign_s_id, c#living_tag, c#own_type_tag, c#area_val
      )
      VALUES (a#room_spec_id, a#vn, a#valid_tag, sysdate, 1, a#living_tag, a#own_type_tag, a#area_val);
    END;

  FUNCTION ins#room(a#flat_num     string,
                    a#house_id     NUMBER,
                    a#date         DATE,
                    a#living_tag   VARCHAR2,
                    a#own_type_tag VARCHAR2,
                    a#area_val     NUMBER)
    RETURN NUMBER
    IS
      r_id NUMBER;
    BEGIN
      INSERT INTO t#rooms (
        c#house_id, c#flat_num
      )
      VALUES (a#house_id, a#flat_num) RETURNING c#id INTO r_id;

      ins#room_spec(r_id, a#date, a#living_tag, a#own_type_tag, a#area_val);

      ins#rooms_part(r_id);

      RETURN r_id;
    END;

  PROCEDURE ins#room_spec(a#room_id      NUMBER,
                          a#date         DATE,
                          a#living_tag   VARCHAR2,
                          a#own_type_tag VARCHAR2,
                          a#area_val     NUMBER)
    IS
      rs_id NUMBER;
      vn    NUMBER;
    BEGIN
      INSERT INTO t#rooms_spec (
        c#rooms_id, c#date
      )
      VALUES (a#room_id, a#date) RETURNING c#id INTO rs_id;

      SELECT MAX(c#vn) + 1
        INTO vn
        FROM t#rooms_spec_vd
        WHERE c#id = rs_id;

      ins#room_spec_vd(rs_id, a#living_tag, a#own_type_tag, a#area_val, 'Y', NVL(vn, 1));
    END;

  FUNCTION get#vn_rsvd(a#id NUMBER)
    RETURN NUMBER
    IS
      res NUMBER;
    BEGIN
      SELECT MAX(c#vn) + 1
        INTO res
        FROM t#rooms_spec_vd
        WHERE c#id = a#id;
      RETURN NVL(res, 1);
    END;

  PROCEDURE upd#room_spec_vd(a#room_id          NUMBER,
                             a#room_spec_id     NUMBER,
                             a#living_tag_old   VARCHAR2,
                             a#own_type_tag_old VARCHAR2,
                             a#area_val_old     NUMBER,
                             a#living_tag_new   VARCHAR2,
                             a#own_type_tag_new VARCHAR2,
                             a#area_val_new     NUMBER,
                             a#vn_new           NUMBER)
    IS
      vn NUMBER;
    BEGIN
      ins#room_spec_vd(a#room_spec_id
      , a#living_tag_new
      , a#own_type_tag_new
      , a#area_val_new
      , 'Y'
      , a#vn_new);
    END;

  PROCEDURE upd#room(a#room_id  NUMBER,
                     a#date     DATE,
                     a#flat_num VARCHAR2)
    IS
      vn NUMBER;
    BEGIN
      INSERT INTO tt#tr_flag (
        c#val
      )
      VALUES ('ROOMS_SPEC#PASS_MOD');
      UPDATE t#rooms r
        SET r.c#flat_num = a#flat_num
        WHERE r.c#id = a#room_id;
      UPDATE fcr.t#rooms_spec r
        SET r.c#date = a#date
        WHERE r.c#id = a#room_id;
      COMMIT;
    END;

  PROCEDURE upd#room_date(a#room_id NUMBER,
                          a#date    DATE)
    IS
      vn NUMBER;
    BEGIN
      UPDATE fcr.t#rooms_spec r
        SET r.c#date = a#date
        WHERE r.c#rooms_id = (SELECT c#id
            FROM fcr.t#rooms
            WHERE c#id = a#room_id);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          dbms_output.put_line('Rollback UPD#ROOM_DATE : ' || SQLCODE || ', ' || SQLERRM);
    END;

  PROCEDURE del#room_spec_vd(a#room_spec_id NUMBER,
                             a#living_tag   VARCHAR2,
                             a#own_type_tag VARCHAR2,
                             a#area_val     NUMBER,
                             a#vn_new       NUMBER)
    IS
      vn NUMBER;
    BEGIN
      ins#room_spec_vd(a#room_spec_id, a#living_tag, a#own_type_tag, a#area_val, 'N', a#vn_new);
      COMMIT;
    END;

  FUNCTION lst#rooms_part(a#room_id NUMBER,
                          a#date    DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT a.account_id,
             a.account_spec_id,
             NVL(a.c#rooms_id, rp.c#rooms_id) c#rooms_id,
             a.c#person_id,
             NVL(a.c#rooms_pn, rp.c#rooms_pn) c#rooms_pn,
             a.c#date,
             a.account_num,
             a.c#end_date,
             a.person,
             a.c#part_coef,
             a.c#sn,
             a.c#house_id
        FROM t#rooms_part rp,
             (SELECT a.c#id account_id,
                     as1.c#id account_spec_id,
                     a.c#rooms_id,
                     asvd.c#person_id,
                     a.c#rooms_pn
                     --                    ,a.c#date
                     ,
                     a.c#num account_num,
                     a.c#sn,
                     avd.c#end_date,
                     pj.c#name || pp.c#f_name || ' ' || pp.c#i_name || ' ' || pp.c#o_name person,
                     asvd.c#part_coef,
                     r.c#house_id,
                     as1.c#date
                 FROM t#rooms r,
                      t#account a,
                      (SELECT *
                          FROM t#account_vd avd
                          WHERE 1 = 1
                            AND avd.c#valid_tag = 'Y'
                            AND avd.c#vn = (SELECT MAX(t.c#vn)
                                FROM t#account_vd t
                                WHERE t.c#id = avd.c#id)) avd,
                      t#account_spec as1,
                      (SELECT *
                          FROM t#account_spec_vd asvd
                          WHERE 1 = 1
                            AND asvd.c#valid_tag = 'Y'
                            AND asvd.c#vn = (SELECT MAX(t.c#vn)
                                FROM t#account_spec_vd t
                                WHERE t.c#id = asvd.c#id)) asvd,
                      t#person_j pj,
                      t#person_p pp,
                      t#rooms_part rp
                 WHERE 1 = 1
                   AND r.c#id = a#room_id
                   AND a.c#rooms_id = r.c#id
                   AND a.c#id = avd.c#id
                   AND a.c#id = as1.c#account_id
                   AND as1.c#id = asvd.c#id
                   AND asvd.c#person_id = pj.c#person_id (+)
                   AND asvd.c#person_id = pp.c#person_id (+)
                   AND as1.c#date <= a#date -- f#work_date
                   AND rp.c#rooms_id = a.c#rooms_id (+)
                   AND rp.c#rooms_pn = a.c#rooms_pn (+)) a
        WHERE 1 = 1
          AND rp.c#rooms_id = a#room_id
          AND rp.c#rooms_id = a.c#rooms_id (+)
          AND rp.c#rooms_pn = a.c#rooms_pn (+)
        ORDER BY a.account_num;
      RETURN res;
    END;

  FUNCTION get#room_pn(a#room_id NUMBER)
    RETURN NUMBER
    IS
      res NUMBER;
    BEGIN
      SELECT MAX(a.c#rooms_pn) + 1
        INTO res
        FROM t#rooms_part a
        WHERE a.c#rooms_id = a#room_id;
      RETURN NVL(res, 1);
    END;

  FUNCTION lst#rooms_part(a#room_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#rooms_id,
             t.c#rooms_pn
        FROM t#rooms_part t
        WHERE t.c#rooms_id = a#room_id;
      RETURN res;
    END;

  PROCEDURE ins#rooms_part(a#room_id NUMBER)
    IS
      pn NUMBER;
    BEGIN
      pn := get#room_pn(a#room_id);
      INSERT INTO t#rooms_part (
        c#rooms_id, c#rooms_pn
      )
      VALUES (a#room_id, pn);
      COMMIT;
    END;

  function add#rooms_part(a#room_id NUMBER) return NUMBER
    IS
      pn NUMBER;
    BEGIN
      pn := get#room_pn(a#room_id);
      INSERT INTO t#rooms_part (
        c#rooms_id, c#rooms_pn
      )
      VALUES (a#room_id, pn);
      return pn;
    END;


  PROCEDURE del#rooms_part(a#rooms_id NUMBER,
                           a#rooms_pn NUMBER)
    IS
    BEGIN
      DELETE FROM t#rooms_part p
        WHERE 1 = 1
          AND p.c#rooms_id = a#rooms_id
          AND p.c#rooms_pn = a#rooms_pn;
      COMMIT;
    END;

  FUNCTION get#account_pn(a#rooms_id NUMBER,
                          a#rooms_pn NUMBER)
    RETURN NUMBER
    IS
      res NUMBER;
    BEGIN
      SELECT COUNT(a.c#id)
        INTO res
        FROM t#account a
        WHERE 1 = 1
          AND a.c#rooms_id = a#rooms_id
          AND a.c#rooms_pn = a#rooms_pn;
      RETURN res;
    END;

  FUNCTION get#account_num(a#house_id NUMBER)
    RETURN VARCHAR2
    IS
      res VARCHAR2(15);
    BEGIN
      res := p#fcr_utils.do#account_num(a#house_id);
      RETURN res;
    END;

  PROCEDURE do#account(a#rooms_id  NUMBER,
                       a#rooms_pn  NUMBER,
                       a#date      DATE,
                       a#num       VARCHAR2,
                       a#sn        NUMBER,
                       a#person_id NUMBER,
                       a#part_coef NUMBER)
    IS
      a_id   NUMBER;
      a_s_id NUMBER;
    BEGIN
      INSERT INTO t#rooms_part (
        c#rooms_id, c#rooms_pn
      )
        SELECT a#rooms_id,
               a#rooms_pn
          FROM TABLE (ttab#number(0))
          WHERE NOT EXISTS (SELECT 1
                FROM t#rooms_part t
                WHERE 1 = 1
                  AND t.c#rooms_id = a#rooms_id
                  AND t.c#rooms_pn = a#rooms_pn);

      INSERT INTO t#account (
        c#rooms_id, c#rooms_pn, c#date, c#num, c#sn
      )
      VALUES (a#rooms_id, a#rooms_pn, a#date, a#num, a#sn) RETURNING c#id INTO a_id;

      INSERT INTO t#account_vd (
        c#id, c#vn, c#valid_tag
      )
      VALUES (a_id, 1, 'Y');

      INSERT INTO t#account_spec (
        c#account_id, c#date
      )
      VALUES (a_id, a#date) RETURNING c#id INTO a_s_id;

      INSERT INTO t#account_spec_vd (
        c#id, c#vn, c#valid_tag, c#person_id, c#part_coef
      )
      VALUES (a_s_id, 1, 'Y', a#person_id, a#part_coef);
    END;

  PROCEDURE upd#account(a#account_id      NUMBER,
                        a#rooms_id        NUMBER,
                        a#rooms_pn        NUMBER,
                        a#date_beg        DATE,
                        a#date_end        DATE,
                        a#num             VARCHAR2,
                        a#sn              NUMBER,
                        a#person_id       NUMBER,
                        a#part_coef       NUMBER,
                        a#account_spec_id NUMBER)
    IS
      vn       NUMBER;
      a#status NUMBER;
      a#date   DATE;
    BEGIN
      COMMIT;
      INSERT INTO tt#tr_flag (
        c#val
      )
      VALUES ('ACCOUNT#PASS_MOD');
      UPDATE t#account a
        SET a.c#num = a#num, a.c#sn = a#sn
        WHERE a.c#id = a#account_id;

      SELECT MAX(t.c#vn) + 1
        INTO vn
        FROM t#account_vd t
        WHERE t.c#id = a#account_id;
      INSERT INTO t#account_vd (
        c#id, c#vn, c#valid_tag, c#end_date
      )
      VALUES (a#account_id, NVL(vn, 1), 'Y', a#date_end);

      SELECT MAX(t.c#vn) + 1
        INTO vn
        FROM t#account_spec_vd t
        WHERE t.c#id = a#account_spec_id;
      INSERT INTO t#account_spec_vd (
        c#id, c#vn, c#valid_tag, c#person_id, c#part_coef
      )
      VALUES (a#account_spec_id, NVL(vn, 1), 'Y', a#person_id, a#part_coef);
      COMMIT;

      SELECT c#date
        INTO a#date
        FROM fcr.t#account
        WHERE c#id = a#account_id;
      -- изменяем дату ввода счета
      IF ((NOT a#date_beg IS NULL)
        AND (a#date_beg <> a#date))
      THEN
        fcr.UPD#ACCOUNT_ID_DATE_BEGIN(a#account_id, a#date_beg);
      END IF;

      -- выполняем перерасчет
--      fcr.DO#RECALC_ACCOUNT(a#num, current_date);

      -- снятие начислений и их перерасчет при закрытии и открытиии счета 
      IF ((NOT a#date_end IS NULL) 
                and (P#TOOLS.house_is_open(a#account_id) = 'Y')) -- добавлено 16.02.2018 чтобы не пересчитывались счета на закрытых домах
      THEN
        --  fcr.do#close_account(a#date_end,a#account_id, A#STATUS);   
        fcr.storno#ul#pay(a#account_id, current_date);
      END IF;

--      fcr.DO#RECALC_ACCOUNT(a#num, current_date);


      COMMIT;
    END;

  FUNCTION lst#outproc
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#id,
             t.c#code,
             t.c#name
        FROM t#out_proc t
        ORDER BY 2,
                 1;
      RETURN res;
    END;

  PROCEDURE ins#outproc(a#code NUMBER,
                        a#name VARCHAR2)
    IS
    BEGIN
      INSERT INTO t#out_proc (
        c#code, c#name
      )
      VALUES (a#code, a#name);
      COMMIT;
    END;

  PROCEDURE upd#outproc(a#id   NUMBER,
                        a#code NUMBER,
                        a#name VARCHAR2)
    IS
    BEGIN
      UPDATE t#out_proc t
        SET t.c#code = a#code, t.c#name = a#name
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  PROCEDURE del#outproc(a#id NUMBER)
    IS
    BEGIN
      DELETE FROM t#out_proc t
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  FUNCTION lst#bank
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#id,
             t.c#name,
             t.c#bic_num,
             t.c#ca_num
        FROM t#bank t
        ORDER BY 2,
                 1;
      RETURN res;
    END;

  PROCEDURE ins#bank(a#name    VARCHAR2,
                     a#bic_num VARCHAR2,
                     a#ca_num  VARCHAR2)
    IS
    BEGIN
      INSERT INTO t#bank (
        c#name, c#bic_num, c#ca_num
      )
      VALUES (a#name, a#bic_num, a#ca_num);
      COMMIT;
    END;

  PROCEDURE upd#bank(a#id      NUMBER,
                     a#name    VARCHAR2,
                     a#bic_num VARCHAR2,
                     a#ca_num  VARCHAR2)
    IS
    BEGIN
      UPDATE t#bank t
        SET t.c#name = a#name, t.c#bic_num = a#bic_num, t.c#ca_num = a#ca_num
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  PROCEDURE del#bank(a#id NUMBER)
    IS
    BEGIN
      DELETE FROM t#bank t
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  FUNCTION lst#doer
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#id,
             t.c#name,
             t.c#code,
             t.c#charge_tag
        FROM t#doer t
        ORDER BY 2,
                 1;
      RETURN res;
    END;

  PROCEDURE ins#doer(a#name       VARCHAR2,
                     a#code       VARCHAR2,
                     a#charge_tag VARCHAR2)
    IS
    BEGIN
      INSERT INTO t#doer (
        c#name, c#code, c#charge_tag
      )
      VALUES (a#name, a#code, a#charge_tag);
      COMMIT;
    END;

  PROCEDURE upd#doer(a#id         NUMBER,
                     a#name       VARCHAR2,
                     a#code       VARCHAR2,
                     a#charge_tag VARCHAR2)
    IS
    BEGIN
      UPDATE t#doer t
        SET t.c#name = a#name, t.c#code = a#code, t.c#charge_tag = a#charge_tag
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  PROCEDURE del#doer(a#id NUMBER)
    IS
    BEGIN
      DELETE FROM t#doer t
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  FUNCTION lst#ops_kind
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#id,
             t.c#name,
             t.c#cod
        FROM t#ops_kind t
        ORDER BY 2,
                 1;
      RETURN res;
    END;

  PROCEDURE ins#ops_kind(a#name VARCHAR2,
                         a#code VARCHAR2)
    IS
    BEGIN
      INSERT INTO t#ops_kind (
        c#name, c#cod
      )
      VALUES (a#name, a#code);
      COMMIT;
    END;

  PROCEDURE upd#ops_kind(a#id   NUMBER,
                         a#name VARCHAR2,
                         a#code VARCHAR2)
    IS
    BEGIN
      UPDATE t#ops_kind t
        SET t.c#name = a#name, t.c#cod = a#code
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  PROCEDURE del#ops_kind(a#id NUMBER)
    IS
    BEGIN
      DELETE FROM t#ops_kind t
        WHERE t.c#id = a#id;
      COMMIT;
    END;

  FUNCTION lst#bank_exp(a#date DATE)
    RETURN sys_refcursor
    IS
      res   sys_refcursor;
--      vdate NUMBER := p#mn_utils.get#mn(a#date) + 1;
      vdate NUMBER;
    BEGIN
        select max(mn) into vdate from V_BANK_EXP;
      vdate := least(p#mn_utils.get#mn(a#date),vdate);
--      FOR cr#i IN (SELECT t.c#id
--          FROM t#house t
--          ORDER BY 1)
--      LOOP
--        do#calc_b_store(cr#i.c#id, vdate);
--        COMMIT;
--      END LOOP;

      OPEN res FOR
      SELECT
             V.B_ACCOUNT_ID c#id,
             b.c#id bank_id,
             ba.c#num "C#R_NUM" --получатель, счёт
             ,
             ba.c#name "C#R_NAME" --получатель, имя
             ,
             ba.c#inn_num "C#R_INN_NUM" --получатель, инн
             ,
             ba.c#kpp_num "C#R_KPP_NUM" --получатель, кпп
             ,
             b.c#name "C#BR_NAME" --банк получателя, имя
             ,
             b.c#bic_num "C#BR_BIC_NUM" --банк получателя, бик
             ,
             b.c#ca_num "C#BR_CA_NUM" --банк получателя, корсчёт
             ,
             'г. ' || b.c#town_name "C#BR_TOWN_NAME" --банк получателя, город
             ,
             CASE WHEN V.ACC_TYPE = 1 THEN 'K' ELSE 'S' END AS flg,
             CASE WHEN V.ACC_TYPE = 1 THEN 'Все дома в котле' ELSE TO_CHAR(V.house_id) END AS c#house_id,
             V.PAY_SUM_TOTAL-V.KOTEL_TRANSFER-V.SPEC_TRANSFER-V.BARTER_SUM_TOTAL "C#SUM",
             CASE WHEN V.ACC_TYPE = 1 THEN 'Перевод взносов на капитальный ремонт на счет регионального оператора за ' ||
                   TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
                   TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' ELSE 'Перевод взносов на СС МКД(' || TO_CHAR(V.house_id) ||
                 '), адрес: ' || p#utils.get#house_addr(V.house_id, 1) ||
                 ' за ' || TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
                 TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' END AS target_pay,
             CASE WHEN V.ACC_TYPE = 1 THEN 'Перевод взносов на капитальный ремонт на счет регионального оператора за ' ||
                   TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
                   TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' ELSE 'Перевод взносов на СС МКД(' || TO_CHAR(V.house_id) ||
                 '), адрес: ' || p#utils.get#house_addr(V.house_id, 1) ||
                 ' за ' || TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
                 TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' END AS target_pay1
        FROM
             t#b_account ba
             join t#bank b on (ba.C#BANK_ID = b.C#ID)
            join V_BANK_EXP V on (ba.C#ID = v.B_ACCOUNT_ID)
        WHERE 1 = 1
          AND ba.c#acc_type IN (1, 2)
          AND V.MN = vdate
          and V.PAY_SUM_TOTAL-V.KOTEL_TRANSFER-V.SPEC_TRANSFER-V.BARTER_SUM_TOTAL > 0
        ORDER BY 1,
                 flg;

--
--      SELECT ba.c#id,
--             b.c#id bank_id,
--             ba.c#num "C#R_NUM" --получатель, счёт
--             ,
--             ba.c#name "C#R_NAME" --получатель, имя
--             ,
--             ba.c#inn_num "C#R_INN_NUM" --получатель, инн
--             ,
--             ba.c#kpp_num "C#R_KPP_NUM" --получатель, кпп
--             ,
--             b.c#name "C#BR_NAME" --банк получателя, имя
--             ,
--             b.c#bic_num "C#BR_BIC_NUM" --банк получателя, бик
--             ,
--             b.c#ca_num "C#BR_CA_NUM" --банк получателя, корсчёт
--             ,
--             'г. ' || b.c#town_name "C#BR_TOWN_NAME" --банк получателя, город
--             ,
--             CASE WHEN COUNT(s.c#house_id) > 1 THEN 'K' ELSE 'S' END AS flg,
--             CASE WHEN COUNT(s.c#house_id) > 1 THEN 'Все дома в котле' ELSE TO_CHAR(MAX(s.c#house_id)) END AS c#house_id,
--             SUM(sg.c#c_sum + sg.c#m_sum - sg.c#p_sum) "C#SUM",
--             CASE WHEN COUNT(s.c#house_id) > 1 THEN 'Все дома в котле' ELSE TO_CHAR(MAX(s.c#house_id)) END AS c#house_id,
--             CASE WHEN COUNT(s.c#house_id) > 1 THEN 'Перевод взносов на капитальный ремонт на счет регионального оператора за ' ||
--                   TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
--                   TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' ELSE 'Перевод взносов на СС МКД(' || TO_CHAR(MAX(s.c#house_id)) ||
--                 '), адрес: ' || p#utils.get#house_addr(MAX(s.c#house_id), 1) ||
--                 ' за ' || TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
--                 TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' END AS target_pay,
--             CASE WHEN COUNT(s.c#house_id) > 1 THEN 'Перевод взносов на капитальный ремонт на счет регионального оператора за ' ||
--                   TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
--                   TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' ELSE 'Перевод взносов на СС МКД(' || TO_CHAR(MAX(s.c#house_id)) ||
--                 '), адрес: ' || p#utils.get#house_addr(MAX(s.c#house_id), 1) ||
--                 ' за ' || TRIM(TO_CHAR(ADD_MONTHS(a#date, -1), 'month')) || ' ' ||
--                 TO_CHAR(ADD_MONTHS(a#date, -1), 'yyyy') || '.' END AS target_pay1
--        FROM t#b_store s,
--             t#b_storage sg,
--             t#b_account ba,
--             t#bank b
--        WHERE 1 = 1
--          AND ba.c#acc_type IN (1, 2)
--          AND s.c#mn = vdate
--          AND sg.c#house_id = s.c#house_id
--          AND sg.c#service_id = s.c#service_id
--          AND sg.c#b_account_id = s.c#b_account_id
--          AND sg.c#mn = (SELECT MAX(c#mn)
--              FROM t#b_storage
--              WHERE c#house_id = sg.c#house_id
--                AND c#service_id = sg.c#service_id
--                AND c#b_account_id = sg.c#b_account_id
--                AND c#mn <= vdate)
--          AND ba.c#id = s.c#b_account_id
--          AND b.c#id = ba.c#bank_id
--        GROUP BY ba.c#id,
--                 b.c#id,
--                 ba.c#num,
--                 ba.c#name,
--                 ba.c#inn_num,
--                 ba.c#kpp_num,
--                 b.c#name,
--                 b.c#bic_num,
--                 b.c#ca_num,
--                 b.c#town_name
--        HAVING SUM(sg.c#c_sum + sg.c#m_sum - sg.c#p_sum) > 0 -- добавлено для исключения отрицательных сумм к перечислению
--        ORDER BY 1,
--                 flg;
--                 
      RETURN res;
    END;

  FUNCTION lst#account_debt(a#num_id     NUMBER,
                            a#date_begin DATE,
                            a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res     sys_refcursor;
      a#lo_mn NUMBER;
      a#hi_mn NUMBER;
    BEGIN
      a#lo_mn := p#mn_utils.get#mn(a#date_begin);
      a#hi_mn := p#mn_utils.get#mn(a#date_end);
      OPEN res FOR
      SELECT r.c#flat_num,
             a.c#rooms_id,
             a.c#rooms_pn,
             a.c#date,
             a.c#end_date,
             a.c#num,
             a.c#sn,
             aop.c#out_num,
             t.c#account_id,
             p#mn_utils.get#date(tt.c#mn) mn,
             NULL c#0_c_vol --накопл. вх. объем
             ,
             NULL c#0_c_sum --накопл. вх. сальдо
             ,
             NULL c#0_mc_sum,
             NULL c#0_m_sum,
             NULL c#0_mp_sum,
             NULL c#0_p_sum,
             ch.c#1_c_vol --объем
             ,
             ch.c#1_c_sum --начислено
             ,
             op.c#1_mc_sum --изм. начисления
             ,
             op.c#1_m_sum --изменения
             ,
             op.c#1_mp_sum --изм. оплаты
             ,
             op.c#1_p_sum --оплачено
             ,
             NULL debt,
             NVL(c#1_c_sum, 0) + NVL(c#1_mc_sum, 0) + NVL(c#1_m_sum, 0) - NVL(c#1_mp_sum, 0) -
             NVL(c#1_p_sum, 0) debt1,
            P#UTILS.GET#TARIF(a.C#ID,p#mn_utils.get#date(tt.c#mn)) C#TAR_VAL
        FROM (SELECT DISTINCT c#account_id
                 FROM t#obj) t,
             (SELECT a#lo_mn + LEVEL - 1 "C#MN"
                 FROM TABLE (ttab#number(0))
                 WHERE a#lo_mn <= a#hi_mn
               CONNECT BY LEVEL <= a#hi_mn - a#lo_mn + 1) tt,
             (SELECT t.c#account_id,
                     t.c#a_mn "C#MN",
                     SUM(t.c#vol) "C#1_C_VOL",
                     SUM(t.c#sum) "C#1_C_SUM"
                 FROM t#charge t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#a_mn >= a#lo_mn
                   AND t.c#a_mn < a#hi_mn
                   AND a.c#id = a#num_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#a_mn) ch -- начисления
             ,
             (SELECT t.c#account_id,
                     t.c#a_mn "C#MN",
                     SUM(CASE WHEN t.c#type_tag = 'MC' THEN t.c#sum END) "C#1_MC_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'M' THEN t.c#sum END) "C#1_M_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'MP' THEN t.c#sum END) "C#1_MP_SUM",
                     SUM(CASE WHEN t.c#type_tag = 'P' THEN t.c#sum END) "C#1_P_SUM"
                 FROM v#op t,
                      t#account a,
                      t#rooms r
                 WHERE 1 = 1
                   AND t.c#a_mn >= a#lo_mn
                   AND t.c#a_mn < a#hi_mn
                   AND t.c#valid_tag = 'Y'
                   AND a.c#id = a#num_id
                   AND a.c#id = t.c#account_id
                   AND r.c#id = a.c#rooms_id
                 GROUP BY t.c#account_id,
                          t.c#a_mn) op -- изменения и оплата
             ,
             v#account a,
             t#rooms r,
             t#account_op aop
        WHERE 1 = 1
          AND (ch.c#account_id IS NOT NULL
          OR op.c#account_id IS NOT NULL)
          AND a.c#id = a#num_id
          AND t.c#account_id = ch.c#account_id (+)
          AND tt.c#mn = ch.c#mn (+)
          AND t.c#account_id = op.c#account_id (+)
          AND tt.c#mn = op.c#mn (+)
          AND a.c#id = t.c#account_id
          AND r.c#id = a.c#rooms_id
          AND a.c#id = aop.c#account_id (+)
          AND a.c#date = aop.c#date (+)
        ORDER BY t.c#account_id,
                 tt.c#mn;

      RETURN res;
    END;

  PROCEDURE del#room(a#room_id NUMBER)
    IS
    BEGIN
      COMMIT;
      INSERT INTO tt#tr_flag (
        c#val
      )
      VALUES ('ROOMS_SPEC_VD#PASS_MOD');
      DELETE FROM t#rooms_spec_vd r
        WHERE r.c#id IN (SELECT s.c#id
              FROM t#rooms_spec s
              WHERE s.c#rooms_id = a#room_id);
      INSERT INTO tt#tr_flag (
        c#val
      )
      VALUES ('ROOMS_SPEC#PASS_MOD');
      DELETE FROM t#rooms_spec s
        WHERE s.c#rooms_id = a#room_id;
      DELETE FROM t#rooms_part r
        WHERE r.c#rooms_id = a#room_id;
      DELETE FROM t#rooms r
        WHERE r.c#id = a#room_id;
      COMMIT;
    END;

  FUNCTION get#postamt_code(a#post_code VARCHAR2,
                            a#type_tag  NUMBER)
    RETURN VARCHAR2
    IS
      res VARCHAR2(200);
    BEGIN
      SELECT CASE WHEN a#type_tag = 0 THEN MAX(pp.c#parent_code) WHEN a#type_tag = 1 THEN MAX(pp.c#name) WHEN a#type_tag = 2 THEN MAX(p.c#name) END
        INTO res
        FROM t#postamt p,
             t#postamt pp
        WHERE 1 = 1
          AND p.c#code = a#post_code
          AND pp.c#code (+) = p.c#parent_code;
      RETURN res;
    END;

  PROCEDURE do#post_data(a#date DATE)
    IS
    BEGIN
      COMMIT;
      INSERT INTO tt#pb_account (
        c#id, c#num, c#sn, c#addr_text, c#top_addr_text, c#post_code, c#top_post_code, c#top_post_name
      )
        SELECT t.c#id,
               t.c#num,
               t.c#sn,
               ' ' "c#addr_text",
               NVL(t.cobj#p.f#area_name, ' ') "c#top_addr_text",
               NVL(c#alt_post_code, c#post_code) "c#post_code",
               t.cobj#p.f#p_code "c#top_post_code",
               t.cobj#p.f#p_name "c#top_post_name"
          FROM 
            (SELECT a.c#id,
                       a.c#num,
                       a.c#sn,
                       c#alt_post_code,
                       c#post_code,
                       p#utils.get_obj#postamt(NVL(c#alt_post_code, c#post_code)) cobj#p
              FROM (SELECT a.c#id,
                           a.c#num,
                           a.c#sn,
                           (SELECT MAX(NVL(h.c#post_code, '-'))
                               FROM t#house h
                               WHERE c#id = a.c#house_id) c#post_code,
                           (SELECT MAX(NVL(pa.c#post_code, '-'))
                               FROM t#person_addr pa
                               WHERE c#person_id = p#utils.get_obj#account(a.c#id, p#mn_utils.get#mn(a#date))
                                 .f#person_id) c#alt_post_code
                  FROM (SELECT a.c#id,
                               a.c#num,
                               a.c#sn,
                               a.c#rooms_id,
                               r.c#house_id
                      FROM t#account_op aop,
                           t#account a,
                           t#rooms r
                      WHERE aop.c#out_proc_id = 13
                        AND aop.c#date = (SELECT MAX(c#date)
                            FROM t#account_op
                            WHERE c#account_id = aop.c#account_id
                              AND c#date < ADD_MONTHS(a#date, 1))
                        AND EXISTS (SELECT 1
                            FROM v#chop
                            WHERE c#account_id = aop.c#account_id
                              AND c#b_mn < p#mn_utils.get#mn(a#date) + 1
                            HAVING SUM(NVL(c#c_sum, 0) + NVL(c#mc_sum, 0) + NVL(c#m_sum, 0) -
                              NVL(c#mp_sum, 0) - NVL(c#p_sum, 0) + NVL(c#fc_sum, 0) -
                              NVL(c#fp_sum, 0)) > 0)
                        AND a.c#id = aop.c#account_id
                        AND r.c#id = a.c#rooms_id) a) a) t
                        join V#ACC_LAST L on (t.C#ID = L.C#ACCOUNT_ID); -- 19.11.2018 чтоб не печатались квитанции по закрытым счетам
    END;

  FUNCTION lst#postamt
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT /*+ CARDINALITY(b 10000) */
      DISTINCT b.c#top_post_name "c#postamt_name",
               COUNT(b.c#id) acc_cnt
        FROM tt#pb_account b
        WHERE b.c#top_post_name IS NOT NULL
        GROUP BY b.c#top_post_name
        ORDER BY b.c#top_post_name;
      RETURN res;
    END;

  FUNCTION lst#post_codes(a#name VARCHAR2,
                          a#area VARCHAR2)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT /*+ CARDINALITY(b 10000) */
      COUNT(b.c#post_code) billcount,
      b.c#post_code postcode,
      b.c#top_addr_text post_name,
      b.c#top_post_code "c#postamt_code",
      b.c#top_post_name
        FROM tt#pb_account b
        WHERE 1 = 1
          AND UPPER(b.c#top_post_name) = UPPER(a#name)
          AND (a#area IS NULL
          OR UPPER(b.c#top_addr_text) = UPPER(a#area))
          AND b.c#top_post_code IS NOT NULL
        GROUP BY b.c#post_code,
                 b.c#top_addr_text,
                 b.c#top_post_code,
                 b.c#top_post_name
        ORDER BY b.c#post_code;
      RETURN res;
    END;

  FUNCTION lst#post_account(a#p_code NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT /*+ CARDINALITY(b 10000) */
      b.c#num,
      b.c#id
        FROM tt#pb_account b
        WHERE b.c#post_code = a#p_code
          AND b.c#top_post_code IS NOT NULL
        ORDER BY b.c#num;
      RETURN res;
    END;

  FUNCTION lst#post_account_other
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT /*+ CARDINALITY(b 10000) */
      t.*
        FROM tt#pb_account t
        WHERE t.c#top_post_code IS NULL
        ORDER BY t.c#post_code,
                 t.c#addr_text;
      RETURN res;
    END;

  FUNCTION lst#addr_obj_level0
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT ao.c#id,
             ao.c#name || ' ' || aot.c#abbr_name c#name
        FROM t#addr_obj ao,
             t#addr_obj_type aot
        WHERE ao.c#parent_id IS NULL
          AND ao.c#type_id = aot.c#id
        ORDER BY 2;
      RETURN res;
    END;

  FUNCTION lst#addr_obj_level1(a#id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT *
        FROM (SELECT ao.c#id,
                     LTRIM(SYS_CONNECT_BY_PATH(ao.c#name || ' ' || aot.c#abbr_name, ', '), ', ') c#name
            FROM t#addr_obj ao,
                 t#addr_obj_type aot
            WHERE aot.c#id = ao.c#type_id
          CONNECT BY PRIOR ao.c#id = ao.c#parent_id
          START WITH ((a#id IS NULL AND ao.c#parent_id IS NULL) OR ao.c#parent_id = a#id)) t
        WHERE t.c#id IN (SELECT h.c#addr_obj_id
              FROM t#house h)
        ORDER BY 2;
      RETURN res;
    END;

  FUNCTION lst#addr_obj_level2(a#addr_obj_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT h.c#id,
             h.c#num || RTRIM('-' || h.c#b_num || '-' || h.c#s_num, '-') c#num
        FROM t#house h
        WHERE h.c#addr_obj_id = a#addr_obj_id
        ORDER BY p#utils.get#addr_num(h.c#num),
                 p#utils.get#addr_num(h.c#b_num);
      RETURN res;
    END;

  FUNCTION lst#search_by_address(a#addr_obj_id NUMBER,
                                 a#house_id    NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#addr_obj_id,
             t.c#id account_id,
             t.oa.f#house_id house_id,
             t.oa.f#person_id person_id,
             t.c#room_id room_id,
             aop.c#out_num out_account_num,
             t.oa.f#num account_num,
             p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path -- rooms_addr(t.oa.f#rooms_id) address
             ,
             t.c#house_num,
             t.c#flat_num,
             t.c#AREA_VAL,
             p#utils.get#person_name(t.oa.f#person_id) person
        FROM (SELECT a.c#id,
                     p#utils.get_obj#account(a.c#id, sysdate) oa,
                     h.c#addr_obj_id,
                     h.c#num || RTRIM('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num,
                     r.c#flat_num,
                     rs.C#AREA_VAL,
                     r.c#id c#room_id
                 FROM t#account a,
                      t#rooms r,
                      v#rooms_spec rs,
                      t#house h
                 WHERE 1 = 1
                   AND (a#house_id IS NULL
                   OR h.c#id = a#house_id)
                   AND (a#addr_obj_id IS NULL
                   OR h.c#addr_obj_id = a#addr_obj_id)
                   AND r.c#house_id = h.c#id
                   AND r.c#id (+) = rs.c#ROOMS_ID
                   AND a.c#rooms_id = r.c#id) t,
             t#account_op aop
        WHERE t.c#id = aop.c#account_id (+)
        ORDER BY p#utils.get#addr_num(t.c#house_num),
                 p#utils.get#addr_num(c#flat_num);
      RETURN res;
    END;

  FUNCTION lst#search_by_account(a#num      string,
                                 a#flg_type NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#addr_obj_id,
             t.c#id account_id,
             t.oa.f#house_id house_id,
             t.oa.f#person_id person_id,
             t.c#room_id room_id,
             t.c#out_num out_account_num,
             t.oa.f#num account_num,
             p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path -- rooms_addr(t.oa.f#rooms_id) address
             ,
             t.c#house_num,
             t.c#flat_num,
             t.C#AREA_VAL,
             t.C#END_DATE,
             p#utils.get#person_name(t.oa.f#person_id) person
        FROM (SELECT a.c#id,
                     a.C#END_DATE,
                     p#utils.get_obj#account(a.c#id, sysdate) oa,
                     h.c#addr_obj_id,
                     h.c#num || RTRIM('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num,
                     r.c#flat_num,
                     aop.c#out_num,
                     r.c#id c#room_id,
                     rs.C#AREA_VAL
            FROM v#account a,
                 t#rooms r,
                 v#rooms_spec rs,
                 t#house h,
                 t#account_op aop
            WHERE 1 = 1
              AND a.c#id = aop.c#account_id (+)
--              AND aop.c#date = (SELECT MAX(p.c#date)
--                  FROM t#account_op p
--                  WHERE p.c#account_id = a.c#id)
              AND (a#flg_type = 0
              AND (a.c#num LIKE a#num || '%'
              OR aop.c#out_num LIKE a#num || '%')
              OR a#flg_type = 1
              AND (a.c#num LIKE '%' || a#num || '%'
              OR aop.c#out_num LIKE '%' || a#num || '%')
              OR a#flg_type = 2
              AND (a.c#num LIKE '%' || a#num
              OR aop.c#out_num LIKE '%' || a#num))
              AND r.c#house_id = h.c#id
              AND r.c#id (+) = rs.c#ROOMS_ID
              AND a.c#rooms_id = r.c#id) t
        ORDER BY p#utils.get#addr_num(t.c#house_num),
                 p#utils.get#addr_num(c#flat_num);
      RETURN res;
    END;

  FUNCTION lst#search_by_person_j(a#person string,
                                  a#inn    string)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#addr_obj_id,
             t.account_id,
             t.house_id,
             t.person_id,
             t.c#room_id room_id,
             t.out_account_num,
             t.account_num,
             t.address addr_path,
             t.c#house_num,
             t.c#flat_num,
             t.C#AREA_VAL,
             t.C#END_DATE,
             t.person
        FROM (SELECT a.c#id account_id,
                     a.C#END_DATE,
                     h.c#addr_obj_id,
                     r.c#house_id house_id,
                     aop.c#out_num out_account_num,
                     a.c#num account_num,
                     p#utils.get#addr_obj_path(h.c#addr_obj_id) address,
                     h.c#num || RTRIM('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num,
                     r.c#flat_num,
                     rs.C#AREA_VAL,
                     pj.c#person_id person_id,
                     pj.c#name || ' ИНН: ' || pj.c#inn_num person,
                     r.c#id c#room_id
            FROM t#person_j pj,
                 v#account_spec asp,
                 v#account a,
                 t#rooms r,
                 v#rooms_spec rs,
                 t#account_op aop,
                 t#house h
            WHERE 1 = 1
              AND (a#inn IS NULL
              OR pj.c#inn_num = a#inn
              OR pj.c#inn_num LIKE '%' || a#inn || '%')
              AND (a#person IS NULL
              OR UPPER(pj.c#name) LIKE '%' || UPPER(a#person) || '%')
              AND a.c#id = aop.c#account_id (+)
              AND pj.c#person_id = asp.c#person_id (+)
              AND asp.c#valid_tag (+) = 'Y'
              AND a.c#id (+) = asp.c#account_id
              AND r.c#id (+) = a.c#rooms_id
              AND r.c#id (+) = rs.c#ROOMS_ID
              AND h.c#id = r.c#house_id) t;
      RETURN res;
    END;

  FUNCTION lst#search_by_person_p(a#f_name string,
                                  a#i_name string,
                                  a#o_name string)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#addr_obj_id,
             t.account_id,
             t.house_id,
             t.person_id,
             t.c#room_id room_id,
             t.out_account_num,
             t.account_num,
             t.address addr_path,
             t.c#house_num,
             t.c#flat_num,
             t.C#AREA_VAL,
             t.C#END_DATE,
             t.person
        FROM (SELECT a.c#id account_id,
                     a.C#END_DATE,
                     h.c#addr_obj_id,
                     r.c#house_id house_id,
                     aop.c#out_num out_account_num,
                     a.c#num account_num,
                     p#utils.get#addr_obj_path(h.c#addr_obj_id) address,
                     h.c#num || RTRIM('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num,
                     r.c#flat_num,
                     pp.c#person_id person_id,
                     pp.c#f_name || RTRIM(' ' || pp.c#i_name || ' ' || pp.c#o_name) person,
                     r.c#id c#room_id,
                     rs.C#AREA_VAL
            FROM t#person_p pp,
                 v#account_spec asp,
                 v#account a,
                 t#rooms r,
                 v#rooms_spec rs,
                 t#account_op aop,
                 t#house h
            WHERE 1 = 1
              AND (a#f_name IS NULL
              OR UPPER(pp.c#f_name) LIKE '%' || UPPER(a#f_name) || '%')
              AND (a#i_name IS NULL
              OR UPPER(pp.c#i_name) LIKE '%' || UPPER(a#i_name) || '%')
              AND (a#o_name IS NULL
              OR UPPER(pp.c#o_name) LIKE '%' || UPPER(a#o_name) || '%')
              AND a.c#id = aop.c#account_id (+)
              AND pp.c#person_id = asp.c#person_id (+)
              AND asp.c#valid_tag (+) = 'Y'
              AND a.c#id (+) = asp.c#account_id
              AND r.c#id (+) = a.c#rooms_id
              AND r.c#id (+) = rs.c#ROOMS_ID
              AND h.c#id = r.c#house_id) t;
      RETURN res;
    END;

  FUNCTION lst#account_info(a#account_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.as_date,
             t.as_part_coef,
             t.e.f#area_val,
             t.e.f#living_tag,
             t.e.f#own_type_tag,
             t.e.f#person_id,
             t.e.f#num,
             pp.c#f_name,
             pp.c#i_name,
             pp.c#o_name,
             pj.c#name,
             pj.c#inn_num,
             pj.c#kpp_num,
             CASE WHEN pj.c#person_id IS NOT NULL THEN 'J' ELSE 'P' END person_tag
        FROM (SELECT va.c#date as_date,
                     va.c#part_coef as_part_coef,
                     p#utils.get_obj#account(a#account_id, sysdate) e
                 FROM v#account_spec va
                 WHERE va.c#account_id = a#account_id) t,
             t#person p,
             t#person_j pj,
             t#person_p pp
        WHERE 1 = 1
          AND p.c#id = t.e.f#person_id
          AND pj.c#person_id (+) = p.c#id
          AND pp.c#person_id (+) = p.c#id;
      RETURN res;
    END;

  FUNCTION lst#rooms(a#house_id NUMBER,
                     a#date     DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT r.c#id,
             r.c#house_id,
             r.c#flat_num,
             rs.c#date,
             rs.c#vn,
             rs.c#living_tag,
             rs.c#own_type_tag,
             rs.c#area_val,
             rs.c#id room_spec_id
        FROM v#rooms_spec rs,
             t#rooms r
        WHERE 1 = 1
          AND r.c#house_id = a#house_id
          AND rs.c#rooms_id = r.c#id
          AND rs.c#valid_tag = 'Y'
          AND rs.c#date <= a#date
        ORDER BY p#utils.get#addr_num(r.c#flat_num),
                 r.c#id;
      RETURN res;
    END;

  FUNCTION lst#pay_info(a#account_id  NUMBER,
                        a#account_num VARCHAR2)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT f.c#real_date,
             f.c#summa,
             f.c#fine,
             f.c#account
             --,to_date(to_char(to_date(f.period, 'mmyy'), 'dd.mm.yyyy'), 'dd.mm.yyyy') period
             ,
             f.c#period,
             f.c#cod_rkc,
             o.c#name
             --,f.c#file_id
             ,
             CASE WHEN fp.c#id = 1 THEN 'ПЕРЕН.ОПЛ.' ELSE CASE WHEN fp.c#id = 2 THEN 'СНЯТ.ОПЛАТЫ' ELSE fp.c#f_num END END AS c#file_id,
             f.c#id,
             f.c#comment,
             f.C#ID PS_ID,
             TO_CHAR(f.c#row_time,'dd.mm.yyyy hh:mm') ROW_TIME,
             f.c#plat,
             f.C#PAY_NUM
        FROM fcr.t#pay_source f,
             fcr.t#file_pay fp,
             fcr.t#ops_kind o
        WHERE 1 = 1
          AND (a#account_id IS NULL
          OR NVL(f.c#acc_id, f.c#acc_id_close) = a#account_id)
          AND (a#account_num IS NULL
          OR f.c#account LIKE '%' || a#account_num || '%')
          -- and f.c#ops_id = o.c#id(+) --закомментарил
          AND f.c#kind_id = o.c#id (+)
          AND f.c#file_id = fp.c#id (+)
        ORDER BY f.c#real_date,
                 f.c#period,
                 f.c#cod_rkc,
                 f.c#summa;
      RETURN res;
    END;

  FUNCTION lst#pay_info_other(a#account_id  NUMBER,
                              a#account_num VARCHAR2)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT o.C#ID, --ID платежа за определенный период
             o.C#REAL_DATE, --Фактическая дата платежа
             o.C#DATE, --Дата проведения платежа в базе
             o.C#SUM AS c#summa, --Сумма
             DECODE(o.C#TYPE_TAG, 'P', 'платеж', 'FC', 'нач.пени', 'FP', 'плат.пени') AS TYPE_PL, --Тип платежа
             a.c#num AS c#account, --Номер ЛС внутренний
             TO_CHAR(fcr.p#mn_utils.GET#DATE(o.C#A_MN), 'mm.yyyy') AS c#period, --За период
             TO_CHAR(fcr.p#mn_utils.GET#DATE(o.C#B_MN), 'mm.yyyy') IN_KVIT, --В квитанию какого месяца
             ok.c#cod AS c#cod_rkc, --Код РКЦ
             ok.c#name, --Название РКЦ
             0 AS "c#fine",
             0 AS "c#file_id",
             '' AS c#comment,
             0 AS PS_ID,
             null ROW_TIME,
             null c#plat,
             null C#PAY_NUM

        --     select o.C#ID, --ID платежа за определенный период
        --            o.C#REAL_DATE, --Фактическая дата платежа
        --            o.C#DATE, --Дата проведения платежа в базе
        --            o.C#SUM, --Сумма
        --            decode(o.C#TYPE_TAG, 'P', 'платеж', 'FC', 'нач.пени', 'FP', 'плат.пени') as TYPE_PL, --Тип платежа
        --            a.c#num, --Номер ЛС внутренний
        --            to_char(fcr.p#mn_utils.GET#DATE(o.C#A_MN),'mm.yyyy') IN_PERIOD, --За период
        --            to_char(fcr.p#mn_utils.GET#DATE(o.C#B_MN),'mm.yyyy') IN_KVIT, --В квитанию какого месяца
        --            ok.c#cod, --Код РКЦ
        --            ok.c#name --Название РКЦ
        FROM fcr.v#ops op,
             fcr.v#op o,
             fcr.t#ops_kind ok,
             fcr.t#account a
        WHERE 1 = 1
          AND (a#account_id IS NULL
          OR a.c#id = a#account_id)
          AND (a#account_num IS NULL
          OR a.c#num LIKE '%' || a#account_num || '%')
          AND op.C#KIND_ID = ok.c#id
          AND o.C#OPS_ID = op.C#ID
          AND a.c#id = o.C#ACCOUNT_ID
        ORDER BY o.C#REAL_DATE,
                 o.C#DATE,
                 o.C#A_MN,
                 o.C#B_MN,
                 o.c#id;
      RETURN res;
    END;

  FUNCTION lst#pay_info_without_transfer(a#account_id  NUMBER,
                                         a#account_num VARCHAR2,
                                         a#flag        BOOLEAN)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN

      IF a#flag
      THEN
        OPEN res FOR
        SELECT f.c#real_date,
               f.c#summa,
               f.c#fine,
               f.c#account
               --,to_date(to_char(to_date(f.period, 'mmyy'), 'dd.mm.yyyy'), 'dd.mm.yyyy') period
               ,
               f.c#period,
               f.c#cod_rkc,
               o.c#name,
               f.c#file_id,
               f.c#id,
               f.c#inn,
               f.c#kpp,
               f.c#comment,
               f.c#plat
          FROM fcr.t#pay_source f,
               fcr.t#ops_kind o
          WHERE 1 = 1
            AND f.c#storno_id IS NULL
            AND f.c#id NOT IN (SELECT c#storno_id
                FROM fcr.t#pay_source
                WHERE c#storno_id IS NOT NULL)
            AND (a#account_id IS NULL
            OR NVL(f.c#acc_id, f.c#acc_id_close) = a#account_id)
            AND (a#account_num IS NULL
            OR f.c#account LIKE '%' || a#account_num || '%')
            AND f.c#ops_id = o.c#id (+)
          ORDER BY f.c#real_date,
                   f.c#period,
                   f.c#cod_rkc,
                   f.c#summa;
      ELSE
        OPEN res FOR
        SELECT f.c#real_date,
               f.c#summa,
               f.c#fine,
               f.c#account
               --,to_date(to_char(to_date(f.period, 'mmyy'), 'dd.mm.yyyy'), 'dd.mm.yyyy') period
               ,
               f.c#period,
               f.c#cod_rkc,
               o.c#name,
               f.c#file_id,
               f.c#id,
               f.c#inn,
               f.c#kpp,
               f.c#comment,
               f.c#plat
          FROM fcr.t#pay_source f,
               fcr.t#ops_kind o
          WHERE 1 = 1
            AND f.c#storno_id IS NULL
            AND f.c#id NOT IN (SELECT c#storno_id
                FROM fcr.t#pay_source
                WHERE c#storno_id IS NOT NULL)
            AND (a#account_id IS NULL
            OR NVL(f.c#acc_id, f.c#acc_id_close) = a#account_id)
            AND (a#account_num IS NULL
            OR f.c#account = a#account_num)
            AND f.c#ops_id = o.c#id (+)
          ORDER BY f.c#real_date,
                   f.c#period,
                   f.c#cod_rkc,
                   f.c#summa;
      END IF;
      RETURN res;
    END;

  FUNCTION get#account_data(a#account_id NUMBER,
                            a#date       DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT p#utils.get#person_name(t.a.f#person_id) person,
             CASE WHEN t.a.f#living_tag = 'Y' THEN p#utils.get#rooms_addr(t.a.f#rooms_id, 1) ELSE REPLACE(p#utils.get#rooms_addr(t.a.f#rooms_id, 1), ', кв ', ', пом ') ||
                 ' (нежилое помещение)' END address,
             p#utils.get_obj#house_postamt(t.a.f#house_id).f#code p_code
        FROM (SELECT p#utils.get_obj#account(a#account_id, p#mn_utils.get#mn(a#date)) a
            FROM dual) t;
      RETURN res;
    END;

  FUNCTION lst#person_j
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT pj.*,
             pa.c#post_code,
             pa.c#1_text,
             pa.c#2_text
        FROM t#person_j pj,
             t#person_addr pa
        WHERE pa.c#person_id (+) = pj.c#person_id
        ORDER BY pj.c#name;
      RETURN res;
    END;

  PROCEDURE ins#person_j(a#name      VARCHAR2,
                         a#inn_num   VARCHAR2,
                         a#kpp_num   VARCHAR2,
                         a#post_code VARCHAR2,
                         a#text_1    VARCHAR2,
                         a#text_2    VARCHAR2)
    IS
      v#person_id NUMBER;
    BEGIN
      INSERT INTO t#person
      VALUES (DEFAULT) RETURNING c#id INTO v#person_id;

      INSERT INTO t#person_j (
        c#person_id, c#name, c#inn_num, c#kpp_num
      )
      VALUES (v#person_id, a#name, a#inn_num, a#kpp_num);
      INSERT INTO t#person_addr (
        c#person_id, c#post_code, c#1_text, c#2_text
      )
      VALUES (v#person_id, a#post_code, a#text_1, a#text_2);
      COMMIT;
    END;

  PROCEDURE upd#person_j(a#person_id NUMBER,
                         a#name      VARCHAR2,
                         a#inn_num   VARCHAR2,
                         a#kpp_num   VARCHAR2,
                         a#post_code VARCHAR2,
                         a#text_1    VARCHAR2,
                         a#text_2    VARCHAR2)
    IS
    BEGIN
      UPDATE t#person_j
        SET c#name = a#name, c#inn_num = a#inn_num, c#kpp_num = a#kpp_num
        WHERE c#person_id = a#person_id;

      UPDATE t#person_addr
        SET c#post_code = a#post_code, c#1_text = a#text_1, c#2_text = a#text_2
        WHERE c#person_id = a#person_id;
      COMMIT;
    END;

  PROCEDURE del#person_j(a#person_id NUMBER)
    IS
    BEGIN
      DELETE FROM t#person_j
        WHERE c#person_id = a#person_id;
      DELETE FROM t#person_addr
        WHERE c#person_id = a#person_id;
      DELETE FROM t#person
        WHERE c#id = a#person_id;
      COMMIT;
    END;

  FUNCTION lst#account_op(a#account_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
        SELECT
          ao.*,
          op.c#code,
          op.c#name || CASE WHEN uk.UK_NAME is null THEN '' ELSE ' ('||uk.UK_NAME||')'END c#name
        FROM
          t#account_op ao
          left join t#out_proc op on (ao.c#out_proc_id = op.c#id)
          left join V#ERC_ACC_UK_NAMES uk on (ao.C#OUT_NUM = uk.ACCAUNT_NUM)
        WHERE
          1 = 1
          AND ao.c#account_id = a#account_id
        ORDER BY
          ao.c#account_id,
          ao.c#date;
--      SELECT ao.*,
--             op.c#code,
--             op.c#name
--        FROM t#account_op ao,
--             t#out_proc op
--        WHERE 1 = 1
--          AND ao.c#account_id = a#account_id
--          AND ao.c#out_proc_id = op.c#id (+)
--        ORDER BY ao.c#account_id,
--                 ao.c#date;
      RETURN res;
    END;


  PROCEDURE ins#account_op(a#account_id  NUMBER,
                           a#date        DATE,
                           a#out_proc_id NUMBER,
                           a#out_num     VARCHAR,
                           a#note VARCHAR default null)
    IS
    BEGIN
      INSERT INTO t#account_op (
        c#account_id, c#date, c#out_proc_id, c#out_num, c#note
      )
      VALUES (a#account_id, a#date, a#out_proc_id, a#out_num, a#note);
      COMMIT;
    END;

  PROCEDURE upd#account_op(a#id          NUMBER,
                           a#date        DATE,
                           a#out_proc_id NUMBER,
                           a#out_num     VARCHAR)
    IS
    BEGIN
      UPDATE t#account_op
        SET c#date = a#date, c#out_proc_id = a#out_proc_id, c#out_num = a#out_num
        WHERE c#id = a#id;
      COMMIT;
    END;

  PROCEDURE del#account_op(a#id NUMBER)
    IS
    BEGIN
      DELETE FROM t#account_op
        WHERE c#id = a#id;
      COMMIT;
    END;

  FUNCTION lst#house_info(a#house_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT hw.c#name,
             vo.c#name_mo,
             vo.c#region,
             h.*
        FROM t#house_info h,
             t#house_wall_type hw,
             v#omsu vo
        WHERE 1 = 1
          AND h.c#wall_type_id = hw.c#id
          AND h.c#house_id = a#house_id
          AND h.c#omsu_id = vo.c#id (+);
      RETURN res;
    END;

  PROCEDURE do#calc(a#date DATE)
    IS
      a#mn NUMBER := p#mn_utils.get#mn(a#date);
    BEGIN
      dbms_stats.gather_schema_stats(ownname => 'FCR', cascade => TRUE, options => 'GATHER AUTO');
      FOR cr#i IN (SELECT t.c#id
          FROM fcr.t#account t
          ORDER BY 1)
      LOOP
        do#calc_charge(cr#i.c#id, a#mn, a#mn, a#mn);
        do#calc_store(cr#i.c#id, a#mn + 1);
        COMMIT;
      END LOOP;
    END;

  PROCEDURE do#calc_account(a#date       DATE,
                            a#account_id NUMBER,
                            a#type       NUMBER)
    IS
      a#mn NUMBER := p#mn_utils.get#mn(a#date);
      a#op NUMBER := p#utils.GET#OPEN_MN;
      mn   NUMBER;
    BEGIN
      IF a#type = 0
      THEN
        do#calc_charge(a#account_id, a#mn, a#mn, a#mn);
        COMMIT;
        do#calc_store(a#account_id, a#mn + 1);
      END IF;
      IF a#type = 1
      THEN
        do#calc_charge(a#account_id, a#mn, a#mn, a#mn);
      END IF;
      IF a#type = 2
      THEN
        do#calc_store(a#account_id, a#mn + 1);
      END IF;
      IF a#type = 3
      THEN
        FOR A#MN IN 162 .. a#op
        LOOP
          IF NVL(GET_PAID_KVIT(a#account_id, A#MN, 1), 0) IN (0, 1, 2, 3, 4, 5, 6, 7)
          THEN
            MN := A#MN;
          ELSE
            MN := GET_FIRST_UNPAID_KVIT(a#account_id, A#MN, a#op);
          END IF;

          IF MN IS NULL
          THEN
            MN := A#MN;
          END IF;

          DO#CALC_CHARGE(a#account_id, A#MN, MN, a#op);
          COMMIT;
        END LOOP;
      END IF;
      COMMIT;
    END;

  FUNCTION lst#account_all
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT t.c#id,
             t.c#num
        FROM fcr.t#account t
        ORDER BY 1;
      RETURN res;
    END;

  FUNCTION lst#account_changed
    RETURN sys_refcursor
    IS
      res  sys_refcursor;
      a#op DATE := p#mn_utils.GET#DATE(p#utils.GET#OPEN_MN);
    BEGIN
      OPEN res FOR
      SELECT a.c#id,
             a.c#num
        FROM fcr.v#account a
        WHERE TRUNC(a.c#sign_date) >= a#op
        UNION
      SELECT a.c#id,
             a.c#num
        FROM v#rooms_spec r,
             t#account a
        WHERE TRUNC(r.c#sign_date) >= a#op
          AND r.c#rooms_id = a.c#rooms_id
        UNION
      SELECT v.c#account_id AS c#id,
             a.c#num
        FROM v#account_spec v,
             t#account a
        WHERE TRUNC(v.c#sign_date) >= a#op
          AND v.c#account_id = a.c#id;
      RETURN res;
    END;

  FUNCTION get#open_mn
    RETURN DATE
    IS
      res DATE;
    BEGIN
      res := p#mn_utils.get#date(p#utils.get#open_mn);
      RETURN res;
    END;

  FUNCTION get#acc_count
    RETURN NUMBER
    IS
      res NUMBER;
    BEGIN
      SELECT COUNT(t.c#id)
        INTO res
        FROM fcr.t#account t
        ORDER BY 1;
      RETURN res;
    END;

  FUNCTION lst#adr_obj_house(a#house_id NUMBER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT LEVEL,
             t.c#id
        FROM t#addr_obj t
        WHERE 1 = 1
      START WITH t.c#id = (SELECT MAX(t.c#addr_obj_id)
          FROM t#house t
          WHERE t.c#id = a#house_id) CONNECT BY NOCYCLE PRIOR t.c#parent_id = t.c#id
        UNION
      SELECT 0,
             a#house_id
        FROM dual
        ORDER BY 1 DESC;
      RETURN res;
    END;
    
    
   procedure ins#pay_source(
        a#account varchar2,
        a#real_date varchar2,
        a#summa number,
        a#fine number,
        a#period varchar2,
        a#cod_rkc varchar2,
        a#pay_num varchar2,
        a#comment varchar2,
        a#file_id varchar2
    )is
    begin    
        null;
        insert into t#pay_source (
            c#account,
            c#real_date,
            c#summa,
            c#fine,
            c#period,
            c#cod_rkc,
            c#pay_num,
            c#comment,
            c#file_id
        )
        values (
            a#account,
            to_date(a#real_date,'dd.mm.yyyy'),
            a#summa,
            a#fine,
            a#period,
            a#cod_rkc,
            a#pay_num,
            a#comment,
            a#file_id
        );
        commit;
    end;
    
    
END p#fcr;
/
