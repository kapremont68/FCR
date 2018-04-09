--------------------------------------------------------
--  DDL for Package P#CBS_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#CBS_UTILS" is

 function GET#1ST_MN(A#H_ID number, A#S_ID number, A#BA_ID number, A#MN number) return number;

 function GET_TAB#D
  (
   A#H_ID number
  ,A#MN number
  ) return TTAB#CBS_D
 ;

end;


/
