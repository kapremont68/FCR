CREATE OR REPLACE PACKAGE       "P3#API" 
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


  -- insert
  FUNCTION job_type_ins(
      p_C#NAME IN T3_JOB_TYPE.C#NAME%type DEFAULT NULL ) RETURN NUMBER;
  -- update
  PROCEDURE job_type_upd(
      p_C#ID   IN T3_JOB_TYPE.C#ID%type ,
      p_C#NAME IN T3_JOB_TYPE.C#NAME%type DEFAULT NULL );
  -- delete
  PROCEDURE job_type_del(
      p_C#ID IN T3_JOB_TYPE.C#ID%type );


  -- insert
  FUNCTION contractors_ins(
      p_C#NAME         IN T3_CONTRACTORS.C#NAME%type DEFAULT NULL ,
      p_C#INN          IN T3_CONTRACTORS.C#INN%type DEFAULT NULL ,
      p_C#KPP          IN T3_CONTRACTORS.C#KPP%type DEFAULT NULL ,
      p_C#CONTACT_INFO IN T3_CONTRACTORS.C#CONTACT_INFO%type DEFAULT NULL ,
      p_C#BANK_ID      IN T3_CONTRACTORS.C#BANK_ID%type DEFAULT NULL ,
      p_C#BANK_ACCOUNT IN T3_CONTRACTORS.C#BANK_ACCOUNT%type DEFAULT NULL 
  ) RETURN NUMBER;
  -- update
  PROCEDURE contractors_upd(
      p_C#ID           IN T3_CONTRACTORS.C#ID%type ,
      p_C#NAME         IN T3_CONTRACTORS.C#NAME%type DEFAULT NULL ,
      p_C#INN          IN T3_CONTRACTORS.C#INN%type DEFAULT NULL ,
      p_C#KPP          IN T3_CONTRACTORS.C#KPP%type DEFAULT NULL ,
      p_C#CONTACT_INFO IN T3_CONTRACTORS.C#CONTACT_INFO%type DEFAULT NULL ,
      p_C#BANK_ID      IN T3_CONTRACTORS.C#BANK_ID%type DEFAULT NULL ,
      p_C#BANK_ACCOUNT IN T3_CONTRACTORS.C#BANK_ACCOUNT%type DEFAULT NULL 
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
      p_C#DESCRIPTION      IN T3_CONTRACTS.C#DESCRIPTION%type DEFAULT NULL 
  ) RETURN NUMBER;
  -- update
  PROCEDURE contracts_upd(
      p_C#ID               IN T3_CONTRACTS.C#ID%type ,
      p_C#CONTRACTOR_ID    IN T3_CONTRACTS.C#CONTRACTOR_ID%type DEFAULT NULL ,
      p_C#CONTRACT_TYPE_ID IN T3_CONTRACTS.C#CONTRACT_TYPE_ID%type DEFAULT NULL ,
      p_C#NUM              IN T3_CONTRACTS.C#NUM%type DEFAULT NULL ,
      p_C#DATE             IN T3_CONTRACTS.C#DATE%type DEFAULT NULL ,
      p_C#DESCRIPTION      IN T3_CONTRACTS.C#DESCRIPTION%type DEFAULT NULL 
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



END P3#API;
/


CREATE OR REPLACE PACKAGE BODY       "P3#API" 
IS
  -- insert
  FUNCTION contract_type_ins(
      p_C#NAME IN T3_CONTRACT_TYPE.C#NAME%type DEFAULT NULL ) RETURN NUMBER
  IS
  RET_ID NUMBER;
  BEGIN
    INSERT INTO T3_CONTRACT_TYPE
      ( C#NAME
      ) VALUES
      ( p_C#NAME
      )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
  END;
-- update
  PROCEDURE contract_type_upd
    (
      p_C#ID   IN T3_CONTRACT_TYPE.C#ID%type ,
      p_C#NAME IN T3_CONTRACT_TYPE.C#NAME%type DEFAULT NULL
    )
  IS
  BEGIN
    UPDATE T3_CONTRACT_TYPE SET C#NAME = p_C#NAME WHERE C#ID = p_C#ID;
    COMMIT;
  END;
-- del
  PROCEDURE contract_type_del(
      p_C#ID IN T3_CONTRACT_TYPE.C#ID%type )
  IS
  BEGIN
    DELETE FROM T3_CONTRACT_TYPE WHERE C#ID = p_C#ID;
    COMMIT;
  END;

  -- insert
  FUNCTION pay_type_ins(
      p_C#NAME IN T3_PAY_TYPE.C#NAME%type DEFAULT NULL )RETURN NUMBER
  IS
  RET_ID NUMBER;
  BEGIN
    INSERT INTO T3_PAY_TYPE
      ( C#NAME
      ) VALUES
      ( p_C#NAME
      )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
  END;
-- update
  PROCEDURE pay_type_upd
    (
      p_C#ID   IN T3_PAY_TYPE.C#ID%type ,
      p_C#NAME IN T3_PAY_TYPE.C#NAME%type DEFAULT NULL
    )
  IS
  BEGIN
    UPDATE T3_PAY_TYPE SET C#NAME = p_C#NAME WHERE C#ID = p_C#ID;
    COMMIT;
  END;
-- del
  PROCEDURE pay_type_del(
      p_C#ID IN T3_PAY_TYPE.C#ID%type )
  IS
  BEGIN
    DELETE FROM T3_PAY_TYPE WHERE C#ID = p_C#ID;
    COMMIT;
  END;

  -- insert
  FUNCTION job_type_ins(
      p_C#NAME IN T3_JOB_TYPE.C#NAME%type DEFAULT NULL )RETURN NUMBER
  IS
  RET_ID NUMBER;
  BEGIN
    INSERT INTO T3_JOB_TYPE
      ( C#NAME
      ) VALUES
      ( p_C#NAME
      )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
  END;
-- update
  PROCEDURE job_type_upd
    (
      p_C#ID   IN T3_JOB_TYPE.C#ID%type ,
      p_C#NAME IN T3_JOB_TYPE.C#NAME%type DEFAULT NULL
    )
  IS
  BEGIN
    UPDATE T3_JOB_TYPE SET C#NAME = p_C#NAME WHERE C#ID = p_C#ID;
    COMMIT;
  END;
-- del
  PROCEDURE job_type_del(
      p_C#ID IN T3_JOB_TYPE.C#ID%type )
  IS
  BEGIN
    DELETE FROM T3_JOB_TYPE WHERE C#ID = p_C#ID;
    COMMIT;
  END;

  -- insert
  FUNCTION contractors_ins(
      p_C#NAME         IN T3_CONTRACTORS.C#NAME%type DEFAULT NULL ,
      p_C#INN          IN T3_CONTRACTORS.C#INN%type DEFAULT NULL ,
      p_C#KPP          IN T3_CONTRACTORS.C#KPP%type DEFAULT NULL ,
      p_C#CONTACT_INFO IN T3_CONTRACTORS.C#CONTACT_INFO%type DEFAULT NULL ,
      p_C#BANK_ID      IN T3_CONTRACTORS.C#BANK_ID%type DEFAULT NULL ,
      p_C#BANK_ACCOUNT IN T3_CONTRACTORS.C#BANK_ACCOUNT%type DEFAULT NULL 
  )RETURN NUMBER
  IS
  RET_ID NUMBER;
  BEGIN
    INSERT
    INTO T3_CONTRACTORS
      (
        C#CONTACT_INFO ,
        C#BANK_ACCOUNT ,
        C#INN ,
        C#BANK_ID ,
        C#KPP ,
        C#NAME
      )
      VALUES
      (
        p_C#CONTACT_INFO ,
        p_C#BANK_ACCOUNT ,
        p_C#INN ,
        p_C#BANK_ID ,
        p_C#KPP ,
        p_C#NAME
      )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
  END;
-- update
  PROCEDURE contractors_upd
    (
      p_C#ID           IN T3_CONTRACTORS.C#ID%type ,
      p_C#NAME         IN T3_CONTRACTORS.C#NAME%type DEFAULT NULL ,
      p_C#INN          IN T3_CONTRACTORS.C#INN%type DEFAULT NULL ,
      p_C#KPP          IN T3_CONTRACTORS.C#KPP%type DEFAULT NULL ,
      p_C#CONTACT_INFO IN T3_CONTRACTORS.C#CONTACT_INFO%type DEFAULT NULL ,
      p_C#BANK_ID      IN T3_CONTRACTORS.C#BANK_ID%type DEFAULT NULL ,
      p_C#BANK_ACCOUNT IN T3_CONTRACTORS.C#BANK_ACCOUNT%type DEFAULT NULL 
    )
  IS
  BEGIN
    UPDATE T3_CONTRACTORS
    SET C#CONTACT_INFO = p_C#CONTACT_INFO ,
      C#BANK_ACCOUNT   = p_C#BANK_ACCOUNT ,
      C#INN            = p_C#INN ,
      C#BANK_ID        = p_C#BANK_ID ,
      C#KPP            = p_C#KPP ,
      C#NAME           = p_C#NAME
    WHERE C#ID         = p_C#ID;
    COMMIT;
  END;
-- del
  PROCEDURE contractors_del(
      p_C#ID IN T3_CONTRACTORS.C#ID%type )
  IS
  BEGIN
    DELETE FROM T3_CONTRACTORS WHERE C#ID = p_C#ID;
    COMMIT;
  END;

  -- insert
  FUNCTION contracts_ins(
      p_C#CONTRACTOR_ID    IN T3_CONTRACTS.C#CONTRACTOR_ID%type DEFAULT NULL ,
      p_C#CONTRACT_TYPE_ID IN T3_CONTRACTS.C#CONTRACT_TYPE_ID%type DEFAULT NULL ,
      p_C#NUM              IN T3_CONTRACTS.C#NUM%type DEFAULT NULL ,
      p_C#DATE             IN T3_CONTRACTS.C#DATE%type DEFAULT NULL ,
      p_C#DESCRIPTION      IN T3_CONTRACTS.C#DESCRIPTION%type DEFAULT NULL 
  ) RETURN NUMBER
  IS
  RET_ID NUMBER;
  BEGIN
    INSERT
    INTO T3_CONTRACTS
      (
        C#CONTRACT_TYPE_ID ,
        C#DESCRIPTION ,
        C#CONTRACTOR_ID ,
        C#NUM ,
        C#DATE
      )
      VALUES
      (
        p_C#CONTRACT_TYPE_ID ,
        p_C#DESCRIPTION ,
        p_C#CONTRACTOR_ID ,
        p_C#NUM ,
        p_C#DATE
      )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
  END;
-- update
  PROCEDURE contracts_upd
    (
      p_C#ID               IN T3_CONTRACTS.C#ID%type ,
      p_C#CONTRACTOR_ID    IN T3_CONTRACTS.C#CONTRACTOR_ID%type DEFAULT NULL ,
      p_C#CONTRACT_TYPE_ID IN T3_CONTRACTS.C#CONTRACT_TYPE_ID%type DEFAULT NULL ,
      p_C#NUM              IN T3_CONTRACTS.C#NUM%type DEFAULT NULL ,
      p_C#DATE             IN T3_CONTRACTS.C#DATE%type DEFAULT NULL ,
      p_C#DESCRIPTION      IN T3_CONTRACTS.C#DESCRIPTION%type DEFAULT NULL 
    )
  IS
  BEGIN
    UPDATE T3_CONTRACTS
    SET C#CONTRACT_TYPE_ID = p_C#CONTRACT_TYPE_ID ,
      C#DESCRIPTION        = p_C#DESCRIPTION ,
      C#CONTRACTOR_ID      = p_C#CONTRACTOR_ID ,
      C#NUM                = p_C#NUM ,
      C#DATE               = p_C#DATE
    WHERE C#ID             = p_C#ID;
    COMMIT;
  END;
-- del
  PROCEDURE contracts_del(
      p_C#ID IN T3_CONTRACTS.C#ID%type )
  IS
  BEGIN
    DELETE FROM T3_CONTRACTS WHERE C#ID = p_C#ID;
    COMMIT;
  END;

  -- insert
  FUNCTION jobs_ins(
      p_C#CONTRACT_ID IN T3_JOBS.C#CONTRACT_ID%type DEFAULT NULL ,
      p_C#JOB_TYPE_ID IN T3_JOBS.C#JOB_TYPE_ID%type DEFAULT NULL ,
      p_C#DATE_BEGIN  IN T3_JOBS.C#DATE_BEGIN%type DEFAULT NULL ,
      p_C#DATE_END    IN T3_JOBS.C#DATE_END%type DEFAULT NULL ,
      p_C#NOTE        IN T3_JOBS.C#NOTE%type DEFAULT NULL ,
      p_C#HOUSE_ID    IN T3_JOBS.C#HOUSE_ID%type DEFAULT NULL,
      p_C#STATUS    IN T3_JOBS.C#STATUS%type DEFAULT NULL
  ) RETURN NUMBER
  IS
  RET_ID NUMBER;
  BEGIN
    INSERT
    INTO T3_JOBS
      (
        C#HOUSE_ID ,
        C#DATE_END ,
        C#NOTE ,
        C#DATE_BEGIN ,
        C#CONTRACT_ID ,
        C#JOB_TYPE_ID ,
        C#STATUS
      )
      VALUES
      (
        p_C#HOUSE_ID ,
        p_C#DATE_END ,
        p_C#NOTE ,
        p_C#DATE_BEGIN ,
        p_C#CONTRACT_ID ,
        p_C#JOB_TYPE_ID,
        p_C#STATUS
      )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
  END;
-- update
  PROCEDURE jobs_upd
    (
      p_C#ID          IN T3_JOBS.C#ID%type ,
      p_C#CONTRACT_ID IN T3_JOBS.C#CONTRACT_ID%type DEFAULT NULL ,
      p_C#JOB_TYPE_ID IN T3_JOBS.C#JOB_TYPE_ID%type DEFAULT NULL ,
      p_C#DATE_BEGIN  IN T3_JOBS.C#DATE_BEGIN%type DEFAULT NULL ,
      p_C#DATE_END    IN T3_JOBS.C#DATE_END%type DEFAULT NULL ,
      p_C#NOTE        IN T3_JOBS.C#NOTE%type DEFAULT NULL ,
      p_C#HOUSE_ID    IN T3_JOBS.C#HOUSE_ID%type DEFAULT NULL,
      p_C#STATUS    IN T3_JOBS.C#STATUS%type DEFAULT NULL
    )
  IS
  BEGIN
    UPDATE T3_JOBS
    SET C#DATE_END  = p_C#DATE_END ,
      C#HOUSE_ID    = p_C#HOUSE_ID ,
      C#NOTE        = p_C#NOTE ,
      C#DATE_BEGIN  = p_C#DATE_BEGIN ,
      C#CONTRACT_ID = p_C#CONTRACT_ID ,
      C#JOB_TYPE_ID = p_C#JOB_TYPE_ID,
      C#STATUS      = p_C#STATUS
    WHERE C#ID      = p_C#ID;
    COMMIT;
  END;
-- del
  PROCEDURE jobs_del(
      p_C#ID IN T3_JOBS.C#ID%type )
  IS
  BEGIN
    DELETE FROM T3_JOBS WHERE C#ID = p_C#ID;
    COMMIT;
  END;



-- insert
  PROCEDURE bank_ins (
        p_c#bic_num     IN t3_bank.c#bic_num%TYPE,
        p_c#ca_num      IN t3_bank.c#ca_num%TYPE DEFAULT NULL,
        p_c#name        IN t3_bank.c#name%TYPE,
        p_c#kpp         IN t3_bank.c#kpp%TYPE DEFAULT NULL,
        p_c#town_name   IN t3_bank.c#town_name%TYPE DEFAULT NULL,
        p_c#ogrn        IN t3_bank.c#ogrn%TYPE DEFAULT NULL
    ) AS
  BEGIN
    INSERT INTO t3_bank (
        c#ogrn,
        c#town_name,
        c#bic_num,
        c#ca_num,
        c#kpp,
        c#name
    ) VALUES (
        p_c#ogrn,
        p_c#town_name,
        p_c#bic_num,
        p_c#ca_num,
        p_c#kpp,
        p_c#name
    );
  END bank_ins;

-- update
  PROCEDURE bank_upd (
        p_c#id          IN t3_bank.c#id%TYPE,
        p_c#bic_num     IN t3_bank.c#bic_num%TYPE,
        p_c#ca_num      IN t3_bank.c#ca_num%TYPE DEFAULT NULL,
        p_c#name        IN t3_bank.c#name%TYPE,
        p_c#kpp         IN t3_bank.c#kpp%TYPE DEFAULT NULL,
        p_c#town_name   IN t3_bank.c#town_name%TYPE DEFAULT NULL,
        p_c#ogrn        IN t3_bank.c#ogrn%TYPE DEFAULT NULL
    ) AS
  BEGIN
    UPDATE t3_bank
        SET
            c#ogrn = p_c#ogrn,
            c#town_name = p_c#town_name,
            c#bic_num = p_c#bic_num,
            c#ca_num = p_c#ca_num,
            c#kpp = p_c#kpp,
            c#name = p_c#name
    WHERE
        c#id = p_c#id;
  END bank_upd;

-- del
  PROCEDURE bank_del ( p_c#id   IN t3_bank.c#id%TYPE ) AS
  BEGIN
    DELETE FROM t3_bank WHERE
        c#id = p_c#id;
  END bank_del;


-- insert
    FUNCTION pay_ins (
        p_c#job_id        IN t3_pay.c#job_id%TYPE DEFAULT NULL,
        p_c#pay_type_id   IN t3_pay.c#pay_type_id%TYPE DEFAULT NULL,
        p_c#source        IN t3_pay.c#source%TYPE DEFAULT NULL,
        p_c#sum           IN t3_pay.c#sum%TYPE DEFAULT NULL,
        p_c#invoice           IN t3_pay.c#invoice%TYPE DEFAULT NULL,
        p_C#PAY_DATE           IN t3_pay.C#PAY_DATE%TYPE DEFAULT NULL,
        p_C#NOTE           IN t3_pay.C#NOTE%TYPE DEFAULT NULL
    )  RETURN NUMBER
        IS
        RET_ID NUMBER;
    BEGIN
        INSERT INTO t3_pay (
            c#job_id,
            c#pay_type_id,
            c#source,
            c#sum,
            c#invoice,
            C#PAY_DATE,
            C#NOTE
        ) VALUES (
            p_c#job_id,
            p_c#pay_type_id,
            p_c#source,
            p_c#sum,
            p_c#invoice,
            p_C#PAY_DATE,
            p_C#NOTE
        )
      RETURNING C#ID INTO RET_ID;
      COMMIT;
      RETURN RET_ID;
    END;


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
    )
        IS
    BEGIN
        UPDATE t3_pay
            SET
                c#job_id = p_c#job_id,
                c#pay_type_id = p_c#pay_type_id,
                c#source = p_c#source,
                c#sum = p_c#sum,
                c#invoice = p_c#invoice,
                c#PAY_DATE = p_c#PAY_DATE,
                c#NOTE = p_c#NOTE
        WHERE
            c#id = p_c#id;

    END;


-- del
    PROCEDURE pay_del ( p_c#id   IN t3_pay.c#id%TYPE )
        IS
    BEGIN
        DELETE FROM t3_pay WHERE
            c#id = p_c#id;
    END;



END P3#API;
/
