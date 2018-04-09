--------------------------------------------------------
--  DDL for Package P#TR_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#TR_UTILS" 
  IS

  PROCEDURE DO#INIT_OBJ(A#A_ID NUMBER,
                        A#W_ID NUMBER,
                        A#D_ID NUMBER);
  PROCEDURE DO#INIT_B_OBJ(A#H_ID  NUMBER,
                          A#S_ID  NUMBER,
                          A#BA_ID NUMBER);

  PROCEDURE DO#WARD_CLOSE(ATAB#A_W_MN TTAB#TR_A_W_MN,
                          A#ACT_NAME  VARCHAR2,
                          A#OBJ_NAME  VARCHAR2);
  PROCEDURE DO#WARD_CLOSE(ATAB#H_S_MN TTAB#TR_H_S_MN,
                          A#ACT_NAME  VARCHAR2,
                          A#OBJ_NAME  VARCHAR2);
  PROCEDURE DO#WARD_B_CLOSE(ATAB#H_S_MN TTAB#TR_H_S_MN,
                            A#ACT_NAME  VARCHAR2,
                            A#OBJ_NAME  VARCHAR2);

END;

/
