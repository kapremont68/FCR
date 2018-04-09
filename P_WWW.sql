--------------------------------------------------------
--  DDL for Package P#WWW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#WWW" AS 

    function get#acc_id_by_any_acc_num(p_ACC_NUM VARCHAR2) RETURN NUMBER;
    
    function get#acc_balance(p_ACC_NUM VARCHAR2) RETURN sys_refcursor;

END P#WWW;

/
