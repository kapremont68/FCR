--------------------------------------------------------
--  DDL for Package P#UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#UTILS" 
  IS

  -- адрес
  FUNCTION GET#ADDR_NUM(A#NUM VARCHAR2)
    RETURN NUMBER DETERMINISTIC;
  FUNCTION GET#ADDR_OBJ_PATH(A#AO_ID    NUMBER,
                             A#FORM_TAG NUMBER := NULL)
    RETURN VARCHAR2;

  FUNCTION GET#HOUSE_ADDR(A#H_ID     NUMBER,
                          A#FORM_TAG NUMBER := NULL)
    RETURN VARCHAR2;

  FUNCTION GET#HOUSE_ADDR_SIMPLE(A#H_ID     NUMBER)
    RETURN VARCHAR2;


  FUNCTION GET#ROOMS_ADDR(A#R_ID     NUMBER,
                          A#FORM_TAG NUMBER := NULL)
    RETURN VARCHAR2;

  -- имя персоны
  FUNCTION GET#PERSON_NAME(A#P_ID NUMBER)
    RETURN VARCHAR2;
  -- тип персоны
  FUNCTION GET#TYPE_PERSON(A#P_ID NUMBER)
    RETURN VARCHAR2;

  -- инф. о помещении
  FUNCTION GET_OBJ#ROOMS(A#R_ID NUMBER,
                         A#DATE DATE)
    RETURN TOBJ#I_ROOMS;
  FUNCTION GET_OBJ#ROOMS(A#R_ID NUMBER,
                         A#MN   NUMBER)
    RETURN TOBJ#I_ROOMS;
  -- инф. о лицевом
  FUNCTION GET_OBJ#ACCOUNT(A#A_ID NUMBER,
                           A#DATE DATE)
    RETURN TOBJ#I_ACCOUNT;
  FUNCTION GET_OBJ#ACCOUNT(A#A_ID NUMBER,
                           A#MN   NUMBER)
    RETURN TOBJ#I_ACCOUNT;
  -- инф. о почтампте для индекса
  FUNCTION GET_OBJ#POSTAMT(A#CODE VARCHAR2)
    RETURN TOBJ#I_POSTAMT;
  -- инф. о почтампте для дома
  FUNCTION GET_OBJ#HOUSE_POSTAMT(A#H_ID NUMBER)
    RETURN TOBJ#I_POSTAMT;

  -- открытый период
  FUNCTION GET#OPEN_MN
    RETURN NUMBER;
  FUNCTION GET#OPEN_MN(A#H_ID NUMBER,
                       A#S_ID NUMBER := NULL)
    RETURN NUMBER;
  FUNCTION GET#OPEN_B_MN
    RETURN NUMBER;
  FUNCTION GET#OPEN_B_MN(A#H_ID NUMBER,
                         A#S_ID NUMBER := NULL)
    RETURN NUMBER;

  /**
  *  Действующий тариф для счета на дату
  *  @param a_account_id integer идентификатор счета
  *  @param a_date date дата определения тарифа 
  *  @return значение тарифа 
  */
  FUNCTION GET#TARIF(a_account_id INTEGER,
                     a_date       DATE)
    RETURN NUMBER;
  /**
  *  Долг для владельца по помещению на дату
  *  @param a#person_id integer идентификатор владельца
  *  @param a#rooms_id  integer идентификатор помещения
  *  @param a#date_end  date дата определения долга 
  *  @return сумма долга с начала действия программы на дату
  */
  FUNCTION GET#DOLG(a#person_id INTEGER,
                    a#rooms_id  INTEGER,
                    a#date_end  DATE)
    RETURN NUMBER;

  /**
  *  Количество лицевых счетов с долгом выше заданного порога
  *  @param a_summa number сумма порога
  *  @return number количество лицевых счетов
  */
  FUNCTION GET#COUNT_DOLG(a_summa NUMBER)
    RETURN NUMBER;

  /**
  *  Нераспределенный остаток для юридического лица
  *  @param a#person_id integer идентификатор юр лица
  *  @return сумма нераспределенного остатка
  */
  FUNCTION GET#OSTATOK_J(a#person_id INTEGER)
    RETURN NUMBER;

END;

/
