--------------------------------------------------------
--  DDL for Procedure UPD#ACCOUNT_ID_DATE_BEGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#ACCOUNT_ID_DATE_BEGIN" 
(
  A#ACCOUNT_ID IN number
, A#DATE IN date
) AS 
a#id number;
A#NUM varchar2(20);
BEGIN
  a#id := a#account_id;
insert into tt#tr_flag (c#val) values ('ACCOUNT#PASS_MOD');
insert into tt#tr_flag (c#val) values ('ACCOUNT_SPEC#PASS_MOD');
update (select * from fcr.t#account where c#id= A#ID )
set c#date = a#date;
update (select * from fcr.t#account_spec where c#account_id = A#ID )
set c#date = a#date;
commit;
-- выполняем перерасчет
select c#num into a#num from fcr.t#account where c#id = a#account_id;
DO#RECALC_ACCOUNT( A#NUM, A#DATE);

END UPD#ACCOUNT_ID_DATE_BEGIN ;

/
