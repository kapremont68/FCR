--------------------------------------------------------
--  DDL for View V_KR13
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_KR13" ("COL1", "COL2", "COL3", "COL4", "COL5", "COL6", "COL7", "COL8", "COL9", "COL10", "COL11", "COL12", "COL13", "COL14", "COL15", "COL16", "COL17", "COL18", "COL19", "COL20", "COL21", "COL22", "COL23") AS 
  WITH
    jobs as (
        select
            J.HOUSE_ID HOUSE_ID,
            j.job_type_id job_type_id,
            J.REG_JOB_TYPE_NAME,
            J.JOB_ELEM_CODE ELEM_CODE,
            P.C#YEAR_END YEAR_END,
            J.JOB_DATE_END,
            J.CONTRACT_DATE,
            J.CONTRACTOR_NAME,
            J.CONTRACTOR_INN,
            J.JOB_SUM
        from
            V3_JOBS J
            left join T3_JOBS_PLAN P on (J.HOUSE_ID = P.C#HOUSE_ID and P.c#reg_job_type_id = J.reg_job_type_id)
    )
    ,houses as (
        select
            h.C#ID HOUSE_ID,
            h.C#FIAS_GUID FIAS_GUID,
            ADDR, -- REPLACE(ADDR,regexp_substr(ADDR, '[^,]+')||', ','')
            i.c#gov_name gov_name,
            PJ.C#INN_NUM gov_inn,
            OKTMO.C#CODE OKTMO_CODE
        from
            t#HOUSE h
            join T#HOUSE_INFO i on (i.c#house_id = h.c#id)
            join MV_HOUSES_ADRESES A on (h.c#id = A.house_id)
            left join T#PERSON_J PJ on (LOWER(TRIM(i.c#gov_name)) like LOWER(TRIM(PJ.C#NAME))||'%')
            left join T3_OKTMO OKTMO on (OKTMO.c#name = regexp_substr(ADDR, '[^,]+'))
    )
    ,alls as (
        select distinct
            '���������� �������' col1,	-- ������� ���������� ���������
            OKTMO_CODE col2, -- ��� ����� �������������� ������
            regexp_substr(h.ADDR, '[^,]+') col3,  -- ������������ �������������� ������
            h.HOUSE_ID col4, -- ��� ���
            h.ADDR col5, -- ����� ���������������� ����
            ELEM_CODE col6, -- ��� ��������������� �������� (�������)
            j.job_type_id col7, -- ��� ������ (������)
            j.reg_job_type_name col8, -- ��� ������ (������) �� ������������ ������� � ������������ � ������� �������� ���������� ���������
            j.YEAR_END col9, -- ��� ���������� ������ (������), � ������������ � ������������ ���������� ������������ ������� ������ ��������� � ��������������� ����� ��� ������������� ������ �� ����������
            '' col10, -- ��������� ������ (������)  � ������������ � ������������ ������ (�������)
            '' col11, -- ��������� ������ (������) � ������������ � ������������ ����������
            JOB_SUM col12, -- ��������� ������ (������) ������� �� �����
            '�����' col13, -- ������� ���������
            JOB_SUM col14, -- ����� ����� (�����) �� ������������ ������� � ������������ � ��������� ���������
            replace(replace(gov_name,chr(10),''),chr(13),'') col15, -- �������� ������ (������) �� ������������ ������� ������������
            gov_inn col16, -- �������� ������ (������) �� ������������ ������� ���
            CONTRACTOR_NAME col17, -- ����������� ������ (������) �� ������������ ������� ������������
            CONTRACTOR_INN col18, -- ����������� ������ (������) �� ������������ ������� ���
            TO_CHAR(CONTRACT_DATE,'dd.mm.yyyy') col19, -- ���� ���������� �������� �������
            TO_CHAR(JOB_DATE_END,'dd.mm.yyyy') col20, -- �������� ���� ���������� ����� (�����) �� �������� �������
            '' col21, -- ���� ���������� ���� �������
            '' col22, -- ����������
            TO_CHAR(sysdate,'dd.mm.yyyy') col23 -- ���� ������������ ����������
        from
            houses h
            join jobs j on (h.HOUSE_ID = j.HOUSE_ID)
      )
    ,plan as (
        select distinct
            '���������� �������' col1,	-- ������� ���������� ���������
            OKTMO_CODE col2, -- ��� ����� �������������� ������
            regexp_substr(h.ADDR, '[^,]+') col3,  -- ������������ �������������� ������
            h.HOUSE_ID col4, -- ��� ���
            h.ADDR col5, -- ����� ���������������� ����
            ELEM_CODE col6, -- ��� ��������������� �������� (�������)
            j.job_type_id col7, -- ��� ������ (������)
            j.JOB_TYPE_NAME col8, -- ��� ������ (������) �� ������������ ������� � ������������ � ������� �������� ���������� ���������
            j.YEAR_END col9, -- ��� ���������� ������ (������), � ������������ � ������������ ���������� ������������ ������� ������ ��������� � ��������������� ����� ��� ������������� ������ �� ����������
            null col10, -- ��������� ������ (������)  � ������������ � ������������ ������ (�������)
            null col11, -- ��������� ������ (������) � ������������ � ������������ ����������
            null col12, -- ��������� ������ (������) ������� �� �����
            null col13, -- ������� ���������
            null col14, -- ����� ����� (�����) �� ������������ ������� � ������������ � ��������� ���������
            null col15, -- �������� ������ (������) �� ������������ ������� ������������
            null col16, -- �������� ������ (������) �� ������������ ������� ���
            null col17, -- ����������� ������ (������) �� ������������ ������� ������������
            null col18, -- ����������� ������ (������) �� ������������ ������� ���
            null col19, -- ���� ���������� �������� �������
            null col20, -- �������� ���� ���������� ����� (�����) �� �������� �������
            null col21, -- ���� ���������� ���� �������
            null col22, -- ����������
            TO_CHAR(sysdate,'dd.mm.yyyy') col23 -- ���� ������������ ����������
        from
            houses h
            join V3_JOBS_PLAN_KR j on (h.HOUSE_ID = j.HOUSE_ID)
      )
SELECT "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22","COL23" FROM alls
union all
SELECT "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22","COL23" FROM plan
;
