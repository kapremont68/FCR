--------------------------------------------------------
--  DDL for Procedure DO#CALC_CHARGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CALC_CHARGE" 
 (
  A#A_ID integer
 ,A#MN number
 ,A#B_MN number
 ,A#C_MN number
 ,A#SKIP_ZEROS number := null
 ) is
 A#LH varchar2(128);
 AOBJ#AD TOBJ#CC_AD;
begin
 dbms_lock.allocate_unique_autonomous('CALC_CHARGE#'||A#A_ID||';'||A#MN, A#LH, 60);
 if dbms_lock.request(A#LH, dbms_lock.x_mode, 120/*dbms_lock.maxwait*/, true) = 0
 then
  null;
 else
  raise_application_error(-20000,'Ошибка расчёта, ресурс занят.');
 end if;
-- begin
  delete
    from T#CHARGE
   where C#ACCOUNT_ID = A#A_ID
     and C#MN = A#C_MN
     and C#A_MN = A#MN
     and C#B_MN = A#B_MN
  ;
--  if P#CC_UTILS.GET#AD_INITED(A#A_ID, A#MN, AOBJ#AD) and AOBJ#AD.FTAB#D.count > 0
--  then
   declare
    ATAB#DVS TTAB#CC_DVS := P#CC_UTILS.GET_TAB#DVS(A#A_ID, A#MN, AOBJ#AD, AOBJ#AD.FTAB#D);
   begin

   insert into T#CHARGE (C#ID, C#ACCOUNT_ID, C#WORK_ID, C#DOER_ID, C#MN, C#A_MN, C#B_MN, C#VOL, C#SUM)
   select S#CHARGE.nextval
          ,A#A_ID
          ,C#WORK_ID
          ,C#DOER_ID
          ,A#C_MN
          ,A#MN
          ,A#B_MN
          ,nvl(C#VOL,0)
          ,nvl(C#SUM,0)
      from (
            select C#WORK_ID
                  ,C#DOER_ID
                  ,sum(C#VOL) "C#VOL"
                  ,sum(C#SUM) "C#SUM"
              from (
                    select C.C#WORK_ID
                          ,C.C#DOER_ID
                          ,-1*C.C#VOL "C#VOL"
                          ,-1*C.C#SUM "C#SUM"
                      from T#CHARGE C
                     where 1 = 1
                       and C.C#ACCOUNT_ID = A#A_ID
                       and C.C#A_MN = A#MN
                    union all
                    select /*+ cardinality (T 10)*/
                           T.FOBJ#D.F#WORK_ID
                          ,T.FOBJ#D.F#DOER_ID
                          ,T.FOBJ#DV.F#VOL
                          ,T.FOBJ#DS.F#SUM
                      from table(cast(ATAB#DVS as TTAB#CC_DVS)) T
                   )
             group by
                   C#WORK_ID
                  ,C#DOER_ID
           )
     where C#VOL <> 0 or C#SUM <> 0 or (A#SKIP_ZEROS is null and A#MN = A#B_MN and A#MN = A#C_MN) or A#SKIP_ZEROS = 0
   ;
   end;
--  end if;
-- exception
--  when others then
--   raise;
-- end;
end;

/
