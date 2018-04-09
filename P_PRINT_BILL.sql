--------------------------------------------------------
--  DDL for Package P#PRINT_BILL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#PRINT_BILL" 
  IS
  FUNCTION get#master_data(a#account      NUMBER,
                           a#date         DATE,
                           a#acc_num_type NUMBER := 1)
    RETURN sys_refcursor;

  FUNCTION lst#tarif_detail(a#account NUMBER,
                            a#date    DATE)
    RETURN sys_refcursor;

  FUNCTION get#total_sum(a#account NUMBER,
                         a#date    DATE)
    RETURN sys_refcursor;

  FUNCTION lst#bill_subdetail(a#account NUMBER,
                              a#date    DATE,
                              a#work_id NUMBER)
    RETURN sys_refcursor;

END p#print_bill;

/
