--------------------------------------------------------
--  DDL for Package P#FCR_BANK
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FCR_BANK" 
  AS
  a#err VARCHAR2(4000);

  /**
  *  Список банков
  */
  FUNCTION LST#BANK
    RETURN sys_refcursor;
  /**
  * Добавление банка
  */
  FUNCTION ins#bank(a#name    VARCHAR2,
                    a#bic_num VARCHAR2,
                    a#ca_num  VARCHAR2)
    RETURN NUMBER;

  /**
  * Типы лицевых счетов
  */
  FUNCTION LST#TYPE_ACCOUNT
    RETURN sys_refcursor;

  /**
  * Счета банка
  */
  FUNCTION LST#BANK_ACCOUNT(a#bank_id NUMBER)
    RETURN sys_refcursor;

  /**
  * Счет дома
  */
  FUNCTION LST#ACCOUNT_HOUSE(a#house_id NUMBER)
    RETURN sys_refcursor;

  /**
  * Добавление счета в банк
  */
  FUNCTION ins#account(A#ACC_TYPE NUMBER,
                       A#BANK_ID  NUMBER,
                       A#NUM      VARCHAR2,
                       A#NAME     VARCHAR2,
                       A#INN_NUM  VARCHAR2,
                       A#KPP_NUM  VARCHAR2)
    RETURN NUMBER;

  /**
  * Удаление счета
  */
  PROCEDURE DEL#ACCOUNT(a#account_id NUMBER);

  /**
  * Изменение существующего счета
  */
  PROCEDURE UPD#account(A#account_ID NUMBER,
                        A#BANK_ID    NUMBER,
                        A#ACC_TYPE   NUMBER,
                        A#NUM        VARCHAR2,
                        A#NAME       VARCHAR2,
                        A#INN_NUM    VARCHAR2,
                        A#KPP_NUM    VARCHAR2);

  /**
  * Изменение счета дома
  */
  PROCEDURE upd#account_for_house(a#house_id     NUMBER,
                                  a#b_account_id NUMBER);

END P#FCR_BANK;

/
