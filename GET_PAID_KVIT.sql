--------------------------------------------------------
--  DDL for Function GET_PAID_KVIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_PAID_KVIT" (A#N number, A#MN number, A#FLG number:= 1) return NUMBER is
--A#FLG   1-�� ���������, -2 �� ������, ����� ������ �� charge
-- ����� ����� ����� ��� ����������� � ����� ��������� ���������� ����������
-- ����������� > 0 (2, 3, 4, 5, 6, 7)
-- ����������� ��� � ������ 0 (-6, -5, -4, -3, -2, -1, 0, 1, 10, 20, 30)
-- ����� ����� ����� ��� ����������� � ����� ��������� ���������� ����������

--����� ��� ����������� ����� �� ������������� ��������� ��� ���
-- ���������� ��� ����������� > 0 (0, 1, 2, 3, 4, 5, 6, 7)
-- ����������� ��� � ������ 0 (-6, -5, -4, -3, -2, -1, 10, 20, 30)
--����� ��� ����������� ����� �� ������������� ��������� ��� ���

--�� ������� ��� ����������� ����� (10,20,30)

res number;

begin
select
       max(coalesce(case when a.to_pay is null and a.pay is null then 0 else null end,--������� ������������ ��������� ��� ����������
                case when a.to_pay is not null and a.to_pay = 0 and a.pay is null then 1 else null end, --������� ������������ ���������
                case when a.to_pay is not null and a.to_pay < 0 and a.pay is null then -1 else null end, --������������� ������������ ���������
                case when a.to_pay is not null and a.to_pay > 0 and a.pay is null then 2 else null end, --������������� ������������ ���������
                case when nvl(a.to_pay,0) = 0  and a.pay is not null and a.pay = 0 then 10 else null end, --������� ���������� ���������
                case when nvl(a.to_pay,0) = 0  and a.pay is not null and a.pay > 0 then -2 else null end, --������� ������������� ���������
                case when nvl(a.to_pay,0) = 0  and a.pay is not null and a.pay < 0 then 3 else null end, --������� ��������� c ��������� ������� (�����������)

                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay < 0 and a.to_pay-a.pay = 0 then 20 else null end, --��������� ���������� ��������� � ������������� ������ � ������ �� ����������
                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay < 0 and a.to_pay-a.pay > 0 then 4 else null end, --������������� ��������� � ������������� ������ � ������ �� ����������
                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay < 0 and a.to_pay-a.pay < 0 then -3 else null end, --������������� ��������� � ������������� ������ � ������ �� ����������

                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay = 0 then -4 else null end, --��������� � ������������� ������ � ������ �� ���������� � ������� �������
                case when nvl(a.to_pay,0) < 0  and a.pay is not null and a.pay > 0 then -5 else null end, --��������� � ������������� ������ � ������ �� ���������� � ������������� �������

                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay < 0 then 5 else null end, --������������� ��������� � ������������� �������
                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay = 0 then 6 else null end, --������������� ��������� � ������� �������

                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay > 0 and a.to_pay-a.pay < 0 then -6 else null end, --������������� ���������
                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay > 0 and a.to_pay-a.pay = 0 then 30 else null end, --��������� ���������� ���������
                case when nvl(a.to_pay,0) > 0  and a.pay is not null and a.pay > 0 and a.to_pay-a.pay > 0 then 7 else null end, --������������� ��������� � ��������� �������

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
