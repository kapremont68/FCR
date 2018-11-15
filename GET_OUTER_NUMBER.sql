--------------------------------------------------------
--  DDL for Function GET_OUTER_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_OUTER_NUMBER" 
(
  A#NUM IN VARCHAR2 
) RETURN VARCHAR2 AS 
a#ret_num varchar2(30);
BEGIN
  select c#out_num into a#ret_num from fcr.t#account ta inner join fcr.t#account_op taop on (ta.c#id = taop.c#account_id)
  where taop.c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id)
  and c#num = a#num;
  
  RETURN a#ret_num;
END GET_OUTER_NUMBER;

/
