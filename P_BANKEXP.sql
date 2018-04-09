--------------------------------------------------------
--  DDL for Package P#BANKEXP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#BANKEXP" AS 

-- всего собрали по счету без учета зачетов на дату
    FUNCTION GET#PAY_WITOUT_BARTER(p_T#B_ACCOUNT_ID NUMBER, p_DATE DATE DEFAULT sysdate) RETURN NUMBER;

-- всего перечислено на спецсчет на дату
    FUNCTION GET#SPEC_TRANSFER(p_T#B_ACCOUNT_ID NUMBER, p_DATE DATE DEFAULT sysdate) RETURN NUMBER;
    
-- всего перечислено на котел на дату
    FUNCTION GET#KOTEL_TRANSFER(p_DATE DATE DEFAULT sysdate) RETURN NUMBER;


END P#BANKEXP;

/
