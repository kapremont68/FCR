--------------------------------------------------------
--  DDL for View V#PSOP_DIFF
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FCR"."V#PSOP_DIFF" ("ACC_ID", "PS_SUM", "OP_SUM", "OP_MINUS_PS") AS 
  select
    O.ACC_ID,
    nvl(P.SUMM,0) PS_SUM,
    O.SUMM OP_SUM,
    O.SUMM-nvl(P.SUMM,0) OP_MINUS_PS
from
    TT#PSOP_OP O
    left join TT#PSOP_PS P on (P.ACC_ID = O.ACC_ID)
;
