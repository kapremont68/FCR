--------------------------------------------------------
--  DDL for View V_PERSON_P
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V_PERSON_P" ("PERSON_ID", "F_NAME", "I_NAME", "O_NAME", "PHONE", "CONTACT", "NOTE", "MAIL") AS 
  select 
    C#PERSON_ID PERSON_ID,
    C#F_NAME F_NAME ,
    C#I_NAME I_NAME,
    C#O_NAME O_NAME,
    C#PHONE PHONE,
    C#CONTACT CONTACT,
    C#NOTE NOTE,
    C#MAIL MAIL
    

from T#PERSON_P
;
