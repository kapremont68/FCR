--------------------------------------------------------
--  DDL for Trigger TRG_KOTEL_OTHER_PRIH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TRG_KOTEL_OTHER_PRIH" 
before insert
 on KOTEL_OTHER_PRIH
 for each row
  WHEN (new.ID is null) begin
 :new.ID := S#KOTEL_OTHER_PRIH.nextval;
end;

/
ALTER TRIGGER "FCR"."TRG_KOTEL_OTHER_PRIH" ENABLE;
