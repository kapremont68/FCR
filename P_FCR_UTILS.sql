--------------------------------------------------------
--  DDL for Package P#FCR_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FCR_UTILS" 
  IS

  FUNCTION get#house_area(a#house_id NUMBER,
                          a#date     DATE)
    RETURN NUMBER;

  FUNCTION get#num_to_word(a#number NUMBER)
    RETURN string;

  FUNCTION get#address(a#house_id NUMBER)
    RETURN VARCHAR2;

  FUNCTION do#account_num(a#house_id NUMBER)
    RETURN VARCHAR2;
END;

/
