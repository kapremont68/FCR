--------------------------------------------------------
--  DDL for Package P#GIS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#GIS" AS 

    function GET#HOUSE_ADDR_GIS(A#H_ID number) return varchar2;
    
    function GET#HOUSE_ADDR_GIS_LIKE(A#H_ID number) return varchar2;
    
    function GET#ACC_TYPE_BY_HOUSE_ID(p_HOUSE_ID number) return number;
    
    FUNCTION GET#ADRES_BY_FIAS_HOUSEGUID(p_HOUSEGUID varchar2) RETURN varchar2;
    
    FUNCTION GET#ADRES_BY_FIAS_AOGUID(p_AOGUID varchar2) RETURN varchar2;
    
    FUNCTION GET#FIAS_HOUSEGUID_BY_AOGUID(p_AOGUID varchar2, p_H_NUM VARCHAR2) RETURN varchar2;
    
    FUNCTION GET#GIS_HOUSEGUID_BY_HOUSE_ID(p_HOUSE_ID number) RETURN varchar2;
    
    --  FUNCTION GET#GIS_HOUSEGUID_BY_ADDR(p_ADDR varchar2) RETURN varchar2;
    
    --  FUNCTION GET#GIS_HOUSEGUID_BY_ADDR_LIKE(p_ADDR varchar2) RETURN varchar2;
    
    FUNCTION get#house_addr_like ( a#h_id   NUMBER ) RETURN VARCHAR2;
    
    --  function GET#HOUSE_ADDR_BY_FIAS_GUID(A#FIAS_GUID varchar2) return varchar2;


    type t_gis_charge is record
     (
      PERIOD varchar2(20),
      ACCOUNT_ID INTEGER,
      GKU_ID varchar2(20),
      CHARGE_MN number(15,2),
      DOLG number(15,2),
      AVANS NUMBER(15,2),
      BIC_NUM varchar2(20),
      BANK_ACC_NUM varchar2(20),
      TARIF number(15,2)
     );
     
     
    type t_gis_charge_table is table of t_gis_charge;

    FUNCTION LST#CHARGE_FOR_PERIOD(p_PERIOD varchar2) RETURN t_gis_charge_table pipelined; -- p_PERIOD вида '12.2017'


    type t_gis_fond_size is record
     (
        HOUSE_ID INTEGER
        ,ACCOUNT_ID INTEGER
        ,MIN_MN INTEGER
        ,MAX_MN INTEGER
        ,ADDR VARCHAR2(100)
        ,FIAS_GUID VARCHAR2(100)
        ,OKTMO NUMBER(10,0)
        ,PERIOD VARCHAR2(20)
        ,BEGIN_PAY_SUM_HOUSE NUMBER(15,2)
        ,END_PAY_SUM_HOUSE NUMBER(15,2)
        ,PERIOD_JOB_SUM_HOUSE NUMBER(15,2)
        ,DOLG_JOB_SUM_HOUSE NUMBER(15,2)
        ,GKU_ID VARCHAR2(20)
        ,BEGIN_PAY_SUM_ACC NUMBER(15,2)
        ,PERIOD_CHARGE_SUM_ACC NUMBER(15,2)
        ,PERIOD_CHARGE_PENI_SUM_ACC NUMBER(15,2)
        ,PERIOD_PAY_SUM_ACC NUMBER(15,2)
        ,PERIOD_PAY_PENI_SUM_ACC NUMBER(15,2)
        ,END_PAY_SUM_ACC NUMBER(15,2)
     );
     
     
    type t_gis_fond_size_table is table of t_gis_fond_size;


    FUNCTION LST#FOND_SIZE_FOR_PERIOD(p_PERIOD varchar2) RETURN t_gis_fond_size_table pipelined; -- p_PERIOD вида '01.01.2017'
    
    FUNCTION GET#DOLG(a#acc_id NUMBER, a#MN NUMBER, a#DATE DATE) RETURN NUMBER;

END P#GIS;

/
