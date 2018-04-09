--------------------------------------------------------
--  DDL for Package P3UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P3UTILS" AS 

-- ������ � �������� ���� ����� �� ���� 
  FUNCTION get_jobs_txt(p_HOUSE_ID NUMBER DEFAULT NULL, p_DATE_BEG DATE, p_DATE_END DATE) RETURN NVARCHAR2;

-- ����� ���� �������� �� ������
  FUNCTION get_job_summa(p_JOB_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- ����� ���� �������� �� ����
  FUNCTION get_house_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- �������� ����� ���� ����� �� ����
  FUNCTION get_house_plan_summa(p_HOUSE_ID NUMBER DEFAULT NULL) RETURN NUMBER;

-- ���������, ��������, ���������, ����, ������� �� ���� �� �������
  FUNCTION LST#HOUSE_BALANCE(p_HOUSE_ID NUMBER) RETURN sys_refcursor;

-- ������� � ������� �� ����� �� ������, ����������� (��� �� ���������, �����������) � �������� ��������� ���
  FUNCTION LST#HOUSES_PAYS(p_DATE_BEG DATE, p_DATE_END DATE) RETURN sys_refcursor;
  
-- �������� �������������� �� 1� �������
  PROCEDURE DO#IMPORT;

END P3UTILS;

/
