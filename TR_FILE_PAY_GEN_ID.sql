--------------------------------------------------------
--  DDL for Trigger TR#FILE_PAY#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#FILE_PAY#GEN_ID" 
 before insert
 on T#FILE_PAY
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#FILE_PAY.nextval;
end;

/
ALTER TRIGGER "FCR"."TR#FILE_PAY#GEN_ID" ENABLE;
