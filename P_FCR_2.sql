--------------------------------------------------------
--  DDL for Package P#FCR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FCR" 
  IS

  /**
  *  Âñå àäðåñà ñ ÔÈÀÑ
  */
  FUNCTION lst#addr_tree_FIAS(a#parent_id NUMBER)
    RETURN sys_refcursor;

  /**
  *  Âñå äîìà ñ ÔÈÀÑ
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
END p#fcr;

/
