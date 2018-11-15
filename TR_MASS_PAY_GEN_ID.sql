--------------------------------------------------------
--  DDL for Trigger TR#MASS_PAY#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#MASS_PAY#GEN_ID" 
 before insert
 on T#MASS_PAY
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#MASS_PAY.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#MASS_PAY#GEN_ID" ENABLE;
