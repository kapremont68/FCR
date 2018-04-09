--------------------------------------------------------
--  DDL for Package P#CC_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#CC_UTILS" 
  IS

  FUNCTION GET#AD_INITED(A#A_ID                NUMBER,
                         A#MN                  NUMBER,
                         AOBJ#AD IN OUT NOCOPY TOBJ#CC_AD)
    RETURN BOOLEAN
  ;

  FUNCTION GET_OBJ#DV(A#A_ID                NUMBER,
                      A#MN                  NUMBER,
                      AOBJ#AD IN OUT NOCOPY TOBJ#CC_AD,
                      AOBJ#D                TOBJ#CC_D)
    RETURN TOBJ#CC_DV
  ;
  FUNCTION GET_TAB#DVS(A#A_ID                NUMBER,
                       A#MN                  NUMBER,
                       AOBJ#AD IN OUT NOCOPY TOBJ#CC_AD,
                       ATAB#D                TTAB#CC_D)
    RETURN TTAB#CC_DVS
  ;

  FUNCTION GET_OBJ#A(A#A_ID NUMBER,
                     A#MN   NUMBER)
    RETURN TOBJ#CC_A;
  FUNCTION GET_TAB#D(A#A_ID NUMBER,
                     A#MN   NUMBER)
    RETURN TTAB#CC_D;

END;

/
