--------------------------------------------------------
--  DDL for Trigger TR#CLOSE_TR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#CLOSE_TR" 
 after insert
 on MV#CLOSE_TR
declare
 A#JOB number;
begin
 dbms_job.submit(A#JOB, 'dbms_mview.refresh(''FCR.MV#CLOSE_MAX_MN'');');
end;


/
ALTER TRIGGER "FCR"."TR#CLOSE_TR" ENABLE;
