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
  * ����� , ������� ������ ������ ��������� �����.
  * @param  a_summa number  ����� �����
  * @result         number  ������ ������
  */
  FUNCTION LST#ACCOUNT_DOLG(a_summa NUMBER)
    RETURN sys_refcursor;

  /**
  * ���� ������ ����
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
  * ������ �����
  */
  FUNCTION LST#COURT
    RETURN sys_refcursor;

  /**
  * �������� ������ ����
  */
  PROCEDURE DEL#COURT(a_id INTEGER);

  /**
  * ���� ��� �����
  * @param a_court_id integer ������������� ����
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
  * ������ �����
  */
  FUNCTION LST#JUDGE
    RETURN sys_refcursor;

  /**
  * ������ �����
  */
  FUNCTION LST#JUDGE_COURT(a_court_id INTEGER)
    RETURN sys_refcursor;

  /**
  * �������� ��� �����
  */
  PROCEDURE DEL#JUDGE(a_id INTEGER);

  /**
  * ��� ��������� ���������
  * @param a_type varchar2 ������ � ����� ���������
  */
  FUNCTION INS#TYPE_DOC(a_type VARCHAR2)
    RETURN NUMBER;

  /**
  * ������ ����� ��������� ���������
  */
  FUNCTION LST#TYPE_DOC
    RETURN sys_refcursor;

  /**
  * ����� ���� ��������� ���������
  */
  FUNCTION GET#TYPE_DOC(a_type VARCHAR2)
    RETURN NUMBER;

  /**
  * ��� ����
  * @param a_type varchar2 ������ ���� ����
  */
  PROCEDURE INS#TYPE_CLAIM(a_type VARCHAR2);

  /**
  * ������ ����� �����
  */
  FUNCTION LST#TYPE_CLAIM
    RETURN sys_refcursor;

  /**
  * ������� ����
  * @param a_type varchar2 ������ �������
  */
  PROCEDURE INS#TYPE_STATUS_CLAIM(a_type VARCHAR2);

  /**
  * ���� ��������� �����
  */
  FUNCTION LST#TYPE_STATUS_CLAIM
    RETURN sys_refcursor;

  /**
  * �������� ���� ������� ����
  */
  PROCEDURE DEL#TYPE_STATUS_CLAIM(a_id INTEGER);

  /**
  * ������� �������������
  * @param a_type varchar2 ������ �������
  */
  PROCEDURE INS#TYPE_STATUS_RESOLUTION(a_type VARCHAR2);

  /**
  * ���� ��������� �������������
  */
  FUNCTION LST#TYPE_STATUS_RESOLUTION
    RETURN sys_refcursor;

  /**
  * �������� ���� ������� �������������
  */
  PROCEDURE DEL#TYPE_STATUS_RESOLUTION(a_id INTEGER);

  /**
  * ��������� ���������
  * @param A_ID_DEF       numeric  ������������� ���������
  * @param A_ROOMS_ID     numeric  ������������� ���������
  * @return number      ������������� ���������
  */
  FUNCTION INS#DEF_ROOMS(a_id_def   NUMBER,
                         A_ROOMS_ID NUMBER)
    RETURN NUMBER;

  /**
  * �������� ���������
  * @param A_ID_DEF     numeric  ������������� ���������
  * @param A_ADDITIONAL varchar2 �������������� ���������� � ���������
  * @param A_COMMENT    varchar2 ����������� � ���������
  * @param A_DATE       date     ���� ������ ���������
  * @param A_GIVE       varchar2 ��� ����� ��������
  * @param A_NUMBER     varchar2 ����� ���������
  * @param A_SERIES     varchar2 ����� 
  * @param T_TYPE_DOCC_ID integer ������������� ���� ���������
  * @return number      ������������� ����������� ������
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
  * �������������� ������ ���������
  * @param A_ID_DEF     numeric  ������������� ���������
  * @param C_BIRTHPLACE          varchar2 ����� ��������
  * @param C_DATE_BIRTH date     ���� ��������
  * @param C_RESIDENCE           varchar2 ����� ����������
  * @return number               ������������� ���������� ������
  */
  FUNCTION INS#DATA_DEFENDANT(A_ID_DEF     NUMERIC,
                              A_BIRTHPLACE VARCHAR2,
                              A_DATE_BIRTH DATE,
                              A_RESIDENCE  VARCHAR2)
    RETURN NUMBER;

  /**
  * ��� ��������
  * @param A_�_ID             number ������������� ��������� 
  * @return                   number (1 -�� ���� , 0 - ��� ����, -1 �� ������)
  */
  FUNCTION GET#TYPE_DEFENDANT(a_c_id NUMBER)
    RETURN NUMBER;

  /**
  * ��������
  * @param A_PERSON_ID        number ������������� ��������� 
  * @param A_ROOMS_ID         number ������������� ���������
  */
  FUNCTION INS#DEFENDANT(A_PERSON_ID NUMBER,
                         A_ROOMS_ID  NUMBER)
    RETURN NUMBER;

  /**
  * ������ ����
  */
  FUNCTION INS#TEMPLATE_CLAIM(a_path VARCHAR2)
    RETURN NUMBER;

  /**
  * ������ �������������
  */
  FUNCTION INS#TEMPLATE_RESOLUTION(a_path VARCHAR2)
    RETURN NUMBER;

  /**
  * ������ �������������
  * @param A_ID_CLAIM NUMBER �� ����
  */
  FUNCTION LST#RESOLUTION(a_id_claim NUMBER)
    RETURN sys_refcursor;

  /**
  * �������������
  * @param A_DATE            date   ���� ������������� 
  * @param A_NUMBER          number ����� �������������
  */
  FUNCTION INS#RESOLUTION(A_DATE   DATE,
                          A_NUMBER VARCHAR2)
    RETURN NUMBER;

  /**
  * ���
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
  * �������������� ����
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
  * ����� ���� � �����
  */
  FUNCTION INS#JUDGE_CLAIM(A_ID_CLAIM NUMBER,
                           A_ID_JUDGE NUMBER)
    RETURN NUMBER;

  /**
  * ����� ���� � ��������������
  */
  FUNCTION INS#RESOLUTION_CLAIM(A_ID_CLAIM       NUMBER,
                                A_RESOLUTIONC_ID NUMBER)
    RETURN NUMBER;

  /**
  * ����� ���� � ��������
  */
  FUNCTION INS#TCLAIM(A_ID_CLAIM NUMBER,
                      A_TC_ID    NUMBER)
    RETURN NUMBER;

  /**
  * ����� ������������� � ��������
  */
  FUNCTION INS#TRESOLUTION(A_ID_RES NUMBER,
                           A_ID_TR  NUMBER)
    RETURN NUMBER;

  /**
  * ����� ���� � ������
  */
  FUNCTION INS#DCLAIM(A_ID_CLAIM NUMBER,
                      A_ID_DEF   NUMBER)
    RETURN NUMBER;


  /**
  * ������ ����� �������������.
  */
  FUNCTION LST#CLAIM
    RETURN sys_refcursor;

  /**
  * ������ ����
  * @param A_CLAIMC_ID   number ������������� ����
  * @param A_TSTATUSC_ID number ������������� ���� �������
  */
  FUNCTION INS#STATUS_CLAIM(A_CLAIMC_ID   NUMBER,
                            A_TSTATUSC_ID NUMBER,
                            a_date        DATE)
    RETURN NUMBER;

  /**
  * ������� �������� ����
  * @param A_ID_CLAIM   number ������������� ����
  */
  FUNCTION LST#STATUS_CLAIM(a_id_claim NUMBER)
    RETURN sys_refcursor;

  /**
  * ������� ������ ����
  * @param A_ID_CLAIM   number ������������� ����
  */
  FUNCTION LST#CURRENT_STATUS_CLAIM(a_id_claim NUMBER)
    RETURN sys_refcursor;

  /**
  * ������ �������������.
  */
  FUNCTION INS#STATUS_RESOLUTION(a_r_id    NUMBER,
                                 a_type_id NUMBER,
                                 a_date    DATE)
    RETURN NUMBER;

  /**
  * ������ �������� �����
  */
  FUNCTION LST#TEMPLATE_CLAIM
    RETURN sys_refcursor;

  /**
  * ������ �������� �������������
  */
  FUNCTION LST#TEMPLATE_RESOLUTION
    RETURN sys_refcursor;

  /**
  * ������ ����������
  */
  FUNCTION LST#DEFENDANT
    RETURN sys_refcursor;

  /**
  * ��������� ����� ���� ��� ��������� ��������
  */
  FUNCTION GET#NUMBER_CLAIM(a_prefix VARCHAR2)
    RETURN NUMBER;

  /**
  *  �������� �� ���
  */
  FUNCTION GET#DEFENDANT_PERSON(a_person_id NUMBER)
    RETURN NUMBER;


  FUNCTION GET#DEFENDANT(a_person_id NUMBER, a_rooms_id NUMBER)
    RETURN NUMBER;


  /**
  *  �������� �� ��������
  */
  FUNCTION GET#DEFENDANT_ROOM(a_rooms_id NUMBER)
    RETURN NUMBER;

  /**
  *  �������� ����
  */
  PROCEDURE DEL#CLAIM(a_id_claim NUMBER);

  /**
  * �������
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
