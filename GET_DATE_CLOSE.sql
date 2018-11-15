--------------------------------------------------------
--  DDL for Function GET_DATE_CLOSE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_DATE_CLOSE" 
(
  A#NUM IN VARCHAR2 
) RETURN VARCHAR2 AS 
a#ret_num VARCHAR2(10);
BEGIN
  select nvl(to_char(ta.c#end_date),'') into a#ret_num from fcr.v#account ta inner join fcr.t#account_op taop on (ta.c#id = taop.c#account_id)
  where taop.c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id) 
  and c#out_num = a#num;
  RETURN nvl(a#ret_num,' ');
  exception
  when OTHERS then 
  RETURN ' ';
END GET_DATE_CLOSE;

/
