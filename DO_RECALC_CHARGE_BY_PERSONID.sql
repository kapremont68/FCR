--------------------------------------------------------
--  DDL for Procedure DO#RECALC_CHARGE_BY_PERSONID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_CHARGE_BY_PERSONID" (P_PERSON_ID IN NUMBER) AS 
BEGIN
-- пересчитываем начисления по всем счетам принадлежащим юрику сейчас
    FOR rec IN (
        select distinct C#ACC_NUM from v#acc_last2 where C#PERSON_ID = P_PERSON_ID
    )            
    LOOP
        BEGIN
            FCR.DO#RECALC_ACCOUNT(rec.C#ACC_NUM, to_date('01.06.2014','dd.mm.yyyy')); 
        END;        
    END LOOP;
END DO#RECALC_CHARGE_BY_PERSONID;

/
