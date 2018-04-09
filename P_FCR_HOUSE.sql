--------------------------------------------------------
--  DDL for Package P#FCR_HOUSE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FCR_HOUSE" 
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
