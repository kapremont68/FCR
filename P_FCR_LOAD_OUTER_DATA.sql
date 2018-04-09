--------------------------------------------------------
--  DDL for Package P#FCR_LOAD_OUTER_DATA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FCR_LOAD_OUTER_DATA" 
  AS
  /** Author  : ALEXANDER
  * Created : 02-2016 
  */

  a#err VARCHAR2(4000);

  /** 
  * ���������� ������� ������� ����� ����������� ���
  */
  PROCEDURE INS#MASS_PAY(A#PERSON_ID  INTEGER,
                         A#DATE       DATE,
                         A#SUM        NUMBER,
                         A#LIVING_TAG VARCHAR2,
                         A#NPD        VARCHAR2,
                         A#COD_RKC    VARCHAR2,
                         A#COMMENT    VARCHAR2);

  /** 
  * ������������� ����� ����������� ��� 
  * Author  :  ALEXANDER 
  */
  PROCEDURE Filling_these_municipalities;



  /** 
  * ���������� ������� ������� ����� ���������� ����������
  * Author  : �������� ������� ( ����������� ALEXANDER )
  */
  PROCEDURE INS#KOTEL_OTHER_PRIH(A#PL_SUM  IN NUMBER,
                                 A#PL_DATE IN DATE,
                                 A#COMM       VARCHAR2);

  /** 
  * ���������� ������� ������� ����� ���������� ����������
  * Author  : �������� ������� ( ����������� ALEXANDER )
  */
  PROCEDURE INS#SPEC_PRIHOD(A#ID_HOUSE IN NUMBER,
                            A#DT_PAY   IN DATE,
                            A#PAY      IN NUMBER,
                            A#COMMENT     VARCHAR2);



  /** 
  * �������� ����� � ������������� �� ������ ���������� ��� 
  * Author  :  ALEXANDER 
  * @param a#in_file_id ������������� ����� � ����������� ������������
  * @param a#in_date ���� �������������
  */
  PROCEDURE ExecAllFunction(a#in_file_id NUMBER,
                            a#in_date    DATE);


  PROCEDURE ExecAllFunctionCycle;


--function Distr_Data_Active_Account(a#in_file_id number, a#in_date date)return number;
--function Distr_Data_Not_Active_Account(a#in_file_id number, a#in_date date)  return number;
--function Distr_Data_Bank_Account(a#in_file_id number, a#in_date date)  return number;

END P#FCR_LOAD_OUTER_DATA;

/
