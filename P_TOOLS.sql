--------------------------------------------------------
--  DDL for Package P#TOOLS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#TOOLS" 
  AS
  
  PROCEDURE FILL_ACCOUNTS_ADRESES;

  FUNCTION GET_ACCOUNT_BY_ADRES(P_ADRES IN VARCHAR2)
    RETURN SYS_REFCURSOR;

  FUNCTION GET_PERSON_NAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_SNAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_1NAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_2NAME_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  FUNCTION GET_PERSON_TIP_BY_ID(P_PERSON_ID IN NUMBER) RETURN VARCHAR2;

  PROCEDURE ADD_NEW_ERC_ACCOUNTS;

  PROCEDURE ADD_NEW_ERC_ACCOUNTS_BY_ID;


-- добавляем внешний счет (равный внутреннему от той же даты) для аккаунтов у которых их нет
  PROCEDURE ADD_NEW_FCR_ACCOUNTS;
  
-- возвращает площадь помещения по номеру счета на дату  
  FUNCTION get#acc_area(a#acc_id NUMBER, a#date DATE DEFAULT sysdate) RETURN NUMBER;

-- возвращает адрес по account_id  
  FUNCTION get#acc_addr(a#acc_id NUMBER) RETURN VARCHAR2;

  
-- возвращает максимальную свободную дату для добавления РКЦ для заданного счета
  FUNCTION GET_NEW_RKC_DATE(p_ACC_ID NUMBER, p_DATE DATE) return DATE;

-- возвращает MN закрытия счета или 1000 если открыт
  FUNCTION get#end_account_mn(a#acc_id NUMBER) RETURN NUMBER;

-- возвращает для задонного acc_id количество записей из T#PAY_SOURCE с кодом РКЦ 88
  FUNCTION get#count_88(a#acc_id NUMBER) RETURN NUMBER;

-- возвращает account_id для номера счета
  FUNCTION get#acc_id#by#acc_num(a#acc_num VARCHAR2) RETURN NUMBER;

-- возвращает внутренний номер счета по account_id
  FUNCTION get#acc_num#by#acc_id(a#acc_id NUMBER) RETURN VARCHAR2;

-- перенос всех платежей со счета на счет (в параметрах указывать внутренние счета)  
  PROCEDURE transfer#all_pays(from_acc_num VARCHAR2, to_acc_num VARCHAR2);    

-- добавляет и делает текущей площадь для помещения
  PROCEDURE set_rooms_area(p_ROOMS_ID NUMBER, p_NEW_AREA NUMBER);


-- открыт дом с заданным ACCOUNT_ID или нет
  FUNCTION house_is_open(a#acc_id NUMBER) RETURN VARCHAR2;

-- закрыт ли счет в день открытия
  FUNCTION account_is_open_error(a#acc_id NUMBER) RETURN VARCHAR2;


-- тип баковского счета (котел, спец) по id дома
  FUNCTION ACC_TYPE_BY_HOUSE_ID(a#house_id NUMBER) RETURN VARCHAR2;


-- удаляет для указанного счета все записи из T#MASS_PAY, T#OP, T#OP_VD
    PROCEDURE DEL#MASS_PAY_FOR_ACC(a#acc_id NUMBER);    


    PROCEDURE FILL_CHARGE_PAY_J_TABLES(p_PERSON_ID INTEGER);

END P#TOOLS;

/
