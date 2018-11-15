--------------------------------------------------------
--  DDL for Package P#WEB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#WEB" AS 

-- ���������� ����� �������� (� ����������� ������) ��� ��������� ���� � ����(����� ������)
 FUNCTION GET#SUM_FOR_HOUSE_DATE(a#house_id NUMBER, a#date DATE) RETURN NUMBER;

-- ���������� ���� ��� ��������� ���� � �������
-- FUNCTION GET#PENI_FOR_HOUSE_PERIOD(a#house_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ���� ��� ��������� ����� � �������
-- FUNCTION GET#PENI_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ���������� ��� ��������� ����� �� ������
 FUNCTION GET#CHARGE_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ������� ��� ��������� ����� �� ������
 FUNCTION GET#PAY_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ������� ����
 FUNCTION GET#DOLG(a#acc_id NUMBER) RETURN NUMBER;
 
-- ���������� ���������� ��� ��������� ����� � ������ �� �������� (�������) �����
 FUNCTION GET#CHARGE_FOR_DOLG(a#acc_id NUMBER) RETURN NUMBER;
 

END P#WEB;

/
