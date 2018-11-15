--------------------------------------------------------
--  DDL for Package P#BANKEXP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#BANKEXP" AS 

-- ����� ������� �� ����� ��� ����� ������� �� ����
    FUNCTION GET#PAY_WITOUT_BARTER(p_T#B_ACCOUNT_ID NUMBER, p_DATE DATE DEFAULT sysdate) RETURN NUMBER;

-- ����� ����������� �� �������� �� ����
    FUNCTION GET#SPEC_TRANSFER(p_T#B_ACCOUNT_ID NUMBER, p_DATE DATE DEFAULT sysdate) RETURN NUMBER;
    
-- ����� ����������� �� ����� �� ����
    FUNCTION GET#KOTEL_TRANSFER(p_DATE DATE DEFAULT sysdate) RETURN NUMBER;


END P#BANKEXP;

/
