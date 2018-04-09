--------------------------------------------------------
--  DDL for Package P#REPORTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#REPORTS" 
  IS
  /** Author  : ALEXANDER
  * Created : 11.10.2016 10:22:38
  */

  /**
  * +�������������� ���������� ��� �����
  */

  /**
  * ����� 1
  * @param a#date_begin ���� ������ �������
  * @param a#date_end ���� ��������� �������
  */
  FUNCTION LST#REP_FOR_SITE_1(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor;

  /**
  * ����� 2
  * @param a#date_begin ���� ������ �������
  * @param a#date_end ���� ��������� �������
  */
  FUNCTION LST#REP_FOR_SITE_2(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor;

  /**
  * ����� 4
  * @param a#date_begin ���� ������ �������
  * @param a#date_end ���� ��������� �������
  */
  FUNCTION LST#REP_FOR_SITE_4(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor;

  /**
  * -�������������� ���������� ��� �����
  */

  FUNCTION LST#PAY_NOT_J(a#person_id INTEGER)
    RETURN sys_refcursor;

  FUNCTION LST#AKT_F_OLD(a#num    VARCHAR2,
                         a#dbegin VARCHAR2,
                         a#dend   VARCHAR2)
    RETURN sys_refcursor;
  FUNCTION LST#AKT_F(a#num    VARCHAR2,
                     a#dbegin VARCHAR2,
                     a#dend   VARCHAR2)
    RETURN sys_refcursor;

  FUNCTION LST#TARIF
    RETURN sys_refcursor;

  PROCEDURE LST#PAYCODEOPS(a#person_id     INTEGER,
                           res         OUT sys_refcursor);

  FUNCTION LST#HOUSE_INFO
    RETURN sys_refcursor;

  /** 
	* �������� �� ����
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_OBOROT_HOUSE(a#date_begin VARCHAR2,
                                a#date_end   VARCHAR2)
    RETURN sys_refcursor;

  /** 
	* ���������, �������, ���� � ������� ����- ����.���� � ������������ �� ������������� ������������
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_ACCOUNT_SPECIAL(a#date_begin DATE,
                                   a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* ���������, �������, ���� � ������� ������������� (�����������, ������������� � �.�.) �� �������
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_PROPERTLY_OMSU(a#date_begin DATE,
                                  a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* ���������, �������, ���� � ������� ������������� (�����������, ������������� � �.�.)
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_PROPERTLY(a#date_begin DATE,
                             a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* ���������, �������, ���� � ������� ����- ����.���� 
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_TYPE_ACCOUNT(a#date_begin DATE,
                                a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* ���������, �������, ���� � ������� ���
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_RKC(a#date_begin DATE,
                       a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* ���������, �������, ���� � ������� ����� ��������� � ������� � ������������ �� ������������� ������������
	* @param a#date_begin ���� ������ �������
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� �������� �� ������
	*/
  FUNCTION LST#REP_LIVING_ROOMS(a#date_begin DATE,
                                a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* ������ ��. ���� � ������� ��������
	* @param a#person_id ������������� ��. ����
	* @return ������ � ����������� �� �������
	*/
  FUNCTION LST#PAY_CODE_OPS(a#person_id INTEGER)
    RETURN sys_refcursor;

  /** 
	* ���
	* @param a#person_id ������������� ��. ����	
	* @param a#date_begin ���� ������ �������	
	* @param a#date_end ���� ��������� �������
	* @return ������ � ����������� �� ������� � �����������
	*/
  FUNCTION LST#AKT(a#person_id INTEGER,
                   a#dbegin    VARCHAR2,
                   a#dend      VARCHAR2)
    RETURN sys_refcursor;

  /** 
	* ������ ���������� � ����� ��. ���� 
	* @param a#person_id ������������� ��. ����
	* @return ������ � ����������� �� �������
	*/
  FUNCTION LST#REESTR(  a#person_id  INTEGER, 
                        a#date_begin VARCHAR2 default null,
                        a#date_end   VARCHAR2 default null)
    RETURN sys_refcursor;


  PROCEDURE LST#REESTR2(a#person_id  INTEGER);



  FUNCTION LST#REESTR_OLD(  a#person_id  INTEGER) RETURN sys_refcursor;

  /** 
	* ������ ���������� 
	* @param a#person_id ������������� ��. ����	
	* @param a#mn_begin ���� ������ �������	
	* @param a#mn_end ���� ��������� �������
	* @return ������ � ����������� �� �����������
	*/
  FUNCTION LST#REESTR_NO_PAY(a#person_id INT,
                             a#mn_begin  INT,
                             a#mn_end    INT)
    RETURN sys_refcursor;


-- ����� ��� ��� ���������� 6 
  FUNCTION LST#GGI_PRIL6(p_YEAR VARCHAR2) RETURN sys_refcursor;



END P#REPORTS;

/
