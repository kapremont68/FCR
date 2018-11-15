--------------------------------------------------------
--  DDL for Procedure E_MAIL_MESSAGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "FCR"."E_MAIL_MESSAGE" (
    from_name   VARCHAR2,
    to_name     VARCHAR2,
    subject     VARCHAR2,
    message     VARCHAR2
) IS

    l_mailhost    VARCHAR2(64) := 'smtp.yandex.ru';
    l_from        VARCHAR2(64) := 'someone@happy-days.net';
    l_to          VARCHAR2(64) := 'geramail@mail.ru';
    l_mail_conn   utl_smtp.connection;
BEGIN
    l_mail_conn := utl_smtp.open_connection(l_mailhost,465);
    utl_smtp.helo(l_mail_conn,l_mailhost);
    utl_smtp.mail(l_mail_conn,l_from);
    utl_smtp.rcpt(l_mail_conn,l_to);
    utl_smtp.open_data(l_mail_conn);
    utl_smtp.write_data(l_mail_conn,'Date: '
    || TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS')
    || chr(13) );

    utl_smtp.write_data(l_mail_conn,'From: '
    || l_from
    || chr(13) );
    utl_smtp.write_data(l_mail_conn,'Subject: '
    || subject
    || chr(13) );
    utl_smtp.write_data(l_mail_conn,'To: '
    || l_to
    || chr(13) );
    utl_smtp.write_data(l_mail_conn,''
    || chr(13) );
    FOR i IN 1..10 LOOP
        utl_smtp.write_data(l_mail_conn,'This is a test message. Line '
        || TO_CHAR(i)
        || chr(13) );
    END LOOP;

    utl_smtp.close_data(l_mail_conn);
    utl_smtp.quit(l_mail_conn);
END;

/
