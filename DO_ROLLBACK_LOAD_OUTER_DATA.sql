--------------------------------------------------------
--  DDL for Procedure DO#ROLLBACK_LOAD_OUTER_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#ROLLBACK_LOAD_OUTER_DATA" 
(
  A#FILE_ID IN NUMBER 
) AS 
BEGIN
  delete from fcr.t#pay_source where c#file_id = A#FILE_ID;
  delete from fcr.t#file_pay where c#id = A#FILE_ID;
  COMMIT;
END DO#ROLLBACK_LOAD_OUTER_DATA;

/
