--------------------------------------------------------
--  DDL for Procedure HOST_COMMAND
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."HOST_COMMAND" (p_command  IN  VARCHAR2)
AS LANGUAGE JAVA 
NAME 'Host.executeCommand (java.lang.String)';

/
