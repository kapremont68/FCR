--------------------------------------------------------
--  DDL for Index X#DOING_VD##P
--------------------------------------------------------

  CREATE UNIQUE INDEX "FCR"."X#DOING_VD##P" ON "FCR"."T#DOING_VD" ("C#ID", "C#VN") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS COMPRESS 1 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS#DATA1" ;
