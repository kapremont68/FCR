CREATE OR REPLACE PACKAGE       "P#WEB" AS 

-- ���������� ����� �������� (� ����������� ������) ��� ��������� ���� � ����(����� ������)
 FUNCTION GET#SUM_FOR_HOUSE_DATE(a#house_id NUMBER, a#date DATE) RETURN NUMBER;

-- ���������� ���� ��� ��������� ���� � �������
-- FUNCTION GET#PENI_FOR_HOUSE_PERIOD(a#house_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ���� ��� ��������� ����� � �������
-- FUNCTION GET#PENI_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ���������� ��� ��������� ����� �� ������
 FUNCTION GET#CHARGE_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ������� ��� ��������� ����� �� ������
 FUNCTION GET#PAY_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER;

-- ���������� ������� ����
 FUNCTION GET#DOLG(a#acc_id NUMBER) RETURN NUMBER;
 
-- ���������� ���������� ��� ��������� ����� � ������ �� �������� (�������) �����
 FUNCTION GET#CHARGE_FOR_DOLG(a#acc_id NUMBER) RETURN NUMBER;

END P#WEB;
/


CREATE OR REPLACE PACKAGE BODY       "P#WEB" AS

-- ���������� ����� �������� (� ����������� ������) ��� ��������� ���� � MN
    FUNCTION GET#SUM_FOR_HOUSE_DATE(a#house_id NUMBER, a#date DATE) RETURN NUMBER IS
      OUT_SUM NUMBER;
      a#mn NUMBER;
    BEGIN
    a#mn := P#MN_UTILS.GET#MN(a#date);
    select MAX(C#C_SUM) 
    into OUT_SUM
    from T#B_STORAGE where C#HOUSE_ID = a#house_id and c#MN <= a#mn;     
    RETURN NVL(OUT_SUM,0);
    END GET#SUM_FOR_HOUSE_DATE;

-- ���������� ���� ��� ��������� ���� � ��������� MN��
--  FUNCTION GET#PENI_FOR_HOUSE_PERIOD(a#house_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER AS
--    OUT_PENI NUMBER;
--    a#mn_beg NUMBER;
--    a#mn_end NUMBER;
--  BEGIN
--    a#mn_beg := P#MN_UTILS.GET#MN(a#date_beg);
--    a#mn_end := P#MN_UTILS.GET#MN(a#date_end);
--    SELECT SUM(NVL(C#PENI,0))
--    INTO OUT_PENI
--    FROM TT#PENI_HOUSE
--    WHERE
--        C#HOUSE_ID = a#house_id
--        AND C#A_MN BETWEEN a#mn_beg AND a#mn_end;
--    RETURN NVL(OUT_PENI,0);
--  END GET#PENI_FOR_HOUSE_PERIOD;

-- ���������� ���������� ��� ��������� ����� �� ������
  FUNCTION GET#CHARGE_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER AS
    OUT_SUM NUMBER;
    a#mn_beg NUMBER;
    a#mn_end NUMBER;
  BEGIN
    a#mn_beg := P#MN_UTILS.GET#MN(a#date_beg);
    a#mn_end := P#MN_UTILS.GET#MN(a#date_end);
    select SUM(C#SUM)
    into OUT_SUM
    from T#CHARGE
    where
        C#ACCOUNT_ID = a#acc_id
        and C#A_MN BETWEEN a#mn_beg AND a#mn_end;
    RETURN NVL(OUT_SUM,0);
  END GET#CHARGE_FOR_ACC_PERIOD;

-- ���������� ���� ��� ��������� ����� � �������
--  FUNCTION GET#PENI_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER AS
--    OUT_PENI NUMBER;
--  BEGIN
--    SELECT SUM(NVL(C#PENI,0))
--    INTO OUT_PENI
--    FROM TT#PENI_ACC
--    WHERE
--        C#ACCOUNT_ID = a#acc_id
--        AND C#REAL_DATE BETWEEN a#date_beg AND a#date_end;
--    RETURN NVL(OUT_PENI,0);
--  END GET#PENI_FOR_ACC_PERIOD;

-- ���������� ������� ��� ��������� ����� �� ������
  FUNCTION GET#PAY_FOR_ACC_PERIOD(a#acc_id NUMBER, a#date_beg DATE, a#date_end DATE) RETURN NUMBER AS
      OUT_SUM NUMBER;
  BEGIN
    select SUM(C#SUM)
    into OUT_SUM
    from v#op
    where
        C#ACCOUNT_ID = a#acc_id
        and C#REAL_DATE BETWEEN a#date_beg AND a#date_end;
    RETURN NVL(OUT_SUM,0);
  END GET#PAY_FOR_ACC_PERIOD;

-- ���������� ������� ����
  FUNCTION GET#DOLG(a#acc_id NUMBER) RETURN NUMBER AS
    CHARGE_SUM NUMBER;
    PAY_SUM NUMBER;
    DOLG_SUM NUMBER;
  BEGIN
    CHARGE_SUM := GET#CHARGE_FOR_DOLG(a#acc_id);
    PAY_SUM := GET#PAY_FOR_ACC_PERIOD(a#acc_id,to_date('01.06.2014','dd.mm.yyyy'), sysdate);
    DOLG_SUM := CHARGE_SUM-PAY_SUM;
    RETURN DOLG_SUM;
  END GET#DOLG;

-- ���������� ���������� ��� ��������� ����� � ������ �� �������� (�������) �����
  FUNCTION GET#CHARGE_FOR_DOLG(a#acc_id NUMBER) RETURN NUMBER AS
    OUT_SUM NUMBER;
  BEGIN
    select SUM(C#SUM)
    into OUT_SUM
    from T#CHARGE
    where
        C#ACCOUNT_ID = a#acc_id
        and C#A_MN BETWEEN P#MN_UTILS.GET#MN(to_date('01.06.2014','dd.mm.yyyy')) AND (P#MN_UTILS.GET#MN(sysdate)-1);
    RETURN NVL(OUT_SUM,0);
  END GET#CHARGE_FOR_DOLG;

END P#WEB;
/
