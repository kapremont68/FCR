--------------------------------------------------------
--  DDL for Function GET_CURRENT_USER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_CURRENT_USER" RETURN NUMBER AS 
   ret_id number;
BEGIN
  select user_id into ret_id from Dba_users where username = user;
  RETURN ret_id;
END GET_CURRENT_USER;

/
