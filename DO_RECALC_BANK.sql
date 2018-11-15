--------------------------------------------------------
--  DDL for Procedure DO#RECALC_BANK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#RECALC_BANK" 
(
	A#DATE IN DATE
)  
AS 
  A#N_MN integer;
  A#MN integer;
	a#err varchar2(4000);
begin
   select fcr.p#utils.GET#OPEN_B_MN into A#MN from DUAL;
   select fcr.p#mn_utils.GET#MN(a#date) into A#N_MN from DUAL;
	 
   execute immediate 'alter trigger TR#B_STORAGE#WARD disable';
   execute immediate 'alter trigger TR#B_STORE#WARD disable';
	 
   for a#open_mn in A#N_MN-1 .. A#MN
   loop
    for cr#i in (select t.c#id from t#house t order by 1)
    loop
       fcr.do#calc_b_store(cr#i.c#id, a#open_mn);
    end loop;
	 end loop;
	 	
   execute immediate 'alter trigger TR#B_STORE#WARD enable';               
   execute immediate 'alter trigger TR#B_STORAGE#WARD enable';							 

 commit;
   
exception
   when OTHERS then 
     rollback;
		 a#err := 'Error - '||to_char(SQLCODE)||' - '||SQLERRM;
     insert into fcr.t#exception(c#name_package,c#name_proc,c#date,c#text,c#comment) 
		 values('PROCEDURE','DO#RECALC_BANK',sysdate,a#err,'');
END DO#RECALC_BANK;

/
