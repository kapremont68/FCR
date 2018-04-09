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
  * ������ �� ����� ��������
  */
  FUNCTION GET#PAYMENT_HOUSE(a#house_id NUMBER,
                             a#acc_type NUMBER)
    RETURN sys_refcursor;

  /**
  * ����������  ������� ��������� ����������
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
	* ���� �� ���������� ����
	* @param a#house_id ������������� ����
	* @return ������ � ����������� �� �����
	*/
  FUNCTION LST#DOLG(a#house_id INTEGER)
    RETURN sys_refcursor;

  /** 
	* ��� ������ ����
	* @param a#house_id ������������� ����
	* @return ������ � ����������� �� ���� ������� ����������� � ���� 
	*/
  FUNCTION LST#SHOW_TARIFF(a#house_id INTEGER)
    RETURN sys_refcursor;

  /** 
	* �������������� ���� �� ����
	* @param a#house_id ������������� ����
	* @param a#date_month ����� ���� � ������ �����
	* @return �������������� ����� �����
	*/
  FUNCTION GET#HOUSE_MONTH_SUM(a#house_id   INTEGER,
                               a#date_month DATE)
    RETURN NUMBER;

  /** 
	* ��������� ������� ��������� � ����
	* @param a#house_id ������������� ����
	* @return ��������� ������� ��������� � ����
	*/
  FUNCTION GET#HOUSE_AREA(a#house_id INTEGER)
    RETURN NUMBER;

  /** 
	* ����� ����������� � ���� � ��������� ������
	* @param a#house_id ������������� ����
	* @param a#date_month ����� ���� � ������ 
	* @return ����� ����������� � ���� � ��������� ������
	*/
  FUNCTION GET#HOUSE_TAR(a#house_id   INTEGER,
                         a#date_month DATE)
    RETURN NUMBER;

  /** 
	* ���������� ���� �� ���������� ������
	* @param a#addrid ������������� ������
	* @param a#num ����� ����
  * @param a#bnum ������
  * @param a#snum �������������� ������
	* @param a#post �������� ������ ( ���������� �� ����������� )
  * @param a#fias ��� ���� ( ���������� �� ����������� )
	*/
  PROCEDURE INS#HOUSE(a#addrid NUMBER,
                      a#num    VARCHAR2,
                      a#bnum   VARCHAR2,
                      a#snum   VARCHAR2,
                      a#post   VARCHAR2,
                      a#fias   VARCHAR2);

  /** 
  * ���������� ���� �� ���������� ������
  * @param a#houseguid GUID ���� � ����������� ����
  */
  PROCEDURE INS#HOUSE_FROM_FIAS(a#houseguid VARCHAR2);

  /** 
	* �������� ��������� � ���� ��� ���������
	* @param a#house_id ������������� ����
	*/
  PROCEDURE DEL#HOUSE(a#house_id NUMBER);

  /** 
	* ���������� ������ ������ ��� ����
	* @param a#house_id ������������� ����
	* @param a#house_id ������������� ����
  * @param a#date_begin ���� ������ �������� ������
  * @param a#date_end   ���� ��������� �������� ������
  * @param a#new_tarif  �����
  * @param a#doer_id    ���
	*/
  PROCEDURE INS#TARIFF(a#house_id   NUMBER,
                       a#date_begin DATE,
                       a#date_end   DATE,
                       a#new_tarif  NUMBER,
                       a#doer_id    NUMBER);

  /** 
	* ��������� ������������� ������ ��� ����
	* @param a#house_id ������������� ����
  * @param a#works_id �����
  * @param a#r_doing  ���
  * @param a#date_begin ���� ������ �������� ������
  * @param a#date_end   ���� ��������� �������� ������
	*/
  PROCEDURE DO#TARIFF(a#house_id   NUMBER,
                      a#works_id   NUMBER,
                      a#r_doing    type_RecDoing,
                      a#date_begin DATE,
                      a#date_end   DATE);

  PROCEDURE DO#RECALC_CHARGE(a#house_id   NUMBER, -- ���
                             a#work_id    NUMBER, -- ����� �����
                             a#date_begin DATE, -- ���� ������ �������� ������
                             a#date_end   DATE -- ���� ��������� �������� ������
  );

END P#FCR_HOUSE;

/
