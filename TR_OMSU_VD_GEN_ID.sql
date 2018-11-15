--------------------------------------------------------
--  DDL for Trigger TR#OMSU_VD#GEN_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "FCR"."TR#OMSU_VD#GEN_ID" 
 before insert
 on T#OMSU_VD
 for each row
   WHEN (new.C#ID is null) begin
 :new.C#ID := S#OMSU.nextval;
-- insert into fcr.t#omsu values(:new.C#ID);
end;
/
ALTER TRIGGER "FCR"."TR#OMSU_VD#GEN_ID" ENABLE;
