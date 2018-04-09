--------------------------------------------------------
--  DDL for Package P#RECALC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#RECALC" AS 

-- ����-�������� �����
    PROCEDURE FORCE_RECALC_ACC(p_ACC_ID NUMBER, p_RECALC_HOUSE VARCHAR2 DEFAULT 'Y');

-- ����-�������� ���� ������ ���� + ���������� ������ ����
    PROCEDURE FORCE_RECALC_HOUSE(p_HOUSE_ID NUMBER);
    
    
    PROCEDURE RESET_PAY_SOURCE_FOR_ACC(p_ACC_ID NUMBER);
    

END P#RECALC;

/
