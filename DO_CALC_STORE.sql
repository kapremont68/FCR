--------------------------------------------------------
--  DDL for Procedure DO#CALC_STORE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."DO#CALC_STORE" (A#A_ID integer, A#MN number) is
  A#NUM  varchar2(20);
  A#LH   varchar2(128);
  ATAB#D TTAB#CS_D;
begin
--  dbms_lock.allocate_unique_autonomous('CALC_STORE#' || A#A_ID, A#LH, 60);
--  if dbms_lock.request(A#LH,
--                       dbms_lock.x_mode,
--                       60 /*dbms_lock.maxwait*/,
--                       true) = 0 then
--    null;
--  else
--    raise_application_error(-20000,
--                            'Ошибка расчёта, ресурс занят.');
--  end if;
  -- begin
  delete from T#STORAGE
   where C#ACCOUNT_ID = A#A_ID
     and C#MN >= A#MN;
  delete from T#STORE
   where C#ACCOUNT_ID = A#A_ID
     and C#MN >= A#MN;
  ATAB#D := P#CS_UTILS.GET_TAB#D(A#A_ID, A#MN);
  if ATAB#D is not null and ATAB#D.count > 0 then
    declare
      A#N_MN number;
    begin
      select min(least(nvl(F#0_MN, F#1_MN), nvl(F#1_MN, F#0_MN))) + 1
        into A#N_MN
        from table(cast(ATAB#D as TTAB#CS_D)) T
       where nvl(F#0_MN, F#1_MN) < A#MN - 1;
      if A#N_MN is not null then
        select c#num into a#num from fcr.t#account where c#id = A#A_ID;
        DO#RECALC_ACCOUNT(a#num, P#MN_UTILS.GET#DATE(A#N_MN));
      
        raise_application_error(-20000,
                                'DO#CALC_STORE: Ошибка расчёта, требуется последовательный расчёт с "' ||
                                to_char(P#MN_UTILS.GET#DATE(A#N_MN),
                                        'mm.yyyy') || '". ACCOUNT_NUM = '||a#num);
      end if;
    end;
    insert into T#STORE
      (C#ID, C#ACCOUNT_ID, C#WORK_ID, C#DOER_ID, C#MN)
      select S#STORE.nextval, A#A_ID, F#WORK_ID, F#DOER_ID, A#MN
        from table(cast(ATAB#D as TTAB#CS_D)) T
       where nvl(F#0_MN, F#1_MN) = A#MN - 1;
    insert into T#STORAGE
      (C#ACCOUNT_ID,
       C#WORK_ID,
       C#DOER_ID,
       C#MN,
       C#C_VOL,
       C#C2_VOL,
       C#C_SUM,
       C#C2_SUM,
       C#MC_SUM,
       C#M_SUM,
       C#MP_SUM,
       C#P_SUM,
       C#FC_SUM,
       C#FP_SUM)
      select A#A_ID,
             F#WORK_ID,
             F#DOER_ID,
             A#MN,
             nvl(T.FOBJ#0_A.F#C_VOL, 0) + nvl(T.FOBJ#1_A.F#C_VOL, 0),
             nvl(T.FOBJ#0_A.F#C2_VOL, 0) + nvl(T.FOBJ#1_A.F#C2_VOL, 0),
             nvl(T.FOBJ#0_A.F#C_SUM, 0) + nvl(T.FOBJ#1_A.F#C_SUM, 0),
             nvl(T.FOBJ#0_A.F#C2_SUM, 0) + nvl(T.FOBJ#1_A.F#C2_SUM, 0),
             nvl(T.FOBJ#0_A.F#MC_SUM, 0) + nvl(T.FOBJ#1_A.F#MC_SUM, 0),
             nvl(T.FOBJ#0_A.F#M_SUM, 0) + nvl(T.FOBJ#1_A.F#M_SUM, 0),
             nvl(T.FOBJ#0_A.F#MP_SUM, 0) + nvl(T.FOBJ#1_A.F#MP_SUM, 0),
             nvl(T.FOBJ#0_A.F#P_SUM, 0) + nvl(T.FOBJ#1_A.F#P_SUM, 0),
             nvl(T.FOBJ#0_A.F#FC_SUM, 0) + nvl(T.FOBJ#1_A.F#FC_SUM, 0),
             nvl(T.FOBJ#0_A.F#FP_SUM, 0) + nvl(T.FOBJ#1_A.F#FP_SUM, 0)
        from table(cast(ATAB#D as TTAB#CS_D)) T
       where nvl(F#0_MN, F#1_MN) = A#MN - 1
         and F#TAG > 1;
  end if;
  -- exception
  --  when others then
  --   raise;
  -- end;
end;

/
