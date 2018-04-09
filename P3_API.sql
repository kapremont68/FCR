--------------------------------------------------------
--  DDL for Package P3#API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P3#API" 
IS
  -- insert
  FUNCTION contract_type_ins(
      p_C#NAME IN T3_CONTRACT_TYPE.C#NAME%type DEFAULT NULL ) RETURN NUMBER;
  -- update
  PROCEDURE contract_type_upd(
      p_C#ID   IN T3_CONTRACT_TYPE.C#ID%type ,
      p_C#NAME IN T3_CONTRACT_TYPE.C#NAME%type DEFAULT NULL );
  -- delete
  PROCEDURE contract_type_del(
      p_C#ID IN T3_CONTRACT_TYPE.C#ID%type );


  -- insert
  FUNCTION pay_type_ins(
      p_C#NAME IN T3_PAY_TYPE.C#NAME%type DEFAULT NULL ) RETURN NUMBER;
  -- update
  PROCEDURE pay_type_upd(
      p_C#ID   IN T3_PAY_TYPE.C#ID%type ,
      p_C#NAME IN T3_PAY_TYPE.C#NAME%type DEFAULT NULL );
  -- delete
  PROCEDURE pay_type_del(
      p_C#ID IN T3_PAY_TYPE.C#ID%type );



--  -- insert
--  FUNCTION job_type_ins(
--      p_C#NAME IN T3_JOB_TYPE.C#NAME%type DEFAULT NULL ) RETURN NUMBER;
--  -- update
--  PROCEDURE job_type_upd(
--      p_C#ID   IN T3_JOB_TYPE.C#ID%type ,
--      p_C#NAME IN T3_JOB_TYPE.C#NAME%type DEFAULT NULL );
--  -- delete
--  PROCEDURE job_type_del(
--      p_C#ID IN T3_JOB_TYPE.C#ID%type );


  -- insert
  FUNCTION contractors_ins(
      p_C#NAME         IN T3_CONTRACTORS.C#NAME%type DEFAULT NULL ,
      p_C#INN          IN T3_CONTRACTORS.C#INN%type DEFAULT NULL ,
      p_C#KPP          IN T3_CONTRACTORS.C#KPP%type DEFAULT NULL ,
      p_C#CONTACT_INFO IN T3_CONTRACTORS.C#CONTACT_INFO%type DEFAULT NULL ,
      p_C#BANK_ID      IN T3_CONTRACTORS.C#BANK_ID%type DEFAULT NULL ,
      p_C#BANK_ACCOUNT IN T3_CONTRACTORS.C#BANK_ACCOUNT%type DEFAULT NULL, 
      p_C#OGRN         IN T3_CONTRACTORS.C#OGRN%type DEFAULT NULL 
  ) RETURN NUMBER;

  -- update
  PROCEDURE contractors_upd(
      p_C#ID           IN T3_CONTRACTORS.C#ID%type ,
      p_C#NAME         IN T3_CONTRACTORS.C#NAME%type DEFAULT NULL ,
      p_C#INN          IN T3_CONTRACTORS.C#INN%type DEFAULT NULL ,
      p_C#KPP          IN T3_CONTRACTORS.C#KPP%type DEFAULT NULL ,
      p_C#CONTACT_INFO IN T3_CONTRACTORS.C#CONTACT_INFO%type DEFAULT NULL ,
      p_C#BANK_ID      IN T3_CONTRACTORS.C#BANK_ID%type DEFAULT NULL ,
      p_C#BANK_ACCOUNT IN T3_CONTRACTORS.C#BANK_ACCOUNT%type DEFAULT NULL, 
      p_C#OGRN         IN T3_CONTRACTORS.C#OGRN%type DEFAULT NULL 
  );
  -- delete
  PROCEDURE contractors_del(
      p_C#ID IN T3_CONTRACTORS.C#ID%type );


  -- insert
  FUNCTION contracts_ins(
      p_C#CONTRACTOR_ID    IN T3_CONTRACTS.C#CONTRACTOR_ID%type DEFAULT NULL ,
      p_C#CONTRACT_TYPE_ID IN T3_CONTRACTS.C#CONTRACT_TYPE_ID%type DEFAULT NULL ,
      p_C#NUM              IN T3_CONTRACTS.C#NUM%type DEFAULT NULL ,
      p_C#DATE             IN T3_CONTRACTS.C#DATE%type DEFAULT NULL ,
      p_C#DESCRIPTION      IN T3_CONTRACTS.C#DESCRIPTION%type DEFAULT NULL, 
      p_C#DATE_BEGIN       IN T3_CONTRACTS.C#DATE_BEGIN%type DEFAULT NULL ,
      p_C#DATE_END         IN T3_CONTRACTS.C#DATE_END%type DEFAULT NULL ,
      p_C#SUM              IN T3_CONTRACTS.C#SUM%type DEFAULT NULL
  ) RETURN NUMBER;
  -- update
  PROCEDURE contracts_upd(
      p_C#ID               IN T3_CONTRACTS.C#ID%type ,
      p_C#CONTRACTOR_ID    IN T3_CONTRACTS.C#CONTRACTOR_ID%type DEFAULT NULL ,
      p_C#CONTRACT_TYPE_ID IN T3_CONTRACTS.C#CONTRACT_TYPE_ID%type DEFAULT NULL ,
      p_C#NUM              IN T3_CONTRACTS.C#NUM%type DEFAULT NULL ,
      p_C#DATE             IN T3_CONTRACTS.C#DATE%type DEFAULT NULL ,
      p_C#DESCRIPTION      IN T3_CONTRACTS.C#DESCRIPTION%type DEFAULT NULL, 
      p_C#DATE_BEGIN       IN T3_CONTRACTS.C#DATE_BEGIN%type DEFAULT NULL ,
      p_C#DATE_END         IN T3_CONTRACTS.C#DATE_END%type DEFAULT NULL ,
      p_C#SUM              IN T3_CONTRACTS.C#SUM%type DEFAULT NULL
  );
  -- delete
  PROCEDURE contracts_del(
      p_C#ID IN T3_CONTRACTS.C#ID%type );


  -- insert
  FUNCTION jobs_ins(
      p_C#CONTRACT_ID IN T3_JOBS.C#CONTRACT_ID%type DEFAULT NULL ,
      p_C#JOB_TYPE_ID IN T3_JOBS.C#JOB_TYPE_ID%type DEFAULT NULL ,
      p_C#DATE_BEGIN  IN T3_JOBS.C#DATE_BEGIN%type DEFAULT NULL ,
      p_C#DATE_END    IN T3_JOBS.C#DATE_END%type DEFAULT NULL ,
      p_C#NOTE        IN T3_JOBS.C#NOTE%type DEFAULT NULL ,
      p_C#HOUSE_ID    IN T3_JOBS.C#HOUSE_ID%type DEFAULT NULL,
      p_C#STATUS    IN T3_JOBS.C#STATUS%type DEFAULT NULL
--      p_C#PLAN_SUM    IN T3_JOBS.C#PLAN_SUM%type DEFAULT NULL
  ) RETURN NUMBER;

  -- update
  PROCEDURE jobs_upd(
      p_C#ID          IN T3_JOBS.C#ID%type ,
      p_C#CONTRACT_ID IN T3_JOBS.C#CONTRACT_ID%type DEFAULT NULL ,
      p_C#JOB_TYPE_ID IN T3_JOBS.C#JOB_TYPE_ID%type DEFAULT NULL ,
      p_C#DATE_BEGIN  IN T3_JOBS.C#DATE_BEGIN%type DEFAULT NULL ,
      p_C#DATE_END    IN T3_JOBS.C#DATE_END%type DEFAULT NULL ,
      p_C#NOTE        IN T3_JOBS.C#NOTE%type DEFAULT NULL ,
      p_C#HOUSE_ID    IN T3_JOBS.C#HOUSE_ID%type DEFAULT NULL, 
      p_C#STATUS    IN T3_JOBS.C#STATUS%type DEFAULT NULL
--      p_C#PLAN_SUM    IN T3_JOBS.C#PLAN_SUM%type DEFAULT NULL
  );
  -- delete
  PROCEDURE jobs_del(
      p_C#ID IN T3_JOBS.C#ID%type );


-- insert
    PROCEDURE bank_ins (
        p_c#bic_num     IN t3_bank.c#bic_num%TYPE,
        p_c#ca_num      IN t3_bank.c#ca_num%TYPE DEFAULT NULL,
        p_c#name        IN t3_bank.c#name%TYPE,
        p_c#kpp         IN t3_bank.c#kpp%TYPE DEFAULT NULL,
        p_c#town_name   IN t3_bank.c#town_name%TYPE DEFAULT NULL,
        p_c#ogrn        IN t3_bank.c#ogrn%TYPE DEFAULT NULL
    );

-- update
    PROCEDURE bank_upd (
        p_c#id          IN t3_bank.c#id%TYPE,
        p_c#bic_num     IN t3_bank.c#bic_num%TYPE,
        p_c#ca_num      IN t3_bank.c#ca_num%TYPE DEFAULT NULL,
        p_c#name        IN t3_bank.c#name%TYPE,
        p_c#kpp         IN t3_bank.c#kpp%TYPE DEFAULT NULL,
        p_c#town_name   IN t3_bank.c#town_name%TYPE DEFAULT NULL,
        p_c#ogrn        IN t3_bank.c#ogrn%TYPE DEFAULT NULL
    );

-- delete
    PROCEDURE bank_del ( p_c#id   IN t3_bank.c#id%TYPE );


-- insert
    FUNCTION pay_ins (
        p_c#job_id        IN t3_pay.c#job_id%TYPE DEFAULT NULL,
        p_c#pay_type_id   IN t3_pay.c#pay_type_id%TYPE DEFAULT NULL,
        p_c#source        IN t3_pay.c#source%TYPE DEFAULT NULL,
        p_c#sum           IN t3_pay.c#sum%TYPE DEFAULT NULL,
        p_c#invoice           IN t3_pay.c#invoice%TYPE DEFAULT NULL,
        p_C#PAY_DATE           IN t3_pay.C#PAY_DATE%TYPE DEFAULT NULL,
        p_C#NOTE           IN t3_pay.C#NOTE%TYPE DEFAULT NULL
    )  RETURN NUMBER;
    
-- update
    PROCEDURE pay_upd (
        p_c#id            IN t3_pay.c#id%TYPE,
        p_c#job_id        IN t3_pay.c#job_id%TYPE DEFAULT NULL,
        p_c#pay_type_id   IN t3_pay.c#pay_type_id%TYPE DEFAULT NULL,
        p_c#source        IN t3_pay.c#source%TYPE DEFAULT NULL,
        p_c#sum           IN t3_pay.c#sum%TYPE DEFAULT NULL,
        p_c#invoice           IN t3_pay.c#invoice%TYPE DEFAULT NULL,
        p_C#PAY_DATE           IN t3_pay.C#PAY_DATE%TYPE DEFAULT NULL,
        p_C#NOTE           IN t3_pay.C#NOTE%TYPE DEFAULT NULL
    );

-- delete
    PROCEDURE pay_del ( p_c#id   IN t3_pay.c#id%TYPE );



-- insert
procedure jobs_plan_ins (
    p_C#HOUSE_ID in T3_JOBS_PLAN.C#HOUSE_ID%type default null 
    ,p_C#JOB_TYPE_ID in T3_JOBS_PLAN.C#REG_JOB_TYPE_ID%type default null 
    ,p_C#YEAR_BEG in T3_JOBS_PLAN.C#YEAR_BEG%type
    ,p_C#YEAR_END in T3_JOBS_PLAN.C#YEAR_END%type
    ,p_C#SUMM in T3_JOBS_PLAN.C#SUMM%type
    ,p_C#NOTE in T3_JOBS_PLAN.C#NOTE%type default null 
);

-- update
procedure jobs_plan_upd (
    p_C#ID in T3_JOBS_PLAN.C#ID%type
    ,p_C#HOUSE_ID in T3_JOBS_PLAN.C#HOUSE_ID%type default null 
    ,p_C#JOB_TYPE_ID in T3_JOBS_PLAN.C#REG_JOB_TYPE_ID%type default null 
    ,p_C#YEAR_BEG in T3_JOBS_PLAN.C#YEAR_BEG%type
    ,p_C#YEAR_END in T3_JOBS_PLAN.C#YEAR_END%type
    ,p_C#SUMM in T3_JOBS_PLAN.C#SUMM%type
    ,p_C#NOTE in T3_JOBS_PLAN.C#NOTE%type default null 
);

-- new version
procedure jobs_plan_new_ver (
    p_C#ID in T3_JOBS_PLAN.C#ID%type
    ,p_C#YEAR_BEG in T3_JOBS_PLAN.C#YEAR_BEG%type
    ,p_C#YEAR_END in T3_JOBS_PLAN.C#YEAR_END%type
    ,p_C#SUMM in T3_JOBS_PLAN.C#SUMM%type
    ,p_C#NOTE in T3_JOBS_PLAN.C#NOTE%type default 'jobs_plan_new_ver' 
);



-- delete
procedure jobs_plan_del (
    p_C#ID in T3_JOBS_PLAN.C#ID%type
);


-- зачеты insert 
    PROCEDURE barter_ins (
        p_HOUSE_ID       IN t3_jobs.c#house_id%TYPE DEFAULT NULL,
        p_JOB_TYPE_ID    IN t3_jobs.C#JOB_TYPE_ID%TYPE DEFAULT NULL,
        p_PAY_SUM        IN t3_pay.c#sum%TYPE DEFAULT NULL,
        p_PAY_DATE       IN t3_pay.C#PAY_DATE%TYPE DEFAULT NULL,
        p_PAY_NOTE       IN t3_pay.C#NOTE%TYPE DEFAULT NULL
    );
   

END P3#API;

/
