--------------------------------------------------------
--  DDL for Package P#HOSTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#HOSTS" 
  IS

  PROCEDURE DEL#HOSTS(a#c_id INTEGER);

  FUNCTION INS#HOSTS(a#KPP             VARCHAR2,
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
                      ) RETURN NUMBER;

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
