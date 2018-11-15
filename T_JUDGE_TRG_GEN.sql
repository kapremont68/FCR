--------------------------------------------------------
--  DDL for Trigger T_JUDGE_TRG_GEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."T_JUDGE_TRG_GEN" 
before insert
 on "T_JUDGE"
 for each row
   WHEN (new.C_ID is null) begin
 :new.C_ID := S#JUDGE.nextval;
end;
/
ALTER TRIGGER "FCR"."T_JUDGE_TRG_GEN" ENABLE;
