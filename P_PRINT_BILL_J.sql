--------------------------------------------------------
--  DDL for Package P#PRINT_BILL_J
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#PRINT_BILL_J" 
  IS

  PROCEDURE do#prepare(a#date_lo   DATE,
                       a#date_hi   DATE,
                       a#person_id NUMBER);

  PROCEDURE do#prepare2(a#date_lo   DATE,
                       a#date_hi   DATE,
                       a#person_id NUMBER);

                       
  FUNCTION get#master_data(a#person_id NUMBER)
    RETURN sys_refcursor;

  FUNCTION get#detail_data1
    RETURN sys_refcursor;

  FUNCTION get#detail_data2
    RETURN sys_refcursor;

  FUNCTION get#total_sum_w
    RETURN VARCHAR2;

  FUNCTION get#pbj_num_cur
    RETURN NUMBER;

  FUNCTION get#pbj_num_next
    RETURN NUMBER;

END p#print_bill_j;

/
