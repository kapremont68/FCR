--------------------------------------------------------
--  DDL for Package P#EXCEPTION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#EXCEPTION" AS 

    PROCEDURE log#exception(a#name_package VARCHAR2, a#name_proc VARCHAR2, a#text VARCHAR2, a#comment VARCHAR2);


END P#EXCEPTION;

/
