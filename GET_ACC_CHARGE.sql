--------------------------------------------------------
--  DDL for Function GET_ACC_CHARGE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_CHARGE" 
(
  A#NUM IN VARCHAR2 
) RETURN NUMBER AS 
c#sum number;
BEGIN
  c#sum := 0;
  SELECT  NVL(c#sum,0) into c#sum  FROM fcr.t#charge  
where c#a_mn = fcr.p#utils.get#OPEN_MN and c#account_id in (select c#id from fcr.v#account where c#end_date is null and c#valid_tag = 'Y'  and c#num = A#NUM)
;            
  RETURN c#sum;
END GET_ACC_CHARGE;

/
