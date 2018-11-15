--------------------------------------------------------
--  DDL for View V_KR12
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_KR12" ("COL1", "COL2", "COL3", "COL4", "COL5", "COL6", "COL7", "COL8", "COL9", "COL10", "COL11", "COL12", "COL13", "COL14", "COL15", "COL16", "COL17", "COL18", "COL19", "COL20", "COL21", "COL22") AS 
  WITH
    elems as (
        select distinct
          J.C#HOUSE_ID HOUSE_ID,
          C#ELEM_CODE ELEM_CODE
        from
          T3_JOBS J
          join T3_JOB_TYPE T on (J.C#JOB_TYPE_ID = T.C#ID)
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
            ELEM_CODE col7, -- Вид конструктивного элемента (системы)
            '' col8,
            '' col9,
            '' col10,
            '' col11,
            '' col12,
            '' col13,
            '' col14,
            '' col15,
            '' col16,
            '' col17,
            '' col18,
            '' col19,
            '' col20,
            '' col21,
            '' col22
        from
            houses h
            join elems e on (h.HOUSE_ID = e.HOUSE_ID)
      )
    ,plan as (
        select distinct
            'Тамбовская область' col1,	-- Субъект Российской Федерации
            OKTMO_CODE col2, -- Код ОКТМО муниципального района
            regexp_substr(h.ADDR, '[^,]+') col3,  -- Наименование муниципального района
            h.HOUSE_ID col4, -- Код МКД
            h.ADDR col5, -- Адрес многоквартирного дома
            ELEM_CODE col6, -- Код конструктивного элемента (системы)
            ELEM_CODE col7, -- Вид конструктивного элемента (системы)
            '' col8,
            '' col9,
            '' col10,
            '' col11,
            '' col12,
            '' col13,
            '' col14,
            '' col15,
            '' col16,
            '' col17,
            '' col18,
            '' col19,
            '' col20,
            '' col21,
            '' col22
        from
            houses h
            join V3_JOBS_PLAN_KR k on (h.HOUSE_ID = k.HOUSE_ID)
      )
SELECT "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22" FROM  alls
union all
SELECT "COL1","COL2","COL3","COL4","COL5","COL6","COL7","COL8","COL9","COL10","COL11","COL12","COL13","COL14","COL15","COL16","COL17","COL18","COL19","COL20","COL21","COL22" FROM  plan
;
