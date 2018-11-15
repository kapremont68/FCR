--------------------------------------------------------
--  DDL for Procedure UPD#HOUSE_DATE_BEGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#HOUSE_DATE_BEGIN" 
(
  A#HOUSE_ID IN NUMBER 
, A#DATE IN date
) AS 
BEGIN
-- дом
update fcr.t#house_info
set
   C#2ND_DATE = A#DATE
where   c#house_id = A#HOUSE_ID;
--счета
for rec in 
 (select a.c#id from fcr.t#account a,fcr.t#rooms r where 1=1 and r.c#id = a.c#rooms_id and r.c#house_id = A#HOUSE_ID)
loop
  begin
        UPD#ACCOUNT_ID_DATE_BEGIN (rec.c#id,A#DATE);
  exception
  when others then 
        dbms_output.put_line(rec.c#id);
  end;      
end loop;
commit;
END UPD#HOUSE_DATE_BEGIN;

/
