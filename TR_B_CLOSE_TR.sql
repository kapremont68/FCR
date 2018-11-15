--------------------------------------------------------
--  DDL for Trigger TR#B_CLOSE_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#B_CLOSE_TR" 
 after insert
 on MV#B_CLOSE_TR
declare
 A#JOB number;
begin
 dbms_job.submit(A#JOB, 'dbms_mview.refresh(''FCR.MV#B_CLOSE_MAX_MN'');');
end;


/
ALTER TRIGGER "FCR"."TR#B_CLOSE_TR" ENABLE;
