--------------------------------------------------------
--  DDL for Trigger HOSTS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."HOSTS_TRG" 
before insert
 on HOSTS
 for each row
  WHEN (new.C#ID is null) begin
 :new.C#ID := S#HOSTS.nextval;
end;
/
ALTER TRIGGER "FCR"."HOSTS_TRG" ENABLE;
