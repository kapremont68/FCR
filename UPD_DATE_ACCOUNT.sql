--------------------------------------------------------
--  DDL for Procedure UPD#DATE_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."UPD#DATE_ACCOUNT" 
(
  a#id integer,
  a#date date
)
AS 
BEGIN

  update (select * from fcr.t#account where c#id = a#id)
  set  c#date = a#date;
  
END UPD#DATE_ACCOUNT;

/
