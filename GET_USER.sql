--------------------------------------------------------
--  DDL for Function GET#USER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#USER" (A#USER_ID INTEGER) return SYS_REFCURSOR is
  Result SYS_REFCURSOR;
begin
  open Result for
  select * from all_users where user_id = A#user_id;
  return(Result);
end GET#USER ;

/
