--------------------------------------------------------
--  DDL for Function GET#OUT_NUM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#OUT_NUM" 
(
  A#ADDRESS IN VARCHAR2 
) RETURN VARCHAR2 AS 
ret varchar2(100);
BEGIN
  select c#out_num into ret from fcr.v#account va 
  inner join ( select * from fcr.t#account_op ao where c#date = (select max(c#date) from fcr.t#account_op where c#account_id =  ao.c#account_id)) tao
  on (tao.c#account_id = va.c#id)
  where  va.c#end_date is null and fcr.p#utils.get#rooms_addr(va.c#rooms_id) like A#ADDRESS;
  RETURN nvl(ret,' ');
  exception
  when OTHERS then 
  RETURN ' ';
END GET#OUT_NUM;

/
