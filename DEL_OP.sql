--------------------------------------------------------
--  DDL for Procedure DEL#OP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DEL#OP" (a#ops_id number) is
a#err varchar2(4000);
begin
  insert into TT#TR_FLAG (C#VAL) values('OP#PASS_MOD');
  insert into TT#TR_FLAG (C#VAL) values('OP_VD#PASS_MOD');
    delete from fcr.t#op_vd where c#id in (select c#id from fcr.t#op where c#ops_id = a#ops_id);
    delete from fcr.t#op where c#ops_id = a#ops_id;
--  commit;
  exception
   when OTHERS then 
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DEL#OP',sysdate,a#err,to_char(a#ops_id));
     rollback;
 
end;

/
