--------------------------------------------------------
--  DDL for Trigger TR#PAY_SOURCE#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#PAY_SOURCE#GEN_ID" 
 before insert
 on T#PAY_SOURCE
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#PAY_SOURCE.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#PAY_SOURCE#GEN_ID" ENABLE;
