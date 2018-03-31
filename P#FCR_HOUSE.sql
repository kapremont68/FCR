CREATE OR REPLACE PACKAGE P#FCR_HOUSE
  IS

  TYPE type_RecDoing IS RECORD (
      m#vn      NUMBER,
      m#doer_id NUMBER
    );
  a#err VARCHAR2(4000);
  /**
  * Оплаты по кодам операций
  */
  FUNCTION GET#PAYMENT_HOUSE(a#house_id NUMBER,
                             a#acc_type NUMBER)
    RETURN sys_refcursor;

  /**
  * Обновление  таблицы программы капремонта
  */
  PROCEDURE UPD#HOUSE_INFO(A#ROOF_L_YEAR   NUMBER,
                           A#ROOF_H_YEAR   NUMBER,
                           A#FACE_L_YEAR   NUMBER,
                           A#FACE_H_YEAR   NUMBER,
                           A#ISYS_L_YEAR   NUMBER,
                           A#ISYS_H_YEAR   NUMBER,
                           A#CMET_L_YEAR   NUMBER,
                           A#CMET_H_YEAR   NUMBER,
                           A#ELEV_L_YEAR   NUMBER,
                           A#ELEV_H_YEAR   NUMBER,
                           A#BASE_L_YEAR   NUMBER,
                           A#BASE_H_YEAR   NUMBER,
                           A#FUND_L_YEAR   NUMBER,
                           A#FUND_H_YEAR   NUMBER,
                           A#VOTE_DATE     DATE,
                           A#VOTE_TEXT     VARCHAR2,
                           A#ORG_NAME      VARCHAR2,
                           A#GOV_NAME      VARCHAR2,
                           A#OMSU_ID       VARCHAR2,
                           A#LIVE_AREA_VAL NUMBER,
                           A#FLORS         VARCHAR2,
                           A#ELEV_COL      NUMBER,
                           A#HOUSE_ID      NUMBER,
                           A#PROG_NUM      NUMBER,
                           A#GU_ID         NUMBER,
                           A#1ST_DATE      DATE,
                           A#2ND_DATE      DATE,
                           A#END_DATE      DATE,
                           A#AREA_VAL      NUMBER,
                           A#FLOOR_CNT     NUMBER,
                           A#ELEVATOR_TAG  VARCHAR2,
                           A#BASEMENT_TAG  VARCHAR2,
                           A#WALL_TYPE_ID  NUMBER,
                           A#CREATE_YEAR   NUMBER);
  /** 
	* Долг по помещениям дома
	* @param a#house_id идентификатор дома
	* @return курсор с информацией по долгу
	*/
  FUNCTION LST#DOLG(a#house_id INTEGER)
    RETURN sys_refcursor;

  /** 
	* Все тарифы дома
	* @param a#house_id идентификатор дома
	* @return курсор с информацией по всем тарифам применяемым к дому 
	*/
  FUNCTION LST#SHOW_TARIFF(a#house_id INTEGER)
    RETURN sys_refcursor;

  /** 
	* Предполагаемый сбор по дому
	* @param a#house_id идентификатор дома
	* @param a#date_month любая дата в месяце сбора
	* @return предполагаемая сумма сбора
	*/
  FUNCTION GET#HOUSE_MONTH_SUM(a#house_id   INTEGER,
                               a#date_month DATE)
    RETURN NUMBER;

  /** 
	* Суммарная площадь помещений в доме
	* @param a#house_id идентификатор дома
	* @return суммарная площадь помещений в доме
	*/
  FUNCTION GET#HOUSE_AREA(a#house_id INTEGER)
    RETURN NUMBER;

  /** 
	* Тариф применяемый к дому в указанном месяце
	* @param a#house_id идентификатор дома
	* @param a#date_month любая дата в месяце 
	* @return тариф применяемый к дому в указанном месяце
	*/
  FUNCTION GET#HOUSE_TAR(a#house_id   INTEGER,
                         a#date_month DATE)
    RETURN NUMBER;

  /** 
	* Добавление дома по указанному адресу
	* @param a#addrid идентификатор адреса
	* @param a#num номер дома
  * @param a#bnum корпус
  * @param a#snum дополнительный корпус
	* @param a#post почтовый индекс ( выбирается из справочника )
  * @param a#fias код фиас ( выбирается из справочника )
	*/
  PROCEDURE INS#HOUSE(a#addrid NUMBER,
                      a#num    VARCHAR2,
                      a#bnum   VARCHAR2,
                      a#snum   VARCHAR2,
                      a#post   VARCHAR2,
                      a#fias   VARCHAR2);

  /** 
  * Добавление дома по указанному адресу
  * @param a#houseguid GUID дома в справочнике ФИАС
  */
  PROCEDURE INS#HOUSE_FROM_FIAS(a#houseguid VARCHAR2);

  /** 
	* Удаление иформации о доме без помещений
	* @param a#house_id идентификатор дома
	*/
  PROCEDURE DEL#HOUSE(a#house_id NUMBER);

  /** 
	* Добавление нового тарифа для дома
	* @param a#house_id идентификатор дома
	* @param a#house_id идентификатор дома
  * @param a#date_begin дата начала действия тарифа
  * @param a#date_end   дата окончания действия тарифа
  * @param a#new_tarif  тариф
  * @param a#doer_id    РКЦ
	*/
  PROCEDURE INS#TARIFF(a#house_id   NUMBER,
                       a#date_begin DATE,
                       a#date_end   DATE,
                       a#new_tarif  NUMBER,
                       a#doer_id    NUMBER);

  /** 
	* Установка существующего тарифа для дома
	* @param a#house_id идентификатор дома
  * @param a#works_id тариф
  * @param a#r_doing  РКЦ
  * @param a#date_begin дата начала действия тарифа
  * @param a#date_end   дата окончания действия тарифа
	*/
  PROCEDURE DO#TARIFF(a#house_id   NUMBER,
                      a#works_id   NUMBER,
                      a#r_doing    type_RecDoing,
                      a#date_begin DATE,
                      a#date_end   DATE);

  PROCEDURE DO#RECALC_CHARGE(a#house_id   NUMBER, -- дом
                             a#work_id    NUMBER, -- новый тариф
                             a#date_begin DATE, -- дата начала действия тарифа
                             a#date_end   DATE -- дата окончания действия тарифа
  );

END P#FCR_HOUSE;

/


CREATE OR REPLACE PACKAGE BODY P#FCR_HOUSE
  IS


  FUNCTION GET#PAYMENT_HOUSE(a#house_id NUMBER,
                             a#acc_type NUMBER)
    RETURN sys_refcursor
    IS
      ret sys_refcursor;
    BEGIN
      OPEN ret FOR
      SELECT k.c#name,
             k.c#cod,
             SUM(c#sum)
        FROM fcr.v#op v
          INNER JOIN (SELECT vo.c#id,
                             tok.c#name,
                             tok.c#cod
              FROM fcr.v#ops vo
                INNER JOIN fcr.t#ops_kind tok
                  ON (vo.c#kind_id = tok.c#id)) k
            ON (v.c#ops_id = k.c#id)
        WHERE c#account_id IN (SELECT va.c#id
              FROM fcr.v#account va
                INNER JOIN fcr.t#rooms tr
                  ON (va.c#rooms_id = tr.c#id)
              WHERE 1 = 1
                AND (va.c#end_date IS NULL
                OR va.c#date <> va.c#end_date)
                AND (a#house_id IS NULL
                OR tr.c#house_id = a#house_id)
                AND tr.c#house_id IN (SELECT c#house_id
                    FROM fcr.v#banking vb
                      INNER JOIN fcr.t#b_account tba
                        ON (vb.c#b_account_id = tba.c#id)
                    WHERE a#acc_type IS NULL
                      OR c#acc_type = a#acc_type))
        GROUP BY k.c#name,
                 k.c#cod;
      RETURN ret;
    END;

  PROCEDURE UPD#HOUSE_INFO(A#ROOF_L_YEAR   NUMBER,
                           A#ROOF_H_YEAR   NUMBER,
                           A#FACE_L_YEAR   NUMBER,
                           A#FACE_H_YEAR   NUMBER,
                           A#ISYS_L_YEAR   NUMBER,
                           A#ISYS_H_YEAR   NUMBER,
                           A#CMET_L_YEAR   NUMBER,
                           A#CMET_H_YEAR   NUMBER,
                           A#ELEV_L_YEAR   NUMBER,
                           A#ELEV_H_YEAR   NUMBER,
                           A#BASE_L_YEAR   NUMBER,
                           A#BASE_H_YEAR   NUMBER,
                           A#FUND_L_YEAR   NUMBER,
                           A#FUND_H_YEAR   NUMBER,
                           A#VOTE_DATE     DATE,
                           A#VOTE_TEXT     VARCHAR2,
                           A#ORG_NAME      VARCHAR2,
                           A#GOV_NAME      VARCHAR2,
                           A#OMSU_ID       VARCHAR2,
                           A#LIVE_AREA_VAL NUMBER,
                           A#FLORS         VARCHAR2,
                           A#ELEV_COL      NUMBER,
                           A#HOUSE_ID      NUMBER,
                           A#PROG_NUM      NUMBER,
                           A#GU_ID         NUMBER,
                           A#1ST_DATE      DATE,
                           A#2ND_DATE      DATE,
                           A#END_DATE      DATE,
                           A#AREA_VAL      NUMBER,
                           A#FLOOR_CNT     NUMBER,
                           A#ELEVATOR_TAG  VARCHAR2,
                           A#BASEMENT_TAG  VARCHAR2,
                           A#WALL_TYPE_ID  NUMBER,
                           A#CREATE_YEAR   NUMBER)
    IS

    BEGIN
      UPDATE fcr.t#house_info
        SET C#1ST_DATE = A#1ST_DATE, C#2ND_DATE = A#2ND_DATE, C#AREA_VAL = A#AREA_VAL, C#BASEMENT_TAG = A#BASEMENT_TAG, C#BASE_H_YEAR = A#BASE_H_YEAR, C#BASE_L_YEAR = A#BASE_L_YEAR, C#CMET_H_YEAR = A#CMET_H_YEAR, C#CMET_L_YEAR = A#CMET_L_YEAR, C#CREATE_YEAR = A#CREATE_YEAR, C#ELEVATOR_TAG = A#ELEVATOR_TAG, C#ELEV_COL = A#ELEV_COL, C#ELEV_H_YEAR = A#ELEV_H_YEAR, C#ELEV_L_YEAR = A#ELEV_L_YEAR, C#END_DATE = A#END_DATE, C#FACE_H_YEAR = A#FACE_H_YEAR, C#FACE_L_YEAR = A#FACE_L_YEAR, C#FLOOR_CNT = A#FLOOR_CNT, C#FLORS = A#FLORS, C#FUND_H_YEAR = A#FUND_H_YEAR, C#FUND_L_YEAR = A#FUND_L_YEAR, C#GOV_NAME = A#GOV_NAME, C#GU_ID = A#GU_ID, C#ISYS_H_YEAR = A#ISYS_H_YEAR, C#ISYS_L_YEAR = A#ISYS_L_YEAR, C#LIVE_AREA_VAL = A#LIVE_AREA_VAL, C#OMSU_ID = A#OMSU_ID, C#ORG_NAME = A#ORG_NAME, C#PROG_NUM = A#PROG_NUM, C#ROOF_H_YEAR = A#ROOF_H_YEAR, C#ROOF_L_YEAR = A#ROOF_L_YEAR, C#VOTE_DATE = A#VOTE_DATE, C#VOTE_TEXT = A#VOTE_TEXT, C#WALL_TYPE_ID = A#WALL_TYPE_ID
        WHERE c#house_id = A#house_id;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'UPD#HOUSE_INFO', sysdate, a#err, '');
          RAISE_APPLICATION_ERROR(-20001, 'Rollback UPD#HOUSE_INFO: ' || SQLCODE || ', ' || SQLERRM);
    END;

  FUNCTION LST#DOLG(a#house_id INTEGER)
    RETURN sys_refcursor
    IS
      ret sys_refcursor;
    BEGIN

      OPEN ret FOR
      SELECT acc.c#num AS "Счет",
             qop.c#out_num AS "Внешний Счет",
             pers.c#name AS "ФИО",
             FCR.P#UTILS.GET#ROOMS_ADDR(r.c#id) AS "Адрес",
             vrs.c#area_val * NVL(acc.c#part_coef, 1) AS "Площадь",
             NVL(ch.c#sum, 0) AS "Начислено",
             NVL(op.c#sum, 0) AS "Оплата",
             NVL(ch.c#sum, 0) - NVL(op.c#sum, 0) AS "Долг",
             acc_beg_date "ДатаОткрытияСчета",
             acc_end_date "ДатаЗакрытияСчета"
        FROM (SELECT a.c#id,
                     a.c#num,
                     asp.c#person_id,
                     a.c#rooms_id,
                     asp.c#part_coef,
                     a.c#date acc_beg_date,
                     a.c#end_date acc_end_date
            FROM fcr.v#account a
              INNER JOIN fcr.v#account_spec asp
                ON (a.c#id = asp.c#account_id)
            WHERE asp.c#valid_tag = 'Y'
              AND (a.c#end_date IS NULL
              OR a.c#date <= a.c#end_date)) acc
          LEFT JOIN (SELECT *
              FROM fcr.t#account_op top
              WHERE c#date = (SELECT MAX(c#date)
                    FROM fcr.t#account_op
                    WHERE c#account_id = top.c#account_id)) qop
            ON (acc.c#id = qop.c#account_id)
          INNER JOIN (SELECT *
              FROM fcr.t#rooms) r
            ON (r.c#id = acc.c#rooms_id)
          INNER JOIN (SELECT *
              FROM fcr.v#rooms_spec vrs1
              WHERE vrs1.c#valid_tag = 'Y') vrs
            ON (r.c#id = vrs.c#rooms_id)
          INNER JOIN (SELECT *
              FROM fcr.t#house) h
            ON (r.c#house_id = h.c#id)
          INNER JOIN (SELECT p.c#id,
                             pp.c#f_name || ' ' || c#i_name || ' ' || pp.c#o_name AS c#name
              FROM fcr.t#person p
                INNER JOIN fcr.t#person_p pp
                  ON (pp.c#person_id = p.c#id)
              UNION
            SELECT p.c#id,
                   pj.c#name
              FROM fcr.t#person p
                INNER JOIN fcr.t#person_j pj
                  ON (pj.c#person_id = p.c#id)) pers
            ON (pers.c#id = acc.c#person_id)
          LEFT JOIN (SELECT c#account_id,
                            SUM(c#sum) c#sum
              FROM fcr.v#op
                where
                     C#TYPE_TAG = 'P'
              
              GROUP BY c#account_id) op
            ON (acc.c#id = op.c#account_id)
          LEFT JOIN (SELECT c#account_id,
                            SUM(c#sum) c#sum
              FROM fcr.t#charge
              GROUP BY c#account_id) ch
            ON (acc.c#id = ch.c#account_id)
        WHERE h.c#id = a#house_id 
        and (NVL(ch.c#sum, 0) <> 0 or NVL(op.c#sum, 0) <> 0)
        ORDER BY LPAD(r.C#FLAT_NUM,10,'0')
      ;
      RETURN ret;

    END;


  FUNCTION GET#HOUSE_MONTH_SUM(a#house_id   INTEGER,
                               a#date_month DATE)
    RETURN NUMBER
    IS
      a#house_sum NUMBER;
      a#tar       NUMBER;
    BEGIN
      a#house_sum := fcr.p#fcr_house.GET#HOUSE_AREA(a#house_id) * GET#HOUSE_TAR(a#house_id, a#date_month);
      RETURN a#house_sum;
    END;

  FUNCTION GET#HOUSE_TAR(a#house_id   INTEGER,
                         a#date_month DATE)
    RETURN NUMBER
    IS
      a#tar NUMBER;
    BEGIN
      -- определяем тариф по дому на дату
      SELECT NVL(c#tar_val, 0)
        INTO a#tar
        FROM fcr.v#doing vd
          INNER JOIN v#work vw
            ON (vw.c#works_id = vd.c#works_id)
        WHERE c#house_id = a#house_id
          AND a#date_month >= vd.c#date
          AND (vd.c#end_date IS NULL
          OR a#date_month < vd.c#end_date)
          AND vw.c#date = (SELECT MAX(c#date)
              FROM v#work
              WHERE c#works_id = vw.c#works_id
                AND c#date <= a#date_month);
      RETURN a#tar;
    END;

  FUNCTION GET#HOUSE_AREA(a#house_id INTEGER)
    RETURN NUMBER
    IS
      a#house_area NUMBER;
    BEGIN
      -- определяем суммарную площадь помещений в доме
      SELECT SUM(NVL(rs.c#area_val, 0))
        INTO a#house_area
        FROM (SELECT c#rooms_id
            FROM fcr.v#account
            WHERE (c#end_date IS NULL
              OR c#end_date <> c#date)) va
          INNER JOIN fcr.t#rooms tr
            ON (tr.c#id = va.c#rooms_id)
          INNER JOIN (SELECT *
              FROM fcr.v#rooms_spec t2
              WHERE c#valid_tag = 'Y'
                AND c#date = (SELECT MAX(c#date)
                    FROM fcr.v#rooms_spec
                    WHERE c#valid_tag = 'Y'
                      AND c#rooms_id = t2.c#rooms_id)) rs
            ON (rs.C#ROOMS_ID = tr.C#ID)
        WHERE tr.c#house_id = a#house_id;
      RETURN NVL(a#house_area, 0);
    END;

  FUNCTION LST#SHOW_TARIFF(a#house_id INTEGER)
    RETURN sys_refcursor
    IS
      ret sys_refcursor;
    BEGIN

      OPEN ret FOR
      SELECT tw.c#name c#name,
             vw.c#tar_val c#tariff,
             vw.c#date c#date,
             d.c#end_date c#end_date,
             do.c#name c#doer
        FROM fcr.t#works tw
          INNER JOIN fcr.v#work vw
            ON (tw.c#id = vw.C#WORKS_ID)
          INNER JOIN (SELECT *
              FROM fcr.v#doing
              WHERE c#house_id = a#house_id) d
            ON (d.c#works_id = vw.C#WORKS_ID)
          INNER JOIN fcr.t#doer do
            ON (d.c#doer_id = do.c#id)
        ORDER BY vw.c#id,
                 d.c#date;

      RETURN ret;

    END;

  PROCEDURE INS#HOUSE_FROM_FIAS(a#houseguid VARCHAR2)
    IS
      a#c_id       INTEGER;
      a#close_id   INTEGER;
      a#b_close_id INTEGER;
      a#open_mn    NUMBER(4);
      a#id_house   NUMBER;
    BEGIN

      SELECT MAX(c#id_house) + 1
        INTO a#id_house
        FROM fcr.t#house;
      SELECT fcr.p#utils.GET#OPEN_MN
        INTO a#open_mn
        FROM dual;

      INSERT INTO fcr.t#house (
        c#addr_obj_id, c#num, c#b_num, c#s_num, c#post_code, c#fias_guid, c#id_house
      )
      (SELECT (SELECT c#id
                  FROM fcr.t#addr_obj
                  WHERE c#fias_guid = h68.aoguid),
              h68.housenum,
              h68.buildnum,
              h68.strucnum,
              h68.postalcode,
              h68.houseguid,
              a#id_house
          FROM fcr.t_house68 h68
          WHERE startdate = (SELECT MAX(startdate)
                FROM fcr.t_house68
                WHERE houseguid = h68.houseguid)
            AND h68.HOUSEGUID = a#houseguid);

      SELECT c#id
        INTO a#c_id
        FROM fcr.t#house th
        WHERE c#fias_guid = a#houseguid;

      INSERT INTO fcr.t#close (
        c#house_id, c#service_id
      )
      VALUES (a#c_id, 1) RETURNING c#id INTO a#close_id;
      INSERT INTO fcr.t#close_vd (
        c#id, c#vn, c#valid_tag, c#mn
      )
      VALUES (a#close_id, 1, 'Y', a#open_mn);
      INSERT INTO fcr.t#b_close (
        c#house_id, c#service_id
      )
      VALUES (a#c_id, 1) RETURNING c#id INTO a#b_close_id;
      INSERT INTO fcr.t#b_close_vd (
        c#id, c#vn, c#valid_tag, c#mn
      )
      VALUES (a#close_id, 1, 'Y', a#open_mn);

      INSERT INTO fcr.t#house_info (
        c#house_id
      )
      VALUES (a#c_id);

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'INS#HOUSE_FIAS', sysdate, a#err, '');
          RAISE_APPLICATION_ERROR(-20001, 'Rollback INS#HOUSE_FIAS: ' || SQLCODE || ', ' || SQLERRM);
    END;

  PROCEDURE INS#HOUSE(a#addrid NUMBER,
                      a#num    VARCHAR2,
                      a#bnum   VARCHAR2,
                      a#snum   VARCHAR2,
                      a#post   VARCHAR2,
                      a#fias   VARCHAR2)
    IS
      a#c_id       INTEGER;
      a#banking_id INTEGER;
      a#close_id   INTEGER;
      a#b_close_id INTEGER;
      a#open_mn    NUMBER(4);
      a#id_house   NUMBER;
    BEGIN
      SELECT MAX(c#id_house) + 1
        INTO a#id_house
        FROM fcr.t#house;

      SELECT fcr.p#utils.GET#OPEN_MN
        INTO a#open_mn
        FROM dual;

      INSERT INTO fcr.t#house (
        c#addr_obj_id, c#num, c#b_num, c#s_num, c#post_code, c#fias_guid, c#id_house
      )
      VALUES (a#addrid, a#num, a#bnum, a#snum, a#post, a#fias, a#id_house) RETURNING c#id INTO a#c_id;

      -- назначаем общий счет  для дома
      INSERT INTO fcr.t#banking (
        C#HOUSE_ID, c#service_id
      )
      VALUES (a#c_id, 1) RETURNING c#id INTO a#banking_id;
      INSERT INTO fcr.t#banking_vd (
        c#vn, c#valid_tag, c#b_account_id, c#id
      )
      VALUES (1, 'Y', 1, a#banking_id);

      INSERT INTO fcr.t#close (
        c#house_id, c#service_id
      )
      VALUES (a#c_id, 1) RETURNING c#id INTO a#close_id;
      INSERT INTO fcr.t#close_vd (
        c#id, c#vn, c#valid_tag, c#mn
      )
      VALUES (a#close_id, 1, 'Y', a#open_mn);
      INSERT INTO fcr.t#b_close (
        c#house_id, c#service_id
      )
      VALUES (a#c_id, 1) RETURNING c#id INTO a#b_close_id;
      INSERT INTO fcr.t#b_close_vd (
        c#id, c#vn, c#valid_tag, c#mn
      )
      VALUES (a#close_id, 1, 'Y', a#open_mn);

      INSERT INTO fcr.t#house_info (
        c#house_id
      )
      VALUES (a#c_id);

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'INS#HOUSE', sysdate, a#err, '');
          RAISE_APPLICATION_ERROR(-20001, 'Rollback INS#HOUSE: ' || SQLCODE || ', ' || SQLERRM);
    END;

  PROCEDURE DEL#HOUSE(a#house_id NUMBER)
    IS
    BEGIN
      COMMIT;
      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('CLOSE_VD#PASS_MOD');
      DELETE FROM fcr.t#close_vd
        WHERE c#id IN (SELECT c#id
              FROM fcr.t#close
              WHERE c#house_id = a#house_id);
      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('CLOSE#PASS_MOD');
      DELETE fcr.t#close
        WHERE c#house_id = a#house_id;

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('BANKING_VD#PASS_MOD');
      DELETE fcr.t#banking_vd
        WHERE c#id IN (SELECT c#id
              FROM fcr.t#banking
              WHERE c#house_id = a#house_id);

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('BANKING#PASS_MOD');
      DELETE FROM fcr.t#banking
        WHERE c#house_id = a#house_id;

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('B_CLOSE_VD#PASS_MOD');

      DELETE fcr.t#b_close_vd
        WHERE c#id IN (SELECT c#id
              FROM fcr.t#b_close
              WHERE c#house_id = a#house_id);

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('B_CLOSE#PASS_MOD');
      DELETE FROM fcr.t#b_close
        WHERE c#house_id = a#house_id;

      EXECUTE IMMEDIATE 'alter trigger TR#B_STORE#WARD disable';
      DELETE FROM fcr.t#b_store
        WHERE c#house_id = a#house_id;
      EXECUTE IMMEDIATE 'alter trigger TR#B_STORE#WARD enable';
      DELETE FROM fcr.t#b_obj
        WHERE c#house_id = a#house_id;

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('DOING_VD#PASS_MOD');
      DELETE fcr.t#doing_vd
        WHERE c#id = (SELECT c#id
              FROM fcr.t#doing
              WHERE c#house_id = a#house_id);
      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('DOING#PASS_MOD');
      DELETE fcr.t#doing
        WHERE c#house_id = a#house_id;

      DELETE fcr.t#house_info
        WHERE c#house_id = a#house_id;

      DELETE fcr.t#house
        WHERE c#id = a#house_id;

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'DEL#HOUSE', sysdate, a#err, TO_CHAR(a#house_id));

          --     dbms_output.put_line('Rollback DEL#HOUSE: ' || SQLCODE || ', ' ||
          --                           SQLERRM);
          RAISE_APPLICATION_ERROR(-20001, 'Rollback DEL#HOUSE: ' || SQLCODE || ', ' || SQLERRM);
    END;

  PROCEDURE DO#RECALC_CHARGE(a#house_id   NUMBER, -- дом
                             a#work_id    NUMBER, -- новый тариф
                             a#date_begin DATE, -- дата начала действия тарифа
                             a#date_end   DATE -- дата окончания действия тарифа
  )
    IS
      a#new_tarif NUMBER;
      a#mn_begin  NUMBER;
      a#mn_end    NUMBER;
    BEGIN

      SELECT c#tar_val
        INTO a#new_tarif
        FROM fcr.v#work
        WHERE c#id = a#work_id;

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('CHARGE#PASS_MOD');
      a#mn_begin := fcr.p#mn_utils.GET#MN(a#date_begin);
      IF a#date_end IS NOT NULL
      THEN
        a#mn_end := fcr.p#mn_utils.GET#MN(a#date_end);
      ELSE
        a#mn_end := fcr.p#utils.GET#OPEN_MN;
      END IF;

      UPDATE (SELECT c#account_id,
                     c#work_id,
                     c#vol,
                     c#sum,
                     c#sum / c#vol,
                     c#vol * a#new_tarif
          FROM fcr.t#charge
          WHERE c#account_id IN (SELECT a.c#id
                FROM fcr.t#account a
                  INNER JOIN fcr.t#rooms r
                    ON (a.c#rooms_id = r.c#id)
                WHERE c#house_id = a#house_id)
            AND c#a_mn >= a#mn_begin
            AND c#a_mn <= a#mn_end)
        SET c#work_id = a#work_id, c#sum = c#vol * a#new_tarif;

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'DO#RECALC_CHARGE', sysdate, a#err, '');

    --     dbms_output.put_line('Rollback DO#RECALC_CHARGE: ' || SQLCODE || ', ' ||  SQLERRM);
    END;

  PROCEDURE DO#TARIFF(a#house_id   NUMBER, -- дом
                      a#works_id   NUMBER, -- тариф
                      a#r_doing    type_RecDoing, -- РКЦ
                      a#date_begin DATE, -- дата начала действия тарифа
                      a#date_end   DATE -- дата окончания действия тарифа
  )
    IS
      a#doing_id NUMBER;
      a#exist    NUMBER;
      a#doing_vn NUMBER;
    BEGIN

      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.v#doing
        WHERE c#house_id = a#house_id
          AND c#works_id = a#works_id
          AND c#date = a#date_begin;

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('DOING#PASS_MOD');
      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('DOING_VD#PASS_MOD');

      IF a#exist = 0
      THEN

        SELECT COUNT(*)
          INTO a#exist
          FROM fcr.t#doing
          WHERE c#house_id = a#house_id
            AND c#works_id = a#works_id
            AND c#date = a#date_begin;

        IF a#exist = 0
        THEN
          INSERT INTO fcr.t#doing (
            c#house_id, c#works_id, c#date
          )
          VALUES (a#house_id, a#works_id, a#date_begin) RETURNING c#id INTO a#doing_id;
        ELSE
          SELECT c#id
            INTO a#doing_id
            FROM fcr.t#doing
            WHERE c#house_id = a#house_id
              AND c#works_id = a#works_id
              AND c#date = a#date_begin;
        END IF;

        IF (a#date_end IS NOT NULL)
        THEN
          INSERT INTO fcr.t#doing_vd (
            c#id, c#vn, c#valid_tag, c#doer_id, c#end_date
          )
          VALUES (a#doing_id, a#r_doing.m#vn, 'Y', a#r_doing.m#doer_id, LAST_DAY(a#date_end));
        ELSE

          SELECT c#id
            INTO a#doing_id
            FROM fcr.t#doing
            WHERE c#house_id = a#house_id
              AND c#works_id = a#works_id
              AND c#date = a#date_begin;

          -- вставляем новый бесконечный период
          INSERT INTO fcr.t#doing_vd (
            c#id, c#vn, c#valid_tag, c#doer_id
          )
          VALUES (a#doing_id, a#r_doing.m#vn, 'Y', a#r_doing.m#doer_id);

          -- закрываем действовавший ранее, если он есть
          SELECT COUNT(*)
            INTO a#exist
            FROM fcr.t#doing td
              LEFT JOIN fcr.t#doing_vd tdv
                ON (td.c#id = tdv.c#id)
            WHERE td.c#house_id = a#house_id
              AND td.c#works_id <> a#works_id
              AND tdv.c#end_date IS NULL;

          IF (a#exist > 0)
          THEN
            UPDATE fcr.t#doing_vd
              SET c#end_date = a#date_begin - 1
              WHERE c#id IN (SELECT td.c#id
                  FROM fcr.t#doing td
                    LEFT JOIN fcr.t#doing_vd tdv
                      ON (td.c#id = tdv.c#id)
                  WHERE td.c#house_id = a#house_id
                    AND td.c#works_id <> a#works_id
                    AND tdv.c#end_date IS NULL);
          END IF;
        END IF;
      ELSE
        -- проверить вторую часть 
        SELECT c#id
          INTO a#doing_id
          FROM fcr.t#doing
          WHERE c#house_id = a#house_id
            AND c#works_id = a#works_id
            AND c#date = a#date_begin;
        SELECT COUNT(*)
          INTO a#exist
          FROM fcr.t#doing_vd
          WHERE c#id = a#doing_id
            AND c#doer_id = a#r_doing.m#doer_id
            AND (c#end_date IS NULL
            OR (c#end_date = a#date_end));

        IF a#exist = 0
        THEN
          SELECT MAX(c#vn) + 1
            INTO a#doing_vn
            FROM t#doing_vd
            WHERE c#id = a#doing_id
            GROUP BY c#doer_id;

          INSERT INTO fcr.t#doing_vd (
            c#id, c#vn, c#valid_tag, c#doer_id
          )
          VALUES (a#doing_id, a#doing_vn, 'Y', a#r_doing.m#doer_id);
        END IF;

      END IF;

      BEGIN
        -- применяем для всех счетов дома
        INSERT INTO fcr.t#obj (
          c#account_id, c#work_id, c#doer_id
        )
          SELECT acc.c#id,
                 w.c#id,
                 a#r_doing.m#doer_id
            FROM (SELECT ta.c#id
                     FROM fcr.t#account ta
                       INNER JOIN fcr.t#rooms tr
                         ON (ta.c#rooms_id = tr.c#id)
                     WHERE tr.c#house_id = a#house_id) acc,
                 (SELECT c#id
                     FROM fcr.t#work
                     WHERE c#works_id = a#works_id) w
            WHERE NOT EXISTS (SELECT c#account_id
                  FROM fcr.t#obj
                  WHERE c#account_id = acc.c#id
                    AND c#work_id = w.c#id
                    AND c#doer_id = a#r_doing.m#doer_id);
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END t_obj;

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'DO#TARIFF', sysdate, a#err, '');
    --     dbms_output.put_line('Rollback DO#TARIFF : ' || SQLCODE || ', ' || SQLERRM);

    END;

  PROCEDURE INS#NEW_TARIFF(a#house_id   NUMBER, -- дом
                           a#date_begin DATE, -- дата начала действия тарифа
                           a#date_end   DATE, -- дата окончания действия тарифа
                           a#new_tarif  NUMBER -- новый тариф
  )
    IS

      a#address     VARCHAR2(250);
      a#flag_create NUMBER;
      a#works_id    NUMBER;
      a#work_id     NUMBER;
      a#r_doing     type_RecDoing;
      a#doing_id    NUMBER;
    BEGIN
      -- адрес дома
      SELECT fcr.p#utils.GET#HOUSE_ADDR(a#house_id)
        INTO a#address
        FROM dual;
      dbms_output.put_line(a#address);

      SELECT COUNT(*)
        INTO a#flag_create
        FROM fcr.t#works tw
          LEFT JOIN fcr.v#work vw
            ON (tw.c#id = vw.C#WORKS_ID)
        WHERE tw.house_id = a#house_id
          AND vw.c#tar_val = a#new_tarif;

      IF (a#flag_create = 0)
      THEN
        -- спец счета нет
        -- добавить тариф
        INSERT INTO fcr.t#works (
          c#service_id, c#name, house_id
        )
        VALUES (1, 'СТ ' || a#address || ' : ' || a#new_tarif, a#house_id) RETURNING c#id INTO a#works_id;
        dbms_output.put_line(' a#works_id :' || a#works_id);
        -- начинаем его применять с даты
        INSERT INTO fcr.t#work (
          c#works_id, c#date
        )
        VALUES (a#works_id, a#date_begin) RETURNING c#id INTO a#work_id;
        dbms_output.put_line(' a#work_id :' || a#work_id);
        -- устанавливаем значение тарифа
        INSERT INTO fcr.t#work_vd (
          c#id, c#vn, c#valid_tag, c#tar_type_tag, c#tar_val
        )
        VALUES (a#work_id, (SELECT NVL(MAX(c#vn), 0) + 1 FROM fcr.t#work_vd WHERE c#id = a#work_id), 'Y', 'A', a#new_tarif);
        /*       
            -- применяем для всех счетов дома
            select max(c#vn) + 1, c#doer_id
              into a#r_doing
              from v#doing
             where c#house_id = a#house_id
             group by c#doer_id;
          
            insert into fcr.t#obj
              (c#account_id, c#work_id, c#doer_id)
              select a.c#id, a#work_id, a#r_doing.m#doer_id
                from fcr.t#account a
               inner join fcr.t#rooms r
                  on (a.c#rooms_id = r.c#id)
               where c#house_id = a#house_id;
        */
        COMMIT;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'INS#NEW_TARIFF', sysdate, a#err, '');

    --     dbms_output.put_line('Rollback INS#NEW_TARIFF: ' || SQLCODE || ', ' ||
    --                           SQLERRM);
    END;

  PROCEDURE INS#PERIOD_FOR_TARIFF(p#house_id   NUMERIC,
                                  p#works_id   NUMERIC,
                                  p#date_begin DATE,
                                  p#date_end   DATE)
    IS
      a#doing_id NUMBER;
      a#c_vn     NUMBER;
      a#exist    NUMBER;
    BEGIN


      -- выделяем периоды попавшие внутрь отрезка для удаления
      -- удалить

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('DOING_VD#PASS_MOD');

      DELETE FROM fcr.t#doing_vd
        WHERE c#id IN (SELECT td.c#id
              FROM fcr.t#doing td
                LEFT JOIN fcr.t#doing_vd tdv
                  ON (td.c#id = tdv.c#id)
              WHERE td.c#house_id = p#house_id
                AND td.c#works_id <> p#works_id
                AND c#date >= p#date_begin
                AND NVL(c#end_date, sysdate) <= CASE WHEN p#date_end IS NULL THEN sysdate ELSE p#date_end END);

      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('DOING#PASS_MOD');

      DELETE FROM fcr.t#doing
        WHERE c#id IN (SELECT td.c#id
              FROM fcr.t#doing td
                LEFT JOIN fcr.t#doing_vd tdv
                  ON (td.c#id = tdv.c#id)
              WHERE td.c#house_id = p#house_id
                AND td.c#works_id <> p#works_id
                AND c#date >= p#date_begin
                AND NVL(c#end_date, sysdate) <= CASE WHEN p#date_end IS NULL THEN sysdate ELSE p#date_end END);

      -- если есть больший период с незакрытым краем удаляем вставляемый
      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.t#doing td
          LEFT JOIN fcr.t#doing_vd tdv
            ON (td.c#id = tdv.c#id)
        WHERE td.c#house_id = p#house_id
          AND td.c#works_id = p#works_id
          AND c#date <= p#date_begin
          AND tdv.c#end_date IS NULL;

      IF (a#exist > 0)
      THEN

        DELETE FROM fcr.t#doing
          WHERE c#id IN (SELECT td.c#id
                FROM fcr.t#doing td
                  LEFT JOIN fcr.t#doing_vd tdv
                    ON (td.c#id = tdv.c#id)
                WHERE td.c#house_id = p#house_id
                  AND td.c#works_id = p#works_id
                  AND c#date = p#date_begin
                  AND c#end_date = p#date_end);

      END IF;

      -- обрезаем края

      -- правый край
      UPDATE fcr.t#doing_vd
        SET c#end_date = p#date_begin - 1
        WHERE c#id IN (SELECT td.c#id
            FROM fcr.t#doing td
              LEFT JOIN fcr.t#doing_vd tdv
                ON (td.c#id = tdv.c#id)
            WHERE td.c#house_id = p#house_id
              AND td.c#works_id <> p#works_id
              AND c#end_date >= p#date_begin
              AND c#end_date <= p#date_end
              AND td.c#id = (SELECT MAX(c#id)
                  FROM fcr.t#doing
                  WHERE c#house_id = td.c#house_id
                    AND c#works_id <> p#works_id
                    AND c#end_date >= p#date_begin
                    AND NVL(c#end_date, sysdate) <= CASE WHEN p#date_end IS NULL THEN sysdate ELSE p#date_end END));

      -- левый край
      UPDATE fcr.t#doing
        SET c#date = p#date_end + 1
        WHERE c#id IN (SELECT td.c#id
            FROM fcr.t#doing td
              LEFT JOIN fcr.t#doing_vd tdv
                ON (td.c#id = tdv.c#id)
            WHERE td.c#house_id = p#house_id
              AND td.c#works_id <> p#works_id
              AND c#date >= p#date_begin
              AND c#date <= CASE WHEN p#date_end IS NULL THEN sysdate ELSE p#date_end END
              AND c#end_date IS NOT NULL
              AND td.c#id = (SELECT MAX(c#id)
                  FROM fcr.t#doing
                  WHERE c#house_id = td.c#house_id
                    AND c#works_id <> p#works_id
                    AND c#date >= p#date_begin
                    AND c#date <= CASE WHEN p#date_end IS NULL THEN sysdate ELSE p#date_end END));
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'INS#PERIOD_FOR_TARIFF', sysdate, a#err, '');

    --     dbms_output.put_line('Rollback INS#PERIOD_FOR_TARIFF: ' || SQLCODE || ', ' ||
    --                           SQLERRM);
    END;

  PROCEDURE INS#TARIFF(a#house_id   NUMBER, -- дом
                       a#date_begin DATE, -- дата начала действия тарифа
                       a#date_end   DATE, -- дата окончания действия тарифа
                       a#new_tarif  NUMBER, -- новый тариф
                       a#doer_id    NUMBER -- РКЦ
  )
    IS

      a#address    VARCHAR2(250);
      a#flag_exist NUMBER;
      a#works_id   NUMBER;
      a#work_id    NUMBER;
      a#r_doing    type_RecDoing;
      a#doing_id   NUMBER;
    BEGIN
      -- если в доме есть счета
      SELECT COUNT(*)
        INTO a#flag_exist
        FROM fcr.v#account ta
          INNER JOIN fcr.t#rooms tr
            ON (ta.c#rooms_id = tr.c#id)
        WHERE tr.c#house_id = a#house_id;

      IF (a#flag_exist > 0)
      THEN

        SELECT COUNT(*)
          INTO a#flag_exist
          FROM fcr.v#work
          WHERE c#tar_val = a#new_tarif;

        IF (a#flag_exist = 0)
        THEN
          -- создать тариф
          INS#NEW_TARIFF(a#house_id, -- дом
          a#date_begin, -- дата начала действия тарифа
          a#date_end, -- дата окончания действия тарифа
          a#new_tarif -- новый тариф
          );

        END IF;

        -- определить параметры тарифа
        SELECT tw.c#id,
               vw.c#id
          INTO a#works_id,
               a#work_id
          FROM fcr.t#works tw
            LEFT JOIN fcr.v#work vw
              ON (tw.c#id = vw.C#WORKS_ID)
          WHERE vw.c#tar_val = a#new_tarif;

        -- применяем его к дому
        SELECT COUNT(*)
          INTO a#flag_exist
          FROM v#doing
          WHERE c#house_id = a#house_id
            AND c#doer_id = a#doer_id;

        IF (a#flag_exist > 0)
        THEN
          SELECT MAX(c#vn) + 1,
                 c#doer_id
            INTO a#r_doing
            FROM v#doing
            WHERE c#house_id = a#house_id
            GROUP BY c#doer_id;
        ELSE
          a#r_doing.m#vn := 1;
          a#r_doing.m#doer_id := a#doer_id;
        END IF;

        DO#TARIFF(a#house_id,
        a#works_id,
        a#r_doing,
        a#date_begin,
        a#date_end);

        -- изменяем период действия тарифов действовавших ранее
        INS#PERIOD_FOR_TARIFF(a#house_id,
        a#works_id,
        a#date_begin,
        a#date_end);

        -- пересчитать начисления
        DO#RECALC_CHARGE(a#house_id, a#work_id, a#date_begin, a#date_end);

        -- пересчитать счета
        --for a#r in (select a.c#num    from fcr.t#account a  inner join fcr.t#rooms r on (a.c#rooms_id = r.c#id)
        --       where c#house_id = a#house_id ) loop
        --DO#RECALC_ACCOUNT(a#r.c#num,a#date_begin);
        --end loop; 

        COMMIT;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          a#err := 'Error - ' || TO_CHAR(SQLCODE) || ' - ' || SQLERRM;
          INSERT INTO fcr.t#exception (
            c#name_package, c#name_proc, c#date, c#text, c#comment
          )
          VALUES ('P#FCR_HOUSE', 'INS#TARIFF', sysdate, a#err, '');

    --      dbms_output.put_line('Rollback INS#TARIFF : ' || SQLCODE || ', ' ||
    --                           SQLERRM);

    END;

--begin
-- Initialization
--  <Statement>;
END P#FCR_HOUSE;
/
