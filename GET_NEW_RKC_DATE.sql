--------------------------------------------------------
--  DDL for Function GET_NEW_RKC_DATE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FCR"."GET_NEW_RKC_DATE" (p_ACC_ID NUMBER, p_DATE DATE) return DATE as
    ND DATE;
begin
    select
        max(DD)
    into ND    
    from
        (SELECT
                TO_DATE('01.06.2014','dd.mm.yyyy') + level - 1 DD
            FROM
                dual
            CONNECT BY
                level <= p_DATE-TO_DATE('01.06.2014','dd.mm.yyyy') + 1
        )
    where
        DD not in (select C#DATE from T#ACCOUNT_OP where T#ACCOUNT_OP.C#ACCOUNT_ID = p_ACC_ID)
    ;    
    return ND;
end GET_NEW_RKC_DATE;


/
