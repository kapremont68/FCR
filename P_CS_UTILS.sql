--------------------------------------------------------
--  DDL for Package P#CS_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#CS_UTILS" 
  IS

  FUNCTION GET#1ST_MN(A#A_ID NUMBER,
                      A#W_ID NUMBER,
                      A#D_ID NUMBER,
                      A#MN   NUMBER)
    RETURN NUMBER;

  FUNCTION GET_TAB#D(A#A_ID NUMBER,
                     A#MN   NUMBER)
    RETURN TTAB#CS_D
  ;

END;

/
