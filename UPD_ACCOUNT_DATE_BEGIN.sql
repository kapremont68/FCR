--------------------------------------------------------
--  DDL for Procedure UPD#ACCOUNT_DATE_BEGIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#ACCOUNT_DATE_BEGIN" 
(
  A#NUM IN VARCHAR2 DEFAULT 15 
, A#DATE IN VARCHAR2 DEFAULT 10 
) AS 
BEGIN

insert into tt#tr_flag (c#val) values ('ACCOUNT#PASS_MOD');
insert into tt#tr_flag (c#val) values ('ACCOUNT_SPEC#PASS_MOD');
update (select * from fcr.t#account where c#num= a#num )
set c#date = to_date(a#date,'dd.mm.yyyy');
update (select * from fcr.t#account_spec where c#account_id = (select c#id from fcr.t#account where c#num= a#num) )
set c#date = to_date(a#date,'dd.mm.yyyy');
commit;

DO#RECALC_ACCOUNT( A#NUM, A#DATE);

END UPD#ACCOUNT_DATE_BEGIN;

/
