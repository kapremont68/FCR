CREATE OR REPLACE PACKAGE P#HOSTS
  IS

  PROCEDURE DEL#HOSTS(a#c_id INTEGER);

  PROCEDURE INS#HOSTS(a#KPP             VARCHAR2,
                      a#INN             VARCHAR2,
                      a#BOSS_SHORT_NAME VARCHAR2,
                      a#BOSS_DOLGN      VARCHAR2,
                      a#BOSS_FIO_DP     VARCHAR2,
                      a#BOSS_FIO        VARCHAR2,
                      a#NOTE            VARCHAR2,
                      a#ADDRESS         VARCHAR2,
                      a#INDEX           VARCHAR2,
                      a#BOSS_DOLGN_DP   VARCHAR2,
                      a#MAIL            VARCHAR2,
                      a#PHONE           VARCHAR2,
                      a#OBR             VARCHAR2,
                      a#HOSTNAME        VARCHAR2,
                      a#BANK_ACC        VARCHAR2
                      );

  PROCEDURE UPD#HOSTS(a#KPP             VARCHAR2,
                      a#INN             VARCHAR2,
                      a#BOSS_SHORT_NAME VARCHAR2,
                      a#BOSS_DOLGN      VARCHAR2,
                      a#BOSS_FIO_DP     VARCHAR2,
                      a#BOSS_FIO        VARCHAR2,
                      a#NOTE            VARCHAR2,
                      a#ADDRESS         VARCHAR2,
                      a#INDEX           VARCHAR2,
                      a#BOSS_DOLGN_DP   VARCHAR2,
                      a#MAIL            VARCHAR2,
                      a#PHONE           VARCHAR2,
                      a#OBR             VARCHAR2,
                      a#HOSTNAME        VARCHAR2,
                      a#BANK_ACC        VARCHAR2
                      );

  PROCEDURE UPD#HOSTS_ON_ID(a#KPP             VARCHAR2,
                            a#INN             VARCHAR2,
                            a#BOSS_SHORT_NAME VARCHAR2,
                            a#BOSS_DOLGN      VARCHAR2,
                            a#BOSS_FIO_DP     VARCHAR2,
                            a#BOSS_FIO        VARCHAR2,
                            a#NOTE            VARCHAR2,
                            a#ADDRESS         VARCHAR2,
                            a#INDEX           VARCHAR2,
                            a#BOSS_DOLGN_DP   VARCHAR2,
                            a#MAIL            VARCHAR2,
                            a#PHONE           VARCHAR2,
                            a#OBR             VARCHAR2,
                            a#c_id            INTEGER,
                            a#BANK_ACC        VARCHAR2
                            );



  FUNCTION LST#HOSTS
    RETURN SYS_REFCURSOR;
  FUNCTION LST#HOST(a#c_id INTEGER)
    RETURN SYS_REFCURSOR;

END P#HOSTS;
/


CREATE OR REPLACE PACKAGE BODY P#HOSTS
  IS


  PROCEDURE DEL#HOSTS(a#c_id INTEGER)
    IS
    BEGIN
      INSERT INTO TT#TR_FLAG (
        C#VAL
      )
      VALUES ('HOSTS_VD#PASS_MOD');
      DELETE FROM fcr.hosts_vd
        WHERE c#id = a#c_id;
      DELETE FROM fcr.hosts
        WHERE c#id = a#c_id;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          dbms_output.put_line('Rollback INS#HOSTS : ' || SQLCODE || ', ' || SQLERRM);
    END;


  PROCEDURE INS#HOSTS(a#KPP             VARCHAR2,
                      a#INN             VARCHAR2,
                      a#BOSS_SHORT_NAME VARCHAR2,
                      a#BOSS_DOLGN      VARCHAR2,
                      a#BOSS_FIO_DP     VARCHAR2,
                      a#BOSS_FIO        VARCHAR2,
                      a#NOTE            VARCHAR2,
                      a#ADDRESS         VARCHAR2,
                      a#INDEX           VARCHAR2,
                      a#BOSS_DOLGN_DP   VARCHAR2,
                      a#MAIL            VARCHAR2,
                      a#PHONE           VARCHAR2,
                      a#OBR             VARCHAR2,
                      a#HOSTNAME        VARCHAR2,
                      a#BANK_ACC        VARCHAR2
                      )
    IS
      a#C_ID  INTEGER;
      a#C_VN  INTEGER;
      a#exist INTEGER;
    BEGIN

      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.Hosts
        WHERE c#hostname = a#hostname;
      IF (a#exist = 0)
      THEN
        INSERT INTO fcr.hosts (
          C#HOSTNAME
        )
        VALUES (a#HOSTNAME) RETURNING c#id INTO a#c_id;
        a#C_VN := 1;
      ELSE
        SELECT c#id
          INTO a#c_id
          FROM fcr.Hosts
          WHERE c#hostname = a#hostname;
        SELECT MAX(t.c#vn) + 1
          INTO a#C_VN
          FROM hosts_vd t
          WHERE t.c#id = a#c_id;
      END IF;

      INSERT INTO fcr.hosts_vd (
        C#KPP, C#INN, C#BOSS_SHORT_NAME, C#BOSS_DOLGN, C#BOSS_FIO_DP, C#BOSS_FIO, C#NOTE, C#ADDRESS, C#INDEX, C#BOSS_DOLGN_DP, C#MAIL, C#PHONE, C#ID, C#OBR, C#VN, C#VALID_TAG, c#BANK_ACC
      )
      VALUES (a#KPP, a#INN, a#BOSS_SHORT_NAME, a#BOSS_DOLGN, a#BOSS_FIO_DP, a#BOSS_FIO, a#NOTE, a#ADDRESS, a#INDEX, a#BOSS_DOLGN_DP, a#MAIL, a#PHONE, a#C_ID, a#OBR, a#C_VN, 'Y', a#BANK_ACC);

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          dbms_output.put_line('Rollback INS#HOSTS : ' || SQLCODE || ', ' || SQLERRM);
    END;


  PROCEDURE UPD#HOSTS(a#KPP             VARCHAR2,
                      a#INN             VARCHAR2,
                      a#BOSS_SHORT_NAME VARCHAR2,
                      a#BOSS_DOLGN      VARCHAR2,
                      a#BOSS_FIO_DP     VARCHAR2,
                      a#BOSS_FIO        VARCHAR2,
                      a#NOTE            VARCHAR2,
                      a#ADDRESS         VARCHAR2,
                      a#INDEX           VARCHAR2,
                      a#BOSS_DOLGN_DP   VARCHAR2,
                      a#MAIL            VARCHAR2,
                      a#PHONE           VARCHAR2,
                      a#OBR             VARCHAR2,
                      a#HOSTNAME        VARCHAR2,
                      a#BANK_ACC        VARCHAR2
                      )
    IS
      a#C_ID  INTEGER;
      a#C_VN  INTEGER;
      a#exist INTEGER;
    BEGIN

      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.Hosts
        WHERE c#hostname = a#hostname;
      IF (a#exist = 1)
      THEN
        SELECT c#id
          INTO a#c_id
          FROM fcr.Hosts
          WHERE c#hostname = a#hostname;
        SELECT MAX(t.c#vn) + 1
          INTO a#C_VN
          FROM hosts_vd t
          WHERE t.c#id = a#c_id;
      ELSE
        RETURN;
      END IF;

      INSERT INTO fcr.hosts_vd (
        C#KPP, C#INN, C#BOSS_SHORT_NAME, C#BOSS_DOLGN, C#BOSS_FIO_DP, C#BOSS_FIO, C#NOTE, C#ADDRESS, C#INDEX, C#BOSS_DOLGN_DP, C#MAIL, C#PHONE, C#ID, C#OBR, C#VN, C#VALID_TAG, c#BANK_ACC
      )
      VALUES (a#KPP, a#INN, a#BOSS_SHORT_NAME, a#BOSS_DOLGN, a#BOSS_FIO_DP, a#BOSS_FIO, a#NOTE, a#ADDRESS, a#INDEX, a#BOSS_DOLGN_DP, a#MAIL, a#PHONE, a#C_ID, a#OBR, a#C_VN, 'Y', a#BANK_ACC);

      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          dbms_output.put_line('Rollback UPD#HOSTS : ' || SQLCODE || ', ' || SQLERRM);
    END;


  PROCEDURE UPD#HOSTS_ON_ID(a#KPP             VARCHAR2,
                            a#INN             VARCHAR2,
                            a#BOSS_SHORT_NAME VARCHAR2,
                            a#BOSS_DOLGN      VARCHAR2,
                            a#BOSS_FIO_DP     VARCHAR2,
                            a#BOSS_FIO        VARCHAR2,
                            a#NOTE            VARCHAR2,
                            a#ADDRESS         VARCHAR2,
                            a#INDEX           VARCHAR2,
                            a#BOSS_DOLGN_DP   VARCHAR2,
                            a#MAIL            VARCHAR2,
                            a#PHONE           VARCHAR2,
                            a#OBR             VARCHAR2,
                            a#c_id            INTEGER,
                            a#BANK_ACC        VARCHAR2
                            )
    IS
      a#C_VN  INTEGER;
      a#exist INTEGER;
    BEGIN

      SELECT COUNT(*)
        INTO a#exist
        FROM fcr.Hosts
        WHERE c#id = a#c_id;
      IF (a#exist = 1)
      THEN
        SELECT MAX(t.c#vn) + 1
          INTO a#C_VN
          FROM hosts_vd t
          WHERE t.c#id = a#c_id;
      ELSE
        RETURN;
      END IF;
      INSERT INTO fcr.hosts_vd (
        C#KPP, C#INN, C#BOSS_SHORT_NAME, C#BOSS_DOLGN, C#BOSS_FIO_DP, C#BOSS_FIO, C#NOTE, C#ADDRESS, C#INDEX, C#BOSS_DOLGN_DP, C#MAIL, C#PHONE, C#ID, C#OBR, C#VN, C#VALID_TAG, c#BANK_ACC
      )
      VALUES (a#KPP, a#INN, a#BOSS_SHORT_NAME, a#BOSS_DOLGN, a#BOSS_FIO_DP, a#BOSS_FIO, a#NOTE, a#ADDRESS, a#INDEX, a#BOSS_DOLGN_DP, a#MAIL, a#PHONE, a#C_ID, a#OBR, a#C_VN, 'Y', a#BANK_ACC);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN ROLLBACK;
          dbms_output.put_line('Rollback UPD#HOSTS : ' || SQLCODE || ', ' || SQLERRM);
    END;



  FUNCTION LST#HOSTS
    RETURN SYS_REFCURSOR
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT C#HOSTNAME,
             C#KPP,
             C#INN,
             C#BOSS_SHORT_NAME,
             C#BOSS_DOLGN,
             C#BOSS_FIO_DP,
             C#BOSS_FIO,
             C#NOTE,
             C#ADDRESS,
             C#INDEX,
             C#BOSS_DOLGN_DP,
             C#MAIL,
             C#PHONE,
             C#ID,
             C#OBR
        FROM fcr.v#hosts;
      RETURN res;
    END;

  FUNCTION LST#HOST(a#c_id INTEGER)
    RETURN SYS_REFCURSOR
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT C#HOSTNAME,
             C#KPP,
             C#INN,
             C#BOSS_SHORT_NAME,
             C#BOSS_DOLGN,
             C#BOSS_FIO_DP,
             C#BOSS_FIO,
             C#NOTE,
             C#ADDRESS,
             C#INDEX,
             C#BOSS_DOLGN_DP,
             C#MAIL,
             C#PHONE,
             C#ID,
             C#OBR
        FROM fcr.v#hosts
        WHERE c#id = a#c_id;
      RETURN res;
    END;


END P#HOSTS;
/
