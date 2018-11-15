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
            'Тамбовская область' col1,	-- Субъект Российской Федерации
            OKTMO_CODE col2, -- Код ОКТМО муниципального района
            regexp_substr(h.ADDR, '[^,]+') col3,  -- Наименование муниципального района
            h.HOUSE_ID col4, -- Код МКД
            h.ADDR col5, -- Адрес многоквартирного дома
            ELEM_CODE col6, -- Код конструктивного элемента (системы)
            j.job_type_id col7, -- Код работы (услуги)
            j.reg_job_type_name col8, -- Вид работы (услуги) по капитальному ремонту в соответствии с законом субъекта Российской Федерации
            j.YEAR_END col9, -- Год завершения работы (услуги), в соответствии с региональной программой капитального ремонта общего имущества в многоквартирных домах или краткосрочным планом ее реализации
            '' col10, -- Стоимость работы (услуги)  в соответствии с утвержденным планом (планами)
            '' col11, -- Стоимость работы (услуги) в соответствии с заключенными договорами
            JOB_SUM col12, -- Стоимость работы (услуги) принято по актам
            'рубли' col13, -- Единица измерения
            JOB_SUM col14, -- Объем работ (услуг) по капитальному ремонту в соответствии с единицами измерения
            replace(replace(gov_name,chr(10),''),chr(13),'') col15, -- Заказчик работы (услуги) по капитальному ремонту Наименование
            gov_inn col16, -- Заказчик работы (услуги) по капитальному ремонту ИНН
            CONTRACTOR_NAME col17, -- Исполнитель работы (услуги) по капитальному ремонту Наименование
            CONTRACTOR_INN col18, -- Исполнитель работы (услуги) по капитальному ремонту ИНН
            TO_CHAR(CONTRACT_DATE,'dd.mm.yyyy') col19, -- Дата заключения договора подряда
            TO_CHAR(JOB_DATE_END,'dd.mm.yyyy') col20, -- Плановая дата завершения работ (услуг) по договору подряда
            '' col21, -- Дата подписания акта приемки
            '' col22, -- Примечание
            TO_CHAR(sysdate,'dd.mm.yyyy') col23 -- Дата актуализации информации
        from
            houses h
            join jobs j on (h.HOUSE_ID = j.HOUSE_ID)
      )
    ,plan as (
        select distinct
            'Тамбовская область' col1,	-- Субъект Российской Федерации
            OKTMO_CODE col2, -- Код ОКТМО муниципального района
            regexp_substr(h.ADDR, '[^,]+') col3,  -- Наименование муниципального района
            h.HOUSE_ID col4, -- Код МКД
            h.ADDR col5, -- Адрес многоквартирного дома
            ELEM_CODE col6, -- Код конструктивного элемента (системы)
            j.job_type_id col7, -- Код работы (услуги)
            j.JOB_TYPE_NAME col8, -- Вид работы (услуги) по капитальному ремонту в соответствии с законом субъекта Российской Федерации
            j.YEAR_END col9, -- Год завершения работы (услуги), в соответствии с региональной программой капитального ремонта общего имущества в многоквартирных домах или краткосрочным планом ее реализации
            null col10, -- Стоимость работы (услуги)  в соответствии с утвержденным планом (планами)
            null col11, -- Стоимость работы (услуги) в соответствии с заключенными договорами
            null col12, -- Стоимость работы (услуги) принято по актам
            null col13, -- Единица измерения
            null col14, -- Объем работ (услуг) по капитальному ремонту в соответствии с единицами измерения
            null col15, -- Заказчик работы (услуги) по капитальному ремонту Наименование
            null col16, -- Заказчик работы (услуги) по капитальному ремонту ИНН
            null col17, -- Исполнитель работы (услуги) по капитальному ремонту Наименование
            null col18, -- Исполнитель работы (услуги) по капитальному ремонту ИНН
            null col19, -- Дата заключения договора подряда
            null col20, -- Плановая дата завершения работ (услуг) по договору подряда
            null col21, -- Дата подписания акта приемки
            null col22, -- Примечание
            TO_CHAR(sysdate,'dd.mm.yyyy') col23 -- Дата актуализации информации
        from
            houses h
            join V3_JOBS_PLAN_KR j on (h.HOUSE_ID = j.HOUSE_ID)
      )
SELECT "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22","COL23" FROM alls
union all
SELECT "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22","COL23" FROM plan
;
