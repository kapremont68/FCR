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
