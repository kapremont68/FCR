--------------------------------------------------------
--  DDL for Package P#UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#UTILS" 
  IS

  -- �����
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

  -- ��� �������
  FUNCTION GET#PERSON_NAME(A#P_ID NUMBER)
    RETURN VARCHAR2;
  -- ��� �������
  FUNCTION GET#TYPE_PERSON(A#P_ID NUMBER)
    RETURN VARCHAR2;

  -- ���. � ���������
  FUNCTION GET_OBJ#ROOMS(A#R_ID NUMBER,
                         A#DATE DATE)
    RETURN TOBJ#I_ROOMS;
  FUNCTION GET_OBJ#ROOMS(A#R_ID NUMBER,
                         A#MN   NUMBER)
    RETURN TOBJ#I_ROOMS;
  -- ���. � �������
  FUNCTION GET_OBJ#ACCOUNT(A#A_ID NUMBER,
                           A#DATE DATE)
    RETURN TOBJ#I_ACCOUNT;
  FUNCTION GET_OBJ#ACCOUNT(A#A_ID NUMBER,
                           A#MN   NUMBER)
    RETURN TOBJ#I_ACCOUNT;
  -- ���. � ��������� ��� �������
  FUNCTION GET_OBJ#POSTAMT(A#CODE VARCHAR2)
    RETURN TOBJ#I_POSTAMT;
  -- ���. � ��������� ��� ����
  FUNCTION GET_OBJ#HOUSE_POSTAMT(A#H_ID NUMBER)
    RETURN TOBJ#I_POSTAMT;

  -- �������� ������
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
  *  ����������� ����� ��� ����� �� ����
  *  @param a_account_id integer ������������� �����
  *  @param a_date date ���� ����������� ������ 
  *  @return �������� ������ 
  */
  FUNCTION GET#TARIF(a_account_id INTEGER,
                     a_date       DATE)
    RETURN NUMBER;
  /**
  *  ���� ��� ��������� �� ��������� �� ����
  *  @param a#person_id integer ������������� ���������
  *  @param a#rooms_id  integer ������������� ���������
  *  @param a#date_end  date ���� ����������� ����� 
  *  @return ����� ����� � ������ �������� ��������� �� ����
  */
  FUNCTION GET#DOLG(a#person_id INTEGER,
                    a#rooms_id  INTEGER,
                    a#date_end  DATE)
    RETURN NUMBER;

  /**
  *  ���������� ������� ������ � ������ ���� ��������� ������
  *  @param a_summa number ����� ������
  *  @return number ���������� ������� ������
  */
  FUNCTION GET#COUNT_DOLG(a_summa NUMBER)
    RETURN NUMBER;

  /**
  *  ���������������� ������� ��� ������������ ����
  *  @param a#person_id integer ������������� �� ����
  *  @return ����� ����������������� �������
  */
  FUNCTION GET#OSTATOK_J(a#person_id INTEGER)
    RETURN NUMBER;

END;

/
