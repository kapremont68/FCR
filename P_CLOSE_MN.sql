--------------------------------------------------------
--  DDL for Package P#CLOSE_MN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#CLOSE_MN" 
  IS

  -- Author  : ALEXANDER
  -- Created : 27.10.2016 16:05:18

  -- Purpose : процедуры закрыти€ мес€ца 

  a#err VARCHAR(4000);

  PROCEDURE DO#BALANCE_ACCOUNT;
  PROCEDURE DO#BALANCE_BANK_ACCOUNT;
  PROCEDURE DO#OVERPAYMENT;
  PROCEDURE DO#PAGE_TWO;
  PROCEDURE DO#PAGE_THREE;
  PROCEDURE DO#ALL;

END P#CLOSE_MN;

/
