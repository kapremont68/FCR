--------------------------------------------------------
--  DDL for Package P#TOTAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#TOTAL" AS 

    
    PROCEDURE UPDATE_TOTAL_HOUSE(p_HOUSE_ID in T#TOTAL_HOUSE.HOUSE_ID%type);
    
    PROCEDURE UPDATE_TOTAL_ACCOUNT(p_ACCOUNT_ID in T#TOTAL_ACCOUNT.ACCOUNT_ID%type);

END P#TOTAL;

/
