--------------------------------------------------------
--  DDL for Function GET_ACC_DEBT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_DEBT" 
(
  A#NUM IN VARCHAR2 
) RETURN NUMBER AS 
a#dolg number;
a#account_id number;
a#open_mn  number; 
BEGIN

  a#dolg := 0;
  select fcr.p#utils.get#OPEN_MN  into a#open_mn from dual;
  select c#id into a#account_id from fcr.t#account where  c#num = a#num;
  select
    round(SUM(NVL(c.c#Sum,0)) - SUM(NVL(op.p#Sum,0)),2) into a#dolg
  FROM 
  (SELECT  SUM(NVL(c#sum,0)) AS c#sum  FROM fcr.t#charge  
              where c#account_id = a#account_id
              and c#a_mn < a#open_mn ) c, 
  (SELECT  SUM(NVL(c#sum,0)) AS p#sum  FROM fcr.v#op  
              where c#account_id = a#account_id
              and c#a_mn < a#open_mn ) op; 
  RETURN a#dolg;
  
END GET_ACC_DEBT;

/
