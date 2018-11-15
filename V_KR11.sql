--------------------------------------------------------
--  DDL for View V_KR11
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_KR11" ("COL1", "COL2", "COL3", "COL4", "COL5", "COL6", "COL7", "COL8", "COL9", "COL10", "COL11", "COL12", "COL13", "COL14", "COL15", "COL16", "COL17", "COL18", "COL19", "COL20", "COL21", "COL22", "COL23", "COL24", "COL25", "COL26", "COL27", "COL28", "COL29", "COL30", "COL31", "COL32", "COL33") AS 
  WITH
--    tar as (
--        select
--          C#HOUSE_ID HOUSE_ID,
--          C#TAR_VAL TAR_VAL
--        from
--          v#doing d
--          join v#work w on (d.C#WORKS_ID = w.C#WORKS_ID)
--        WHERE
--          w.C#DATE = (select max(c#date) from v#work w2 where w2.C#WORKS_ID = w.C#WORKS_ID)
--    )
    bal as (
        select
            *
        from
            T#TOTAL_HOUSE
        where
            MN = (select max(mn) from T#TOTAL_HOUSE where CHARGE_SUM_MN > 0)
    )
    ,bnk as (
      SELECT distinct
        tb.c#bic_num bic_num,
        vb.c#house_id house_id,
        tba.c#acc_type acc_type
      FROM
          fcr.t#bank tb
          INNER JOIN fcr.t#b_account tba  ON (tb.c#id = tba.c#bank_id)
          INNER JOIN fcr.v#banking vb  ON (vb.c#b_account_id = tba.c#id)
    )
    ,rooms as (
        select
          C#HOUSE_ID HOUSE_ID,
          count(*) TOTAL_CNT,
          sum(CASE WHEN C#LIVING_TAG = 'Y' THEN 1 ELSE 0 END) LIV_CNT,
          sum(CASE WHEN C#LIVING_TAG = 'Y' THEN 0 ELSE 1 END) NOT_LIV_CNT,
          sum(C#AREA_VAL) TOTAl_AREA,
          sum(CASE WHEN C#LIVING_TAG = 'Y' THEN C#AREA_VAL ELSE 0 END) LIV_AREA,
          sum(CASE WHEN C#LIVING_TAG <> 'Y' THEN C#AREA_VAL ELSE 0 END) NOT_LIV_AREA
        from
          V#ROOMS_LAST
--        where
--          C#HOUSE_ID = 2361
        group BY
          C#HOUSE_ID
    )
    ,houses as (
        select
            h.C#ID HOUSE_ID,
            h.C#FIAS_GUID FIAS_GUID,
            ADDR, -- REPLACE(ADDR,regexp_substr(ADDR, '[^,]+')||', ','')
            i.C#CREATE_YEAR CREATE_YEAR,
            c#area_val HOUSE_AREA,
            i.C#VOTE_DATE VOTE_DATE,
            i.C#2ND_DATE START_DATE,
            i.C#END_DATE END_DATE,
            OKTMO.C#CODE OKTMO_CODE
        from
            t#HOUSE h
            join T#HOUSE_INFO i on (i.c#house_id = h.c#id)
            join MV_HOUSES_ADRESES A on (h.c#id = A.house_id)
            left join T3_OKTMO OKTMO on (OKTMO.c#name = regexp_substr(ADDR, '[^,]+'))
    )
    ,alls as (
--        select
--            'subject_rf' col1,
--            'mun_obr_oktmo' col2,
--            'mun_obr' col3,
--            'mkd_code' col4,
--            'houseguid' col5,
--            'address' col6,
--            'commission_year' col7,
--            'architectural_monument_status' col8,
--            'total_sq' col9,
--            'total_rooms_amount' col10,
--            'living_rooms_amount' col11,
--            'living_rooms_with_nonresidental_amount' col12,
--            'total_rooms_sq' col13,
--            'living_rooms_sq' col14,
--            'living_rooms_with_nonresidental_sq' col15,
--            'total_ppl' col16,
--            'money_collecting_way_id' col17,
--            'money_collecting_way_date_decision' col18,
--            'bank_bik' col19,
--            'money_ppl_collected' col20,
--            'money_ppl_collected_debts' col21,
--            'overhaul_funds_spent_all' col22,
--            'overhaul_funds_spent_subsidy' col23,
--            'overhaul_funds_balance' col24,
--            'update_date_of_information' col25,
--            'money_ppl_collected_date' col26,
--            'owners_payment' col27,
--            'energy_efficiency_id' col28,
--            'previous_energy_efficiency_id' col29,
--            'energy_audit_date' col30,
--            'is_change_energy_efficiency' col31,
--            'exclude_date_from_program' col32,
--            'comment' col33
--        from
--            dual
--        union
        select
            '���������� �������' col1,	-- ������� ���������� ���������
            OKTMO_CODE col2, -- ��� ����� �������������� ������
            regexp_substr(h.ADDR, '[^,]+') col3,  -- ������������ �������������� ������
            h.HOUSE_ID col4, -- ��� ���
            FIAS_GUID col5, -- ��� ���� �� ����

    --        REPLACE(ADDR,regexp_substr(ADDR, '[^,]+')||', ','') address, -- 6 ����� ���
            h.ADDR col6, -- ����� ���

            CREATE_YEAR col7, -- ��� ����� � ������������ ���
            '' col8, -- ������ ��������� �����������
            GREATEST(HOUSE_AREA,TOTAl_AREA) col9, -- ����� ������� ���
            TOTAL_CNT col10, --  ���������� ��������� ���:	�����
            LIV_CNT col11, -- ���������� ��������� ���: � ��� ����� �����
            NOT_LIV_CNT col12, -- ���������� ��������� ���: � ��� ����� ������� living_rooms_with_nonresidental_amount
            TOTAl_AREA col13, -- ���������������� ���: �����
            LIV_AREA col14, -- ���������������� ���: � ��� ����� �����
            NOT_LIV_AREA col15, -- ���������������� ���: � ��� ����� ������� living_rooms_with_nonresidental_sq
            '' col16, -- ���������� �������
            CASE acc_type WHEN 1 THEN  1 WHEN 2 THEN 2 WHEN 50 THEN 4 ELSE 0 END col17,   -- ������ ������������ ����� ������������ �������
            TO_CHAR(VOTE_DATE,'dd.mm.yyyy') col18,  -- ���� �������� ������� � ������� ������������ ����� ������������ �������
            bic_num col19, -- ��� ��������� �����������, � ������� ������ ����������� ���� (� ������ ������ ������������ ����� ������������ ������� �� ����������� �����)

            CHARGE_SUM_TOTAL/1000 col20, -- ����� ������� �� ���������� ������������ ������� � ������� ����������� ����������� �� ������ ������� (�����)
            GREATEST(DOLG_SUM_TOTAL/1000,0) col21, -- ������� ������������� ������������� �� ������� �� ����������� ������

            JOB_SUM_TOTAL/1000 col22, -- ������������� ������� �� ���������� ����� (�����) �� ������������ �������	�����

            GOS_JOB_SUM_TOTAL/1000 col23, -- ������������� ������� �� ���������� ����� (�����) �� ������������ �������	� ��� ����� ��������
            BALANCE_SUM_TOTAL/1000 col24, -- ������� ������� �� ���������� ����� (�����) �� ������������ �������

            TO_CHAR(sysdate,'dd.mm.yyyy') col25, -- ���� ������������ ����������
            TO_CHAR(START_DATE,'mm.yyyy') col26, -- ���� ����������� ����������� �� ������ �������
            6.74 col27, -- ������ ������ ������������� �� ����������� ������
            '' col28, -- ����� ������������������� ����
            '' col29, -- ���������� ����� ������������������� ����
            '' col30, -- ���� ���������� ������ ������������������� ����
            '' col31, -- ����� ������������������� ���� ������� � ����� � ����������� ����� (�����) �� ������������ �������
            TO_CHAR(END_DATE,'dd.mm.yyyy') col32, -- ���� ���������� ���� �� ���������
            '' col33 --�����������
        from
            houses h
            left join rooms r on (h.HOUSE_ID = r.HOUSE_ID)
            left join bnk b on (h.HOUSE_ID = b.HOUSE_ID)
--            left join tar t on (h.HOUSE_ID = t.HOUSE_ID)
            join bal on (h.HOUSE_ID = bal.HOUSE_ID)
      )
SELECT
    "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22","COL23","COL24","COL25","COL26","COL27","COL28","COL29","COL30","COL31","COL32","COL33"
FROM
  alls
;
