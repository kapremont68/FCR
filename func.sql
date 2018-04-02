--------------------------------------------------------
--  File created - понедельник-апреля-02-2018   
--------------------------------------------------------
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
--------------------------------------------------------
--  DDL for Function GET_ACC_CHARGE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_CHARGE" 
(
  A#NUM IN VARCHAR2 
) RETURN NUMBER AS 
c#sum number;
BEGIN
  c#sum := 0;
  SELECT  NVL(c#sum,0) into c#sum  FROM fcr.t#charge  
where c#a_mn = fcr.p#utils.get#OPEN_MN and c#account_id in (select c#id from fcr.v#account where c#end_date is null and c#valid_tag = 'Y'  and c#num = A#NUM)
;            
  RETURN c#sum;
END GET_ACC_CHARGE;

/
--------------------------------------------------------
--  DDL for Function GET_ACC_DEBT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_DEBT" 
(
  A#NUM IN VARCHAR2 
) RETURN NUMBER AS 
a#dolg number;
a#account_id number;
a#open_mn  number; 
BEGIN

  a#dolg := 0;
  select fcr.p#utils.get#OPEN_MN  into a#open_mn from dual;
  select c#id into a#account_id from fcr.t#account where  c#num = a#num;
  select
    round(SUM(NVL(c.c#Sum,0)) - SUM(NVL(op.p#Sum,0)),2) into a#dolg
  FROM 
  (SELECT  SUM(NVL(c#sum,0)) AS c#sum  FROM fcr.t#charge  
              where c#account_id = a#account_id
              and c#a_mn < a#open_mn ) c, 
  (SELECT  SUM(NVL(c#sum,0)) AS p#sum  FROM fcr.v#op  
              where c#account_id = a#account_id
              and c#a_mn < a#open_mn ) op; 
  RETURN a#dolg;
  
END GET_ACC_DEBT;

/
--------------------------------------------------------
--  DDL for Function GET_ACC_FOR_PAY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_FOR_PAY" (A#N varchar2, A#M_DATE date) return NUMBER is
flg number;
res  NUMBER;
begin
if substr(upper(trim(A#N)),1,3) = '444' then flg := 1; else flg:= 0; end if;
select max(A.C#ID) into res
  from T#ACCOUNT A, T#ACCOUNT_VD A_VD
      ,T#ACCOUNT_OP OP
 where 1 = 1
   and ((A.C#NUM = A#N and flg = 1)
     or (OP.C#OUT_NUM = A#N and flg = 0)
       )
   and A.C#DATE <= last_day(A#M_DATE)
   and A_VD.C#ID = A.C#ID
   and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
   and A_VD.C#VALID_TAG = 'Y'
   and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
   and OP.C#ACCOUNT_ID = A.C#ID
   and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)
  ;
 return res;
end;

/
--------------------------------------------------------
--  DDL for Function GET_ACC_FOR_PAY_ANY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_FOR_PAY_ANY" (A#N varchar2, A#M_DATE date) return NUMBER is
flg number;
res number;
res1  NUMBER;
res2  NUMBER;
res3  NUMBER;

begin
if substr(upper(trim(A#N)),1,3) = '444' then flg := 1; else flg:= 0; end if;

select max(A.C#ID) into res1
  from T#ACCOUNT A, T#ACCOUNT_VD A_VD
      ,T#ACCOUNT_OP OP
 where 1 = 1
   and ((A.C#NUM = A#N and flg = 1)
     or (OP.C#OUT_NUM = A#N and flg = 0)
       )
   and A.C#DATE <= last_day(A#M_DATE)
   and A_VD.C#ID = A.C#ID
   and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
   and A_VD.C#VALID_TAG = 'Y'
--   and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
   and OP.C#ACCOUNT_ID = A.C#ID
   and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)
  ;

if res1 is not null then res:= res1;
else 

    select max(A.C#ID) into res2
      from T#ACCOUNT A, T#ACCOUNT_VD A_VD
          ,T#ACCOUNT_OP OP
     where 1 = 1
       and ((A.C#NUM = A#N and flg = 1)
         or (OP.C#OUT_NUM = A#N and flg = 0)
           )
 --      and A.C#DATE <= last_day(A#M_DATE)
       and A_VD.C#ID = A.C#ID
       and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
       and A_VD.C#VALID_TAG = 'Y'
    --   and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
       and OP.C#ACCOUNT_ID = A.C#ID
--       and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)
      ;
res := res2;
end if;
 return res;
end;

/
--------------------------------------------------------
--  DDL for Function GET_ACC_FOR_PAY_TTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_ACC_FOR_PAY_TTER" (A#N varchar2, A#M_DATE date) return NUMBER is
res number;
res3  NUMBER;
res4 number;
begin
    select max(A.C#ID) into res3
      from T#ACCOUNT A, T#ACCOUNT_VD A_VD
          ,T#ACCOUNT_OP OP

     where 1 = 1
       and A.C#DATE <= last_day(A#M_DATE)
       and OP.C#OUT_NUM = 
       
       
       (
          select max((select max(op.c#out_num)
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )) 
            from fcr2.full_pay_4 fp
           where 1 = 1
             and fp.ls = A#N
             and fp.acc_id is null and fp.acc_id_close is null
             and fp.cod_rkc in (51, 52)
             and exists (select 1
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )
             and length(fp.ls) > 8
             and (select count(op.c#out_num)
                    from fcr.t#account_op op
                   where 1 = 1 
                     and op.c#out_num like '%'||fp.ls
                     and op.c#out_proc_id = 2
                  ) = 1
          ) 
       and A_VD.C#ID = A.C#ID
       and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
       and A_VD.C#VALID_TAG = 'Y'
       and OP.C#ACCOUNT_ID = A.C#ID
       and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
       and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)

      ;

if res3 is not null then res:= res3;
else 

    select max(A.C#ID) into res4
      from T#ACCOUNT A, T#ACCOUNT_VD A_VD
          ,T#ACCOUNT_OP OP
         
     where 1 = 1
--       and A.C#DATE <= last_day(A#M_DATE)
       and OP.C#OUT_NUM = 
       
       
       (
          select max((select max(op.c#out_num)
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )) 
            from fcr2.full_pay_4 fp
           where 1 = 1
             and fp.ls = A#N
             and fp.acc_id is null and fp.acc_id_close is null
             and fp.cod_rkc in (51, 52)
             and exists (select 1
                           from fcr.t#account_op op
                          where 1 = 1 
                            and op.c#out_num like '%'||fp.ls
                            and op.c#out_proc_id = 2
                        )
             and length(fp.ls) > 8
             and (select count(op.c#out_num)
                    from fcr.t#account_op op
                   where 1 = 1 
                     and op.c#out_num like '%'||fp.ls
                     and op.c#out_proc_id = 2
                  ) = 1
          ) 
       
       and A_VD.C#ID = A.C#ID
       and A_VD.C#VN = (select max(C#VN) from T#ACCOUNT_VD where C#ID = A_VD.C#ID)
       and A_VD.C#VALID_TAG = 'Y'
       and OP.C#ACCOUNT_ID = A.C#ID
--       and (A_VD.C#END_DATE is null or A_VD.C#END_DATE >= greatest(A.C#DATE,A#M_DATE))
--       and OP.C#DATE = (select max(C#DATE) from T#ACCOUNT_OP where C#ACCOUNT_ID = OP.C#ACCOUNT_ID and C#DATE <= A#M_DATE)

      ;
res:= res4;
end if;
 return res;
end;

/
--------------------------------------------------------
--  DDL for Function GET_CURRENT_USER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_CURRENT_USER" RETURN NUMBER AS 
   ret_id number;
BEGIN
  select user_id into ret_id from Dba_users where username = user;
  RETURN ret_id;
END GET_CURRENT_USER;

/
--------------------------------------------------------
--  DDL for Function GET_DATE_CLOSE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_DATE_CLOSE" 
(
  A#NUM IN VARCHAR2 
) RETURN VARCHAR2 AS 
a#ret_num VARCHAR2(10);
BEGIN
  select nvl(to_char(ta.c#end_date),'') into a#ret_num from fcr.v#account ta inner join fcr.t#account_op taop on (ta.c#id = taop.c#account_id)
  where taop.c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id) 
  and c#out_num = a#num;
  RETURN nvl(a#ret_num,' ');
  exception
  when OTHERS then 
  RETURN ' ';
END GET_DATE_CLOSE;

/
--------------------------------------------------------
--  DDL for Function GET_FIRST_UNPAID_KVIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_FIRST_UNPAID_KVIT" (A#N number, A#MN_LO number, A#MN_OPEN number :=null) return NUMBER is
res number;
OPEN_MN number;
begin

select max(v.C#MN) into OPEN_MN 
  from v#close v
 where 1 = 1
   and v.C#VALID_TAG = 'Y'
;

select min(c.C#B_MN) into res
  from fcr.v#chop c
 where 1 = 1
   and c.C#ACCOUNT_ID = A#N
   and c.C#B_MN >= A#MN_LO
   and c.C#B_MN <= nvl(A#MN_OPEN, OPEN_MN)
   and fcr.get_paid_kvit(c.C#ACCOUNT_ID, c.C#B_MN, 1) in (2, 3, 4, 5, 6, 7)
;
 return res;
end;

/
--------------------------------------------------------
--  DDL for Function GET_INNER_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_INNER_NUMBER" 
(
  A#NUM IN VARCHAR2 
) RETURN VARCHAR2 AS 
a#ret_num varchar2(30);
BEGIN
  select c#num into a#ret_num from fcr.t#account ta inner join fcr.t#account_op taop on (ta.c#id = taop.c#account_id)
  where taop.c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id) 
  and c#out_num = a#num;
  RETURN a#ret_num;
END GET_INNER_NUMBER;

/
--------------------------------------------------------
--  DDL for Function GET_NEW_RKC_DATE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_NEW_RKC_DATE" (p_ACC_ID NUMBER, p_DATE DATE) return DATE as
    ND DATE;
begin
    select
        max(DD)
    into ND    
    from
        (SELECT
                TO_DATE('01.06.2014','dd.mm.yyyy') + level - 1 DD
            FROM
                dual
            CONNECT BY
                level <= p_DATE-TO_DATE('01.06.2014','dd.mm.yyyy') + 1
        )
    where
        DD not in (select C#DATE from T#ACCOUNT_OP where T#ACCOUNT_OP.C#ACCOUNT_ID = p_ACC_ID)
    ;    
    return ND;
end GET_NEW_RKC_DATE;


/
--------------------------------------------------------
--  DDL for Function GET_OUTER_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_OUTER_NUMBER" 
(
  A#NUM IN VARCHAR2 
) RETURN VARCHAR2 AS 
a#ret_num varchar2(30);
BEGIN
  select c#out_num into a#ret_num from fcr.t#account ta inner join fcr.t#account_op taop on (ta.c#id = taop.c#account_id)
  where taop.c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id)
  and c#num = a#num;
  
  RETURN a#ret_num;
END GET_OUTER_NUMBER;

/
--------------------------------------------------------
--  DDL for Function GET_PAID_KVIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_PAID_KVIT" (A#N number, A#MN number, A#FLG number:= 1) return NUMBER is
--A#FLG   1-по квитанции, -2 по объему, любая другая по charge
-- такой набор полей для определения в какую квитанцию засовывать перерасчет
-- недоплачена > 0 (2, 3, 4, 5, 6, 7)
-- переплачена или к оплате 0 (-6, -5, -4, -3, -2, -1, 0, 1, 10, 20, 30)
-- такой набор полей для определения в какую квитанцию засовывать перерасчет

--набор для определения можно ли пересчитывать квитанцию или нет
-- неоплачена или недоплачена > 0 (0, 1, 2, 3, 4, 5, 6, 7)
-- переплачена или к оплате 0 (-6, -5, -4, -3, -2, -1, 10, 20, 30)
--набор для определения можно ли пересчитывать квитанцию или нет

--не трогаем при простановке оплат (10,20,30)

res number;

begin
select
       max(coalesce(case when a.to_pay is null and a.pay is null then 0 else null end,--Нулевая неоплаченная квитанция без начислений
                case when a.to_pay is not null and a.to_pay = 0 and a.pay is null then 1 else null end, --Нулевая неоплаченная квитанция
                case when a.to_pay is not null and a.to_pay < 0 and a.pay is null then -1 else null end, --Отрицательная неоплаченная квитанция
                case when a.to_pay is not null and a.to_pay > 0 and a.pay is null then 2 else null end, --Положительная неоплаченная квитанция
                case when nvl(a.to_pay,0) = 0  and a.pay is not null and a.pay = 0 then 10 else null end, --Нулевая оплаченная квитанция
                case when nvl(a.to_pay,0) = 0  and a.pay is not null and a.pay > 0 then -2 else null end, --Нулевая переплаченная квитанция
                case when nvl(a.to_pay,0) = 0  and a.pay is not null and a.pay < 0 then 3 else null end, --Нулевая квитанция c минусовой оплатой (недоплачена)

                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay < 0 and a.to_pay-a.pay = 0 then 20 else null end, --Полностью оплаченная квитанция с отрицательной суммой к оплате по начислению
                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay < 0 and a.to_pay-a.pay > 0 then 4 else null end, --Недоплаченная квитанция с отрицательной суммой к оплате по начислению
                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay < 0 and a.to_pay-a.pay < 0 then -3 else null end, --Переплаченная квитанция с отрицательной суммой к оплате по начислению

                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay = 0 then -4 else null end, --Квитанция с отрицательной суммой к оплате по начислению с нулевой оплатой
                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay > 0 then -5 else null end, --Квитанция с отрицательной суммой к оплате по начислению с положительной оплатой

                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay < 0 then 5 else null end, --Недоплаченная квитанция с отрицательной оплатой
                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay = 0 then 6 else null end, --Недоплаченная квитанция с нулевой оплатой

                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay > 0 and a.to_pay-a.pay < 0 then -6 else null end, --Переплаченная квитанция
                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay > 0 and a.to_pay-a.pay = 0 then 30 else null end, --Полностью оплаченная квитанция
                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay > 0 and a.to_pay-a.pay > 0 then 7 else null end, --Недоплаченная квитанция с ненулевой оплатой

       100)) as flg into res
       --nvl(a.to_pay,0)-nvl(a.pay,0) as to_pay


  from
(
select case when A#FLG = 1 then ch.C#B_MN else case when A#FLG = 2 then ch.C#A_MN else ch.C#MN end end,
       sum(case when nvl(ch.C#C_SUM,0) = 0 and nvl(ch.C#MC_SUM,0) = 0 and nvl(ch.C#M_SUM,0) = 0 then null else nvl(ch.C#C_SUM,0)+nvl(ch.C#MC_SUM,0)+nvl(ch.C#M_SUM,0)end) to_pay
      ,sum(case when ch.C#MP_SUM is null and ch.C#P_SUM is null then null
                else nvl(ch.C#MP_SUM,0)+nvl(ch.C#P_SUM,0)
                end
          ) pay

--        row_number() over (partition by ch.C#ACCOUNT_ID order by ch.C#MN, ch.C#B_MN, ch.c#work_id, ch.c#doer_id) sort_order


    from fcr.v#chop ch
   where 1 = 1
     and ch.C#ACCOUNT_ID = A#N
     and (
         (ch.C#MN = A#MN and A#FLG > 2)
      or (ch.C#A_MN = A#MN and A#FLG = 2)
      or (ch.C#B_MN = A#MN and A#FLG = 1)
         )
   group by case when A#FLG = 1 then ch.C#B_MN else case when A#FLG = 2 then ch.C#A_MN else ch.C#MN end end
) a;
 return res;
end;

/
--------------------------------------------------------
--  DDL for Function GET#NUMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#NUMBER" (A#NUM varchar2) return number deterministic is
 A#RES number;
begin
 if A#NUM is not null
 then
  declare
   A#L number := length(A#NUM);
   A#I number := 1;
  begin
   loop
    exit when substr(A#NUM,A#I,1) not in ('0','1','2','3','4','5','6','7','8','9');
    A#I := A#I + 1;
    exit when A#I > A#L;
   end loop;
   A#RES := case when A#I > 1 then to_number(substr(A#NUM,1,A#I - 1)) else -1 end;
   if A#I <= A#L
   then
    declare
     A#RES_ADDON number := 0;
    begin
     loop
      A#RES_ADDON := A#RES_ADDON + ascii(substr(A#NUM,A#I,1))*(A#L - A#I + 1)*256;
      A#I := A#I + 1;
      exit when A#I > A#L;
     end loop;
     A#RES := A#RES + 1 - 1/A#RES_ADDON;
    end;
   end if;
  end;
 end if;
 return A#RES;
end;

/
--------------------------------------------------------
--  DDL for Function GET#OUT_NUM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#OUT_NUM" 
(
  A#ADDRESS IN VARCHAR2 
) RETURN VARCHAR2 AS 
ret varchar2(100);
BEGIN
  select c#out_num into ret from fcr.v#account va 
  inner join ( select * from fcr.t#account_op ao where c#date = (select max(c#date) from fcr.t#account_op where c#account_id =  ao.c#account_id)) tao
  on (tao.c#account_id = va.c#id)
  where  va.c#end_date is null and fcr.p#utils.get#rooms_addr(va.c#rooms_id) like A#ADDRESS;
  RETURN nvl(ret,' ');
  exception
  when OTHERS then 
  RETURN ' ';
END GET#OUT_NUM;

/
--------------------------------------------------------
--  DDL for Function GET#SUBSTR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#SUBSTR" 
 (
  A#S varchar2 --source
 ,A#D varchar2 --delim
 ,A#I integer --index (zero-based, negative from right)
 ) return varchar2 deterministic is
 A#P1 integer;
 A#P2 integer;
begin
 case
  when A#I = 0 then
  begin
   A#P1 := 1;
   A#P2 := instr(A#S,A#D,1,1);
   if A#P2 = 0
   then
    A#P2 := length(A#S) + 1;
   end if;
  end;
  when A#I > 0 then
  begin
   A#P1 := instr(A#S,A#D,1,A#I);
   A#P1 := case when A#P1 > 0 then A#P1+length(A#D) end;
   A#P2 := case when A#P1 > 0 then instr(A#S,A#D,A#P1,1) end;
   if A#P2 = 0
   then
    A#P2 := length(A#S) + 1;
   end if;
  end;
  when A#I = -1 then
  begin
   A#P1 := instr(A#S,A#D,-1,1);
   A#P1 := case when A#P1 > 0 then A#P1+length(A#D) else case when A#P1 = 0 then 1 end end;
   A#P2 := length(A#S) + 1;
  end;
  when A#I < -1 then
  begin
   A#P2 := instr(A#S,A#D,-1,abs(A#I)-1);
   A#P1 := case when A#P2 > 0 then instr(A#S,A#D,A#P2-length(A#S)-2,1) end;
   A#P1 := case when A#P1 > 0 then A#P1+length(A#D) else case when A#P1 = 0 then 1 end end;
  end;
  else
   null;
 end case;
 return substr(A#S,A#P1,A#P2-A#P1);
end;

/
--------------------------------------------------------
--  DDL for Function GET#USER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET#USER" (A#USER_ID INTEGER) return SYS_REFCURSOR is
  Result SYS_REFCURSOR;
begin
  open Result for
  select * from all_users where user_id = A#user_id;
  return(Result);
end GET#USER ;

/
--------------------------------------------------------
--  DDL for Function LST#DEBT_OMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#DEBT_OMS" (a#begin date, a#end date) return sys_refcursor is
  Result sys_refcursor;
begin
 open  Result for 
 select 
   p.c#name as "Юридическое лицо",
   COUNT(r.c#id) AS "Счета",
   SUM(NVL(vrs.c#area_val,0)) AS "Площадь",
   SUM(NVL(c.c#Sum,0)) AS "Начислено", 
   SUM(NVL(op.p#Sum,0)) AS "Оплачено",
   SUM(NVL(c.c#Sum,0)) - SUM(NVL(op.p#Sum,0))AS "Долг"
 FROM 
   (select * from fcr.v#account where c#end_date is null and c#valid_tag = 'Y') acc 
    inner join ( select c#account_id,pj.c#name from fcr.v#account_spec a inner join fcr.t#person_j pj on (a.c#person_id = pj.c#person_id) where pj.c#tip_ul = 'OMS') p
    on (p.c#account_id = acc.c#id) 
    INNER JOIN fcr.t#rooms r ON (acc.c#rooms_id = r.c#id) INNER JOIN fcr.v#rooms_spec vrs ON (r.c#id = vrs.c#rooms_id) 
    INNER JOIN fcr.t#house h ON (r.c#house_id = h.c#id) 
    inner join (select c#house_id , c#acc_type  from fcr.v#banking tbo
                    inner join fcr.t#b_account ba
                       on (tbo.c#b_account_id = ba.c#id)) type_Acc
 on (type_acc.c#house_id = h.c#id)
    LEFT Join (SELECT c#account_id,SUM(NVL(c#sum,0)) AS c#sum FROM fcr.t#charge 
       where c#a_mn between fcr.p#mn_utils.GET#MN(a#begin) 
       and fcr.p#mn_utils.GET#MN(a#end) GROUP BY c#account_id ) c ON (acc.c#id = c.c#account_id) 
    LEFT Join (SELECT c#account_id,sum(case when C#TYPE_TAG = 'P' then C#SUM end) AS p#sum FROM fcr.v#op 
       where C#VALID_TAG = 'Y' 
         and c#real_date >= a#begin
         and c#real_date <= a#end
    GROUP BY c#account_id) op ON (acc.c#id = op.c#account_id) 
    WHERE vrs.c#valid_tag = 'Y' and type_acc.c#acc_type in (1,2) 
   group by    p.c#name;
    return(Result);
end LST#DEBT_OMS;

/
--------------------------------------------------------
--  DDL for Function LST#DEBT_RKC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#DEBT_RKC" 
(
 a#date date,
 a#rkc number  --1 МУП ЕРЦ ,2 ТТЭР, 8 ТОСК, 9 Цнинский
) return sys_refcursor is
  Result sys_refcursor;
begin
  open Result for
  Select * from 
 ( select
       t.c#id account_id
      ,t.c#date
      ,t.c#end_date
      ,t.C#LIVING_TAG
      ,t.C#OWN_TYPE_TAG
      ,t.c#area_val
      ,t.oa.f#house_id house_id
      ,t.oa.f#person_id person_id
      ,t.c#out_num out_account_num
      ,t.oa.f#num account_num
      ,p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path 
      ,t.c#house_num
      ,t.c#flat_num
      ,t.room_id
      , p#utils.get#person_name(t.oa.f#person_id) person
      , (select max('Счет юр лица')
           from fcr.t#person_j p
          where p.c#person_id = t.oa.f#person_id
        ) as URFIZ,    
--        case when 
--                 fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) > 0
--             and fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) > se.dolg 
--              then  fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) 
--            when  se.dolg > 0 
--              and fcr.p#utils.GET#DOLG(t.oa.f#person_id, t.room_id, sysdate) <= se.dolg 
--              then  se.dolg 
--            else 0    
--        end 
        fcr.p#web.GET#DOLG(t.c#id) dolg,
        fcr.p#tools.get#count_88(t.c#id) count_88
  from 
(
select a.C#ID
      ,rs.C#LIVING_TAG, rs.C#OWN_TYPE_TAG, rs.C#AREA_VAL, a.c#num
      ,p#utils.get_obj#account(op.c#account_id, a#date) oa
      ,h.c#addr_obj_id
      ,a.c#date
      ,a.C#END_DATE
      ,h.c#num || rtrim('-' || h.c#b_num || '-' || h.c#s_num, '-') c#house_num
      ,r.c#id as room_id
      ,r.c#flat_num
      ,op.c#out_num
      ,op.c#out_proc_id
      ,oo.c#code
  from fcr.t#account_op op,
       fcr.v#account a,
       fcr.v#rooms_spec rs,
       fcr.t#rooms r, 
       fcr.t#house h,
       fcr.t#out_proc oo
 where
   1=1
   and (a.c#end_date is null or a.c#end_date > a#date)
   and op.c#date = (select max(o.c#date)
                      from fcr.t#account_op o
                     where 1 = 1
                       and o.c#account_id = op.c#account_id
                       and o.c#date < a#date
                   )
   and a.c#id = op.c#account_id
   and a.c#date = (select max(a1.c#date)
                      from fcr.v#account a1
                     where 1 = 1
                       and a1.c#id = a.c#id
                       and a1.c#date < a#date
                       and a1.C#VALID_TAG = 'Y'
                   )
   and op.c#out_proc_id in (a#rkc)
   and oo.c#id = op.c#out_proc_id
   and rs.C#ROOMS_ID = a.c#rooms_id
   and rs.C#VALID_TAG = 'Y'
   and a.C#VALID_TAG = 'Y'
   and r.c#id = rs.C#ROOMS_ID
   and r.c#house_id = h.c#id   
   and rs.C#DATE =  (
                     select max(rs1.C#DATE)
                       from fcr.v#rooms_spec rs1
                      where rs1.C#ROOMS_ID = rs.C#ROOMS_ID
                        and rs1.C#DATE < a#date
                    )
) t
--,
-- (
--    select T.C#ACCOUNT_ID
--          ,sum(TT.C#C_SUM) "C#0_C_SUM"
--          ,sum(TT.C#MC_SUM) "C#0_MC_SUM"
--          ,sum(TT.C#M_SUM) "C#0_M_SUM"
--          ,sum(TT.C#MP_SUM) "C#0_MP_SUM"
--          ,sum(TT.C#P_SUM) "C#0_P_SUM"
--          ,SUM(TT.C#FC_SUM) "C#FC_SUM"
--          ,SUM(TT.C#FP_SUM) "C#FP_SUM"
--          ,nvl(sum(TT.C#C_SUM),0)+nvl(sum(TT.C#MC_SUM),0)+nvl(sum(TT.C#M_SUM),0)-nvl(sum(TT.C#MP_SUM),0)-
--           nvl(sum(TT.C#P_SUM),0) as dolg
--      from FCR.T#STORE T, FCR.T#STORAGE TT, FCR.T#ACCOUNT A, FCR.T#ROOMS R
--     where 1 = 1
--       and T.C#MN = FCR.P#MN_UTILS.GET#MN(trunc(add_months(a#date,1),'MM'))
--       and TT.C#ACCOUNT_ID = T.C#ACCOUNT_ID
--       and TT.C#WORK_ID = T.C#WORK_ID
--       and TT.C#DOER_ID = T.C#DOER_ID
--       and TT.C#MN = (select max(C#MN) from FCR.T#STORAGE where C#ACCOUNT_ID = T.C#ACCOUNT_ID and C#WORK_ID = T.C#WORK_ID and C#DOER_ID = T.C#DOER_ID and C#MN <= T.C#MN)
--       and A.C#ID = T.C#ACCOUNT_ID
--       and R.C#ID = A.C#ROOMS_ID
--     group by T.C#ACCOUNT_ID
--     having nvl(sum(TT.C#C_SUM),0)+nvl(sum(TT.C#MC_SUM),0)+nvl(sum(TT.C#M_SUM),0)-nvl(sum(TT.C#MP_SUM),0)-
--            nvl(sum(TT.C#P_SUM),0) < 0
--            
-- ) SE -- сальдо (исходящее) 
-- where t.c#id = se.c#account_id ) tbl 
-- where tbl.dolg > 0;
) tbl
 where tbl.dolg < 0;

  return(Result);
end LST#DEBT_RKC;

/
--------------------------------------------------------
--  DDL for Function LST#GET_PAY_RKC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#GET_PAY_RKC" ( a#date DATE,a#code_rkc NUMBER ) RETURN SYS_REFCURSOR IS
    result   SYS_REFCURSOR;
BEGIN
    OPEN result FOR
        SELECT
            f.c#id,
            t.c#id account_id,
            t.c#date,
            t.c#end_date,
            t.c#living_tag,
            t.c#own_type_tag,
            t.c#area_val,
            t.oa.f#house_id house_id,
            t.oa.f#person_id person_id,
            t.c#out_num out_account_num,
            t.oa.f#num account_num,
            p#utils.get#addr_obj_path(t.c#addr_obj_id) addr_path -- rooms_addr(t.oa.f#rooms_id) address
            ,
            t.c#house_num,
            t.c#flat_num,
            t.room_id,
            p#utils.get#person_name(t.oa.f#person_id) person,
            (
                SELECT
                    MAX('Счет юр лица')
                FROM
                    fcr.t#person_j p
                WHERE
                    p.c#person_id = t.oa.f#person_id
            ) AS urfiz,
            c#out_proc_id,
            c#code,
            f.c#real_date,
            f.c#summa,
            f.c#account,
            f.c#period,
            f.c#cod_rkc,
            f.c#file_id,
            ok.c#name,
            ok.c#cod,
            uk.UK_NAME
        FROM
            (
                SELECT
                    a.c#id,
                    rs.c#living_tag,
                    rs.c#own_type_tag,
                    rs.c#area_val,
                    a.c#num,
                    p#utils.get_obj#account(op.c#account_id,SYSDATE) oa,
                    h.c#addr_obj_id,
                    a.c#date,
                    a.c#end_date,
                    h.c#num
                     || rtrim(
                        '-'
                         || h.c#b_num
                         || '-'
                         || h.c#s_num,
                        '-'
                    ) c#house_num,
                    r.c#id AS room_id,
                    r.c#flat_num,
                    op.c#out_num,
                    op.c#out_proc_id,
                    oo.c#code
                FROM
                    fcr.t#account_op op,
                    fcr.v#account a,
                    fcr.v#rooms_spec rs,
                    fcr.t#rooms r,
                    fcr.t#house h,
                    fcr.t#out_proc oo
                WHERE
                        op.c#date = (
                            SELECT
                                MAX(o.c#date)
                            FROM
                                fcr.t#account_op o
                            WHERE
                                    1 = 1
                                AND
                                    o.c#account_id = op.c#account_id
                                AND
                                    o.c#date < a#date
                        )
                    AND
                        a.c#id = op.c#account_id
                    AND
                        a.c#date = (
                            SELECT
                                MAX(a1.c#date)
                            FROM
                                fcr.v#account a1
                            WHERE
                                    1 = 1
                                AND
                                    a1.c#id = a.c#id
                                AND
                                    a1.c#date < a#date
                                AND
                                    a1.c#valid_tag = 'Y'
                        )
                    AND
                        op.c#out_proc_id IN (
                            a#code_rkc
                        )
                    AND
                        oo.c#id = op.c#out_proc_id
                    AND
                        rs.c#rooms_id = a.c#rooms_id
                    AND
                        rs.c#valid_tag = 'Y'
                    AND
                        a.c#valid_tag = 'Y'
                    AND
                        r.c#id = rs.c#rooms_id
                    AND
                        r.c#house_id = h.c#id
                    AND
                        rs.c#date = (
                            SELECT
                                MAX(rs1.c#date)
                            FROM
                                fcr.v#rooms_spec rs1
                            WHERE
                                    rs1.c#rooms_id = rs.c#rooms_id
                                AND
                                    rs1.c#date < a#date
                        )
            ) t left join V#ERC_ACC_UK_NAMES uk on (t.c#out_num = uk.ACCAUNT_NUM),
            fcr.t#pay_source f,
            fcr.t#ops_kind ok
        WHERE
                coalesce(
                    f.c#acc_id,
                    f.c#acc_id_close,
                    f.c#acc_id_tter
                ) = t.c#id
            AND
                TO_CHAR(t.c#code,'00') <> TO_CHAR(f.c#cod_rkc,'00')
            AND
                f.c#kind_id = ok.c#id
            AND
                ok.c#cod <> '88'
            AND
                f.c#upload_flg IS NULL;

    return(result);
END lst#get_pay_rkc;

/
--------------------------------------------------------
--  DDL for Function LST#PERSON_J_INFO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."LST#PERSON_J_INFO" (A#PERSON_ID integer) return sys_refcursor is
  Result sys_refcursor;
begin
  open Result for 
	select 
   pj.c#name
  ,pj.c#inn_num
  ,pj.c#kpp_num
  ,pj.c#mail
  ,pj.c#tip_ul
  ,pj.c#rayon 
  ,va.c#id acc_id
  ,va.c#num
  ,aop.c#out_num
  ,va.c#date date_begin
  ,va.C#END_DATE date_end
  ,va.c#rooms_id
  ,r.c#house_id
  ,rs.C#LIVING_TAG
  ,rs.C#OWN_TYPE_TAG
  ,rs.C#AREA_VAL
  ,fcr.p#utils.GET#ROOMS_ADDR(va.c#rooms_id) address
  from fcr.v#account va
 inner join fcr.t#account_op aop on (va.c#id = aop.c#account_id)
 inner join fcr.t#rooms r on (r.c#id = va.c#rooms_id)
 inner join fcr.v#rooms_spec rs on (va.c#rooms_id = rs.c#rooms_id)
 inner join fcr.v#account_spec vas on (va.c#id = vas.c#account_id)
 inner join fcr.t#person_j pj on (pj.c#person_id = vas.C#PERSON_ID)
 where pj.c#person_id = a#person_id;

  return(Result);
end LST#PERSON_J_INFO;

/
--------------------------------------------------------
--  DDL for Function TO_NUM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."TO_NUM" (A$VALUE in varchar2) return number deterministic is
 V$R number;
begin
 if A$VALUE is not null
 then
  declare
   V$L number := LENGTH(A$VALUE);
   V$I number := 1;
  begin
   loop
    exit when V$I > V$L or SUBSTR(A$VALUE, V$I, 1) not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
    V$I := V$I + 1;
   end loop;
   if V$I > 1
   then
    V$R := TO_NUMBER(SUBSTR(A$VALUE, 1, V$I - 1));
   else
    V$R := 0;
   end if;
   if V$I <= V$L
   then
    declare
     V$RE number := 0;
    begin
     loop
      exit when V$I > V$L;
      V$RE := V$RE + ASCII(SUBSTR(A$VALUE, V$I, 1));
      V$I := V$I + 1;
     end loop;
     V$R := V$R + 1 - (1 / V$RE);
    end;
   end if;
  end;
 end if;
 return V$R;
end;

/
--------------------------------------------------------
--  DDL for Function UPD#RKC_J
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."UPD#RKC_J" 
(
  A_PERSON_ID IN NUMBER 
, A_RKC_ID IN NUMBER 
, A_DATE IN DATE 
)  return number AS 
a_exist number;
a_id number;
BEGIN
  for r in (select va.c#id c_id, va.c#num from fcr.v#account va inner join fcr.v#account_spec vas on (va.c#id = vas.c#account_id) where c#person_id = a_person_id) loop
     a_id := -1;
     select count(*) into a_exist from fcr.t#account_op taop where taop.c#account_id = r.c_id and c#date = (select max(c#date) from fcr.t#account_op where c#account_id = taop.c#account_id);
     if (a_exist > 0 ) then
        a_id := r.c_id;
        delete from fcr.t#account_op where c#account_id = r.c_id;
     end if;
     fcr.p#fcr.ins#account_op(r.c_id,a_date,a_rkc_id,r.c#num);
    commit;  
   end loop;       
   return 0;
   exception
   when OTHERS then
       rollback;
       return a_id;
END UPD#RKC_J;

/
