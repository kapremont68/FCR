--------------------------------------------------------
--  DDL for Procedure DO#RECALC_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_ACCOUNT" 
(
    A#ACCOUNT_NUM IN VARCHAR2,
	A#DATE IN DATE,
    A#ACC_ID NUMBER DEFAULT NULL
)  
AS 
  A#N_MN integer;
  A#MN integer;
  A#ACCOUNT_ID integer;  
	a#err varchar2(4000);
begin

   select fcr.p#utils.GET#OPEN_MN into A#MN from DUAL;
   select fcr.p#mn_utils.GET#MN(a#date) into A#N_MN from DUAL;

   if A#ACC_ID is null then
    select c#id into a#ACCOUNT_ID from fcr.t#account where c#num = a#account_num; 
   else
    a#ACCOUNT_ID := A#ACC_ID;
   end if;
	 
   execute immediate 'alter trigger TR#CHARGE#WARD disable';
   execute immediate 'alter trigger TR#STORAGE#WARD disable';
   execute immediate 'alter trigger TR#STORE#WARD disable';
   
--   FCR1

    delete from T#CHARGE where C#ACCOUNT_ID = A#ACCOUNT_ID and c#A_MN >= A#N_MN-1;
    delete from T#STORAGE where C#ACCOUNT_ID = A#ACCOUNT_ID and c#MN >= A#N_MN;
    commit;

         for a#open_mn in A#N_MN-1 .. A#MN
               loop
--                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,0);
                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,1);
--                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,2);
--                  fcr.p#fcr.do#calc_account(fcr.p#mn_utils.Get#date(a#open_mn),A#ACCOUNT_ID,3);
--                  commit;
               end loop;


--   fcr.p#fcr.do#calc_account(sysdate,A#ACCOUNT_ID,3); -- дата похер какая, т.к. внутри все равно используется цикл по всем MN
--   commit;
               
   execute immediate 'alter trigger TR#STORE#WARD enable';               
   execute immediate 'alter trigger TR#STORAGE#WARD enable';							 
   execute immediate 'alter trigger TR#CHARGE#WARD enable';							 
   
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
		 P#EXCEPTION.LOG#EXCEPTION('PROCEDURE','DO#RECALC_ACCOUNT',a#err,to_char(a#account_num));
    DBMS_OUTPUT.PUT_LINE(a#err);
END DO#RECALC_ACCOUNT;

/
