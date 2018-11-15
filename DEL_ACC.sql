--------------------------------------------------------
--  DDL for Function DEL#ACC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."DEL#ACC" (A#acc_id in number) return number 
is
ret number;
a#err varchar2(4000);
a_exist number;
begin

  select count(*) into a_exist from fcr.v#op where c#account_id = a#acc_id;
  if ( a_exist > 0 ) then 
  return -1;
  end if;
  
execute immediate 'alter trigger TR#CHARGE#WARD disable';
delete from fcr.t#charge where c#account_id = A#acc_id;
execute immediate 'alter trigger TR#CHARGE#WARD enable';

execute immediate 'alter trigger TR#STORAGE#WARD disable';
delete from fcr.t#storage where c#account_id = A#acc_id; 
execute immediate 'alter trigger TR#STORAGE#WARD enable';

execute immediate 'alter trigger TR#STORE#WARD disable';
delete from fcr.t#store where c#account_id = A#acc_id;
execute immediate 'alter trigger TR#STORE#WARD enable';

delete from fcr.t#obj where c#account_id = A#acc_id;

delete from fcr.t#account_op where c#account_id = A#acc_id;

delete from fcr.t#account_spec_vd where c#id in (select c#id from fcr.t#account_spec where c#account_id = A#acc_id);

delete from fcr.t#account_spec where c#account_id = A#acc_id;

insert into TT#TR_FLAG(C#VAL) values ('ACCOUNT_VD#PASS_MOD');

delete from fcr.t#account_vd  where c#id =  A#acc_id;

insert into TT#TR_FLAG(C#VAL) values ('ACCOUNT#PASS_MOD');
delete from fcr.t#account a where a.c#id = A#acc_id;
commit;
return 0;
exception
   when OTHERS then 
     rollback;
     dbms_output.put_line('PROCEDURE DO#DEL_ACC_ID ' ||  to_char(sysdate) || ' ' || a#err || ' ' || to_char(A#ACC_ID));
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
         insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#DEL_ACC_ID',sysdate,a#err,to_char(A#ACC_ID));
    RAISE_APPLICATION_ERROR(-20001,'Rollback DO#DEL_ACC_ID: ' || SQLCODE || ', ' || SQLERRM);
end del#acc;

/
