--------------------------------------------------------
--  DDL for Package P#CLAIM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#CLAIM" 
  IS
  /**
  *  Author: Alexander
  *  Created : 25-01-2017 
  */




  /**
  * Счета , которые должны больше указанной суммы.
  * @param  a_summa number  порог суммы
  * @result         number  список счетов
  */
  FUNCTION LST#ACCOUNT_DOLG(a_summa NUMBER)
    RETURN sys_refcursor;

  /**
  * Ввод данных суда
  */
  PROCEDURE INS#COURT(a_name    VARCHAR2,
                      a_address VARCHAR2,
                      a_index   VARCHAR2,
                      a_region  VARCHAR2);


  PROCEDURE UPD#COURT(a_id_court NUMBER,
                      a_name     VARCHAR2,
                      a_address  VARCHAR2,
                      a_index    VARCHAR2,
                      a_region   VARCHAR2);

  /**
  * Список судов
  */
  FUNCTION LST#COURT
    RETURN sys_refcursor;

  /**
  * Удаление данных суда
  */
  PROCEDURE DEL#COURT(a_id INTEGER);

  /**
  * Ввод ФИО судьи
  * @param a_court_id integer идентификатор суда
  */
  FUNCTION INS#JUDGE(a_site_id     INTEGER,
                     a_first_name  VARCHAR2,
                     a_last_name   VARCHAR2,
                     a_middle_name VARCHAR2,
                     a_phone       VARCHAR2,
                     a_mail        VARCHAR2)
    RETURN NUMBER;


  FUNCTION UPD#JUDGE(a_id_judge    NUMBER,
                     a_site_id     INTEGER,
                     a_first_name  VARCHAR2,
                     a_last_name   VARCHAR2,
                     a_middle_name VARCHAR2,
                     a_phone       VARCHAR2,
                     a_mail        VARCHAR2)
    RETURN NUMBER;

  /**
  * Список судей
  */
  FUNCTION LST#JUDGE
    RETURN sys_refcursor;

  /**
  * Список судей
  */
  FUNCTION LST#JUDGE_COURT(a_court_id INTEGER)
    RETURN sys_refcursor;

  /**
  * Удаление ФИО судьи
  */
  PROCEDURE DEL#JUDGE(a_id INTEGER);

  /**
  * Тип документа ответчика
  * @param a_type varchar2 строка с типом документа
  */
  FUNCTION INS#TYPE_DOC(a_type VARCHAR2)
    RETURN NUMBER;

  /**
  * Список типов документа ответчика
  */
  FUNCTION LST#TYPE_DOC
    RETURN sys_refcursor;

  /**
  * Поиск типа документа ответчика
  */
  FUNCTION GET#TYPE_DOC(a_type VARCHAR2)
    RETURN NUMBER;

  /**
  * Тип иска
  * @param a_type varchar2 строка типа иска
  */
  PROCEDURE INS#TYPE_CLAIM(a_type VARCHAR2);

  /**
  * Список типов исков
  */
  FUNCTION LST#TYPE_CLAIM
    RETURN sys_refcursor;

  /**
  * Статусы иска
  * @param a_type varchar2 строка статуса
  */
  PROCEDURE INS#TYPE_STATUS_CLAIM(a_type VARCHAR2);

  /**
  * Типы состояний исков
  */
  FUNCTION LST#TYPE_STATUS_CLAIM
    RETURN sys_refcursor;

  /**
  * удаление типа ствтуса иска
  */
  PROCEDURE DEL#TYPE_STATUS_CLAIM(a_id INTEGER);

  /**
  * Статусы постановления
  * @param a_type varchar2 строка статуса
  */
  PROCEDURE INS#TYPE_STATUS_RESOLUTION(a_type VARCHAR2);

  /**
  * Типы состояний постановлений
  */
  FUNCTION LST#TYPE_STATUS_RESOLUTION
    RETURN sys_refcursor;

  /**
  * удаление типа ствтуса постановления
  */
  PROCEDURE DEL#TYPE_STATUS_RESOLUTION(a_id INTEGER);

  /**
  * Помещение ответчика
  * @param A_ID_DEF       numeric  идентификатор ответчика
  * @param A_ROOMS_ID     numeric  идентификатор помещения
  * @return number      идентификатор ответчика
  */
  FUNCTION INS#DEF_ROOMS(a_id_def   NUMBER,
                         A_ROOMS_ID NUMBER)
    RETURN NUMBER;

  /**
  * Документ ответчика
  * @param A_ID_DEF     numeric  идентификатор ответчика
  * @param A_ADDITIONAL varchar2 дополнительная информация к документу
  * @param A_COMMENT    varchar2 комментарий к документу
  * @param A_DATE       date     дата выдачи документа
  * @param A_GIVE       varchar2 кто выдал документ
  * @param A_NUMBER     varchar2 номер документа
  * @param A_SERIES     varchar2 серия 
  * @param T_TYPE_DOCC_ID integer идентификатор типа документа
  * @return number      идентификатор добавленной записи
  */
  FUNCTION INS#DOC_DEFENDANT(A_ID_DEF       NUMERIC,
                             A_ADDITIONAL   VARCHAR2,
                             A_COMMENT      VARCHAR2,
                             A_DATE         DATE,
                             A_GIVE         VARCHAR2,
                             A_NUMBER       VARCHAR2,
                             A_SERIES       VARCHAR2,
                             T_TYPE_DOCC_ID INTEGER)
    RETURN NUMBER;

  /**
  * Дополнительные данные ответчика
  * @param A_ID_DEF     numeric  идентификатор ответчика
  * @param C_BIRTHPLACE          varchar2 место рождения
  * @param C_DATE_BIRTH date     дата рождения
  * @param C_RESIDENCE           varchar2 адрес проживания
  * @return number               идентификатор добавленой записи
  */
  FUNCTION INS#DATA_DEFENDANT(A_ID_DEF     NUMERIC,
                              A_BIRTHPLACE VARCHAR2,
                              A_DATE_BIRTH DATE,
                              A_RESIDENCE  VARCHAR2)
    RETURN NUMBER;

  /**
  * Тип Ответчик
  * @param A_С_ID             number идентификатор ответчика 
  * @return                   number (1 -юр лицо , 0 - физ лицо, -1 не найден)
  */
  FUNCTION GET#TYPE_DEFENDANT(a_c_id NUMBER)
    RETURN NUMBER;

  /**
  * Ответчик
  * @param A_PERSON_ID        number идентификатор ответчика 
  * @param A_ROOMS_ID         number идентификатор помещения
  */
  FUNCTION INS#DEFENDANT(A_PERSON_ID NUMBER,
                         A_ROOMS_ID  NUMBER)
    RETURN NUMBER;

  /**
  * Шаблон иска
  */
  FUNCTION INS#TEMPLATE_CLAIM(a_path VARCHAR2)
    RETURN NUMBER;

  /**
  * Шаблон постановления
  */
  FUNCTION INS#TEMPLATE_RESOLUTION(a_path VARCHAR2)
    RETURN NUMBER;

  /**
  * Список постановлений
  * @param A_ID_CLAIM NUMBER ид иска
  */
  FUNCTION LST#RESOLUTION(a_id_claim NUMBER)
    RETURN sys_refcursor;

  /**
  * Постановление
  * @param A_DATE            date   дата постановления 
  * @param A_NUMBER          number номер постановления
  */
  FUNCTION INS#RESOLUTION(A_DATE   DATE,
                          A_NUMBER VARCHAR2)
    RETURN NUMBER;

  /**
  * Иск
  * @param A_COMMENT        varchar2 
  * @param A_DATE           date
  * @param A_NUMBER         number
  * @param A_SUMMA_CLAIM    float
  * @param A_SUMMA_DUTY     float
  * @param A_COURTC_ID      number
  * @param A_DEFENDANTC_ID  number
  * @param A_RESOLUTIONC_ID number
  * @param A_TEMPLATEC_ID   number
  * @param A_TYPE_CLAIMC_ID number
  */
  FUNCTION INS#CLAIM(A_COMMENT        VARCHAR2,
                     A_DATE           DATE,
                     A_PREFIX         VARCHAR2,
                     A_NUMBER         NUMBER,
                     A_SUMMA_CLAIM    FLOAT,
                     A_SUMMA_DUTY     FLOAT,
                     A_DEFENDANTC_ID  NUMBER,
                     A_TYPE_CLAIMC_ID NUMBER)
    RETURN NUMBER;

  /**
  * Редактирование иска
  */
  FUNCTION UPD#CLAIM(A_ID_CLAIM    NUMBER,
                     A_COMMENT     VARCHAR2,
                     A_DATE        DATE,
                     A_PREFIX      VARCHAR2,
                     A_NUMBER      NUMBER,
                     A_SUMMA_CLAIM FLOAT,
                     A_SUMMA_DUTY  FLOAT)
    RETURN NUMBER;

  /**
  * Связь иска с судом
  */
  FUNCTION INS#JUDGE_CLAIM(A_ID_CLAIM NUMBER,
                           A_ID_JUDGE NUMBER)
    RETURN NUMBER;

  /**
  * Связь иска с постановлением
  */
  FUNCTION INS#RESOLUTION_CLAIM(A_ID_CLAIM       NUMBER,
                                A_RESOLUTIONC_ID NUMBER)
    RETURN NUMBER;

  /**
  * Связь иска с шаблоном
  */
  FUNCTION INS#TCLAIM(A_ID_CLAIM NUMBER,
                      A_TC_ID    NUMBER)
    RETURN NUMBER;

  /**
  * Связь постановления с шаблоном
  */
  FUNCTION INS#TRESOLUTION(A_ID_RES NUMBER,
                           A_ID_TR  NUMBER)
    RETURN NUMBER;

  /**
  * Связь иска с истцом
  */
  FUNCTION INS#DCLAIM(A_ID_CLAIM NUMBER,
                      A_ID_DEF   NUMBER)
    RETURN NUMBER;


  /**
  * Список исков постановления.
  */
  FUNCTION LST#CLAIM
    RETURN sys_refcursor;

  /**
  * Статус иска
  * @param A_CLAIMC_ID   number идентификатор иска
  * @param A_TSTATUSC_ID number идентификатор типа статуса
  */
  FUNCTION INS#STATUS_CLAIM(A_CLAIMC_ID   NUMBER,
                            A_TSTATUSC_ID NUMBER,
                            a_date        DATE)
    RETURN NUMBER;

  /**
  * История статусов иска
  * @param A_ID_CLAIM   number идентификатор иска
  */
  FUNCTION LST#STATUS_CLAIM(a_id_claim NUMBER)
    RETURN sys_refcursor;

  /**
  * Текущий статус иска
  * @param A_ID_CLAIM   number идентификатор иска
  */
  FUNCTION LST#CURRENT_STATUS_CLAIM(a_id_claim NUMBER)
    RETURN sys_refcursor;

  /**
  * Статус постановления.
  */
  FUNCTION INS#STATUS_RESOLUTION(a_r_id    NUMBER,
                                 a_type_id NUMBER,
                                 a_date    DATE)
    RETURN NUMBER;

  /**
  * Список шаблонов исков
  */
  FUNCTION LST#TEMPLATE_CLAIM
    RETURN sys_refcursor;

  /**
  * Список шаблонов постановлений
  */
  FUNCTION LST#TEMPLATE_RESOLUTION
    RETURN sys_refcursor;

  /**
  * Список ответчиков
  */
  FUNCTION LST#DEFENDANT
    RETURN sys_refcursor;

  /**
  * Очередной номер иска для заданного префикса
  */
  FUNCTION GET#NUMBER_CLAIM(a_prefix VARCHAR2)
    RETURN NUMBER;

  /**
  *  Ответчик по иду
  */
  FUNCTION GET#DEFENDANT_PERSON(a_person_id NUMBER)
    RETURN NUMBER;


  FUNCTION GET#DEFENDANT(a_person_id NUMBER, a_rooms_id NUMBER)
    RETURN NUMBER;


  /**
  *  Ответчик по квартире
  */
  FUNCTION GET#DEFENDANT_ROOM(a_rooms_id NUMBER)
    RETURN NUMBER;

  /**
  *  Удаление иска
  */
  PROCEDURE DEL#CLAIM(a_id_claim NUMBER);

  /**
  * Участок
  */
  FUNCTION INS#SITE(a_court_id INTEGER,
                    a_site     VARCHAR2)
    RETURN NUMBER;
  FUNCTION UPD#SITE(a_id_site INTEGER,
                    a_site    VARCHAR2)
    RETURN NUMBER;
  FUNCTION LST#SITE
    RETURN sys_refcursor;
END P#CLAIM;

/
