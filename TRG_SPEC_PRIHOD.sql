--------------------------------------------------------
--  DDL for Trigger TRG_SPEC_PRIHOD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TRG_SPEC_PRIHOD" 
before insert
 on SPEC_PRIHOD
 for each row
  WHEN (new.c#ID is null) begin
 :new.c#ID := S#SPEC_PRIHOD.nextval;
end;

/
ALTER TRIGGER "FCR"."TRG_SPEC_PRIHOD" ENABLE;
