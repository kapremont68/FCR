--------------------------------------------------------
--  DDL for Procedure DO#CLOSE_ACCOUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CLOSE_ACCOUNT" 
(
  A#DATE IN DATE 
, A#ACCOUNT_ID NUMBER
, A#STATUS OUT NUMBER 
) AS 
  A#MN number ; -- мес€ц закрыти€ счета
  A#OP number ;
  A#COUNT number;
  rw_charge fcr.t#charge%rowtype;
BEGIN
   A#STATUS := 1;
   A#OP := fcr.p#utils.GET#OPEN_MN;
   IF (not A#DATE is null ) THEN  
   A#MN := fcr.P#MN_UTILS.GET#MN(A#DATE); -- мес€ц закрыти€ счета
-- проверить, что нет оплат за период до даты закрыти€  
   select count(*) into A#COUNT from fcr.t#op where c#account_id = a#account_id and c#a_mn >=a#mn;
-- dbms_output.put_line('—чет : ' || A#ACCOUNT_ID || ' ћес€ц :' || A#MN || ' оплаты :' || A#COUNT);
-- удалить начислени€ до даты закрыти€
   IF(A#COUNT = 0) THEN
      for rw_charge in 
      (
       select  C#VOL,C#B_MN,C#A_MN,C#DOER_ID,C#WORK_ID,C#ACCOUNT_ID,Sum(NVL(C#SUM,0)) C#SUM from fcr.t#charge where c#account_id = a#account_id and c#a_mn >=A#MN and c#a_mn < A#OP
       group by  C#VOL,C#B_MN,C#A_MN,C#DOER_ID,C#WORK_ID,C#ACCOUNT_ID
      )
      loop
         -- dbms_output.put_line(uid || ' ' || SYSDATE || ' ' || -1*rw_charge.C#SUM || ' ' || -1*rw_charge.C#VOL || ' ' || rw_charge.C#B_MN || ' ' || rw_charge.C#A_MN || ' ' || (A#OP+1)
         -- || ' ' || rw_charge.C#DOER_ID || ' ' || rw_charge.C#WORK_ID || ' ' || rw_charge.C#ACCOUNT_ID);          
          insert into fcr.t#charge(C#SIGN_S_ID,C#SIGN_DATE,C#SUM,C#VOL,C#B_MN,C#A_MN,C#MN,C#DOER_ID,C#WORK_ID,C#ACCOUNT_ID)
          values (uid,SYSDATE,-1*rw_charge.C#SUM,-1*rw_charge.C#VOL,rw_charge.C#B_MN,rw_charge.C#A_MN, A#OP,rw_charge.C#DOER_ID,rw_charge.C#WORK_ID,rw_charge.C#ACCOUNT_ID);      
      end loop;
      delete from fcr.t#Charge where c#account_id = a#account_id  and c#a_mn = A#OP;
      A#STATUS := 0;
   END IF;
   END IF;
   
END DO#CLOSE_ACCOUNT;

/
