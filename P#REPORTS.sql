CREATE OR REPLACE PACKAGE P#REPORTS
  IS
  /** Author  : ALEXANDER
  * Created : 11.10.2016 10:22:38
  */

  /**
  * +Ежеквартальная отчетность для сайта
  */

  /**
  * Часть 1
  * @param a#date_begin дата начала периода
  * @param a#date_end дата окончания периода
  */
  FUNCTION LST#REP_FOR_SITE_1(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor;

  /**
  * Часть 2
  * @param a#date_begin дата начала периода
  * @param a#date_end дата окончания периода
  */
  FUNCTION LST#REP_FOR_SITE_2(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor;

  /**
  * Часть 4
  * @param a#date_begin дата начала периода
  * @param a#date_end дата окончания периода
  */
  FUNCTION LST#REP_FOR_SITE_4(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor;

  /**
  * -Ежеквартальная отчетность для сайта
  */

  FUNCTION LST#PAY_NOT_J(a#person_id INTEGER)
    RETURN sys_refcursor;

  FUNCTION LST#AKT_F_OLD(a#num    VARCHAR2,
                         a#dbegin VARCHAR2,
                         a#dend   VARCHAR2)
    RETURN sys_refcursor;
  FUNCTION LST#AKT_F(a#num    VARCHAR2,
                     a#dbegin VARCHAR2,
                     a#dend   VARCHAR2)
    RETURN sys_refcursor;

  FUNCTION LST#TARIF
    RETURN sys_refcursor;

  PROCEDURE LST#PAYCODEOPS(a#person_id     INTEGER,
                           res         OUT sys_refcursor);

  FUNCTION LST#HOUSE_INFO
    RETURN sys_refcursor;

  /** 
	* Оборотка по дому
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_OBOROT_HOUSE(a#date_begin VARCHAR2,
                                a#date_end   VARCHAR2)
    RETURN sys_refcursor;

  /** 
	* Начислено, собрано, долг в разрезе счет- спец.счет с группировкой по муниципальным образованиям
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_ACCOUNT_SPECIAL(a#date_begin DATE,
                                   a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* Начислено, собрано, долг в разрезе собственности (федеральная, муниципальная и т.п.) по районам
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_PROPERTLY_OMSU(a#date_begin DATE,
                                  a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* Начислено, собрано, долг в разрезе собственности (федеральная, муниципальная и т.п.)
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_PROPERTLY(a#date_begin DATE,
                             a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* Начислено, собрано, долг в разрезе счет- спец.счет 
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_TYPE_ACCOUNT(a#date_begin DATE,
                                a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* Начислено, собрано, долг в разрезе РКЦ
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_RKC(a#date_begin DATE,
                       a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* Начислено, собрано, долг в разрезе жилые помещение и нежилые с группировкой по муниципальным образованиям
	* @param a#date_begin дата начала периода
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оборотам за период
	*/
  FUNCTION LST#REP_LIVING_ROOMS(a#date_begin DATE,
                                a#date_end   DATE)
    RETURN sys_refcursor;

  /** 
	* Оплаты юр. лица в разрезе операций
	* @param a#person_id идентификатор юр. лица
	* @return курсор с информацией по оплатам
	*/
  FUNCTION LST#PAY_CODE_OPS(a#person_id INTEGER)
    RETURN sys_refcursor;

  /** 
	* Акт
	* @param a#person_id идентификатор юр. лица	
	* @param a#date_begin дата начала периода	
	* @param a#date_end дата окончания периода
	* @return курсор с информацией по оплатам и начислениям
	*/
  FUNCTION LST#AKT(a#person_id INTEGER,
                   a#dbegin    VARCHAR2,
                   a#dend      VARCHAR2)
    RETURN sys_refcursor;

  /** 
	* Реестр начислений и оплат юр. лица 
	* @param a#person_id идентификатор юр. лица
	* @return курсор с информацией по оплатам
	*/
  FUNCTION LST#REESTR(  a#person_id  INTEGER, 
                        a#date_begin VARCHAR2 default null,
                        a#date_end   VARCHAR2 default null)
    RETURN sys_refcursor;


  PROCEDURE LST#REESTR2(a#person_id  INTEGER);



  FUNCTION LST#REESTR_OLD(  a#person_id  INTEGER) RETURN sys_refcursor;

  /** 
	* Реестр начислений 
	* @param a#person_id идентификатор юр. лица	
	* @param a#mn_begin дата начала периода	
	* @param a#mn_end дата окончания периода
	* @return курсор с информацией по начислениям
	*/
  FUNCTION LST#REESTR_NO_PAY(a#person_id INT,
                             a#mn_begin  INT,
                             a#mn_end    INT)
    RETURN sys_refcursor;


-- Отчет для ГЖИ приложение 6 
  FUNCTION LST#GGI_PRIL6(p_YEAR VARCHAR2) RETURN sys_refcursor;



END P#REPORTS;
/


CREATE OR REPLACE PACKAGE BODY P#REPORTS
  IS

  /**
    * +Ежеквартальная отчетность для сайта
    */


  /**
  * Часть 1
  * @param a#date_begin дата начала периода
  * @param a#date_end дата окончания периода
  */
  FUNCTION LST#REP_FOR_SITE_1(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor
    AS
      ret   sys_refcursor;
      m_beg INT;
      m_end INT;
    BEGIN
      m_beg := fcr.p#mn_utils.get#mn(a#date_begin);
      m_end := fcr.p#mn_utils.get#mn(a#date_end);
      OPEN ret FOR
        select * from (
                select
                    P#UTILS.GET#HOUSE_ADDR(HOUSE_ID) "Адрес дома"
                    ,SUM(CASE WHEN MN = P#MN_UTILS.GET#MN(a#date_begin) THEN BALANCE_SUM_TOTAL-PAY_SUM_MN+OWNERS_JOB_SUM_MN ELSE 0 END)  "Остаток"
                    ,SUM(CASE WHEN MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end) THEN PAY_SUM_MN+PENI_SUM_MN ELSE 0 END)  "Всего"
                    ,SUM(CASE WHEN MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end) THEN PAY_SUM_MN ELSE 0 END)  "Взносов"
                    ,SUM(CASE WHEN MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end) THEN PENI_SUM_MN ELSE 0 END)  "Пени"
                    ,0 "Доход"
                    ,0 "Иных"            
                    ,SUM(CASE WHEN MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end) THEN OWNERS_JOB_SUM_MN ELSE 0 END)  "Использовано"
                    ,SUM(CASE WHEN MN = P#MN_UTILS.GET#MN(a#date_end) THEN BALANCE_SUM_TOTAL ELSE 0 END)  "Остаток на конец"
                    ,'https://yadi.sk/d/uScyi1d00Fis7Q/'||HOUSE_ID "Папка с документами по дому"
--                    ,'http://kapremont68.ru/wp-content/uploads/dogovor/listhousedocs.php?HID='||HOUSE_ID "Папка с документами по дому"
                from
                    T#TOTAL_HOUSE
                where
                    MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end)
                group by
                    HOUSE_ID
                order by
                    P#UTILS.GET#HOUSE_ADDR(HOUSE_ID)
        ) T
        where
            T."Всего" > 0
        ;
      RETURN ret;
    END;

  /**
  * Часть 2
  * @param a#date_begin дата начала периода
  * @param a#date_end дата окончания периода
  */
  FUNCTION LST#REP_FOR_SITE_2(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor
    AS
      ret   sys_refcursor;
      m_beg INT;
      m_end INT;
    BEGIN
      m_beg := fcr.p#mn_utils.get#mn(a#date_begin);
      m_end := fcr.p#mn_utils.get#mn(a#date_end);
      OPEN ret FOR
        with
            total as (
                select
                    T.HOUSE_ID
                    ,ADDR
                    ,SUM(CASE WHEN MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end) THEN CHARGE_SUM_MN ELSE 0 END)  CHARGE_SUM
                    ,SUM(CASE WHEN MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end) THEN PAY_SUM_MN-CHARGE_SUM_MN ELSE 0 END)  PAY_MINUS_CHARGE_SUM
                    ,SUM(CASE WHEN MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end) THEN PAY_SUM_MN ELSE 0 END)  TOTAL_PAY_SUM
                    ,SUM(CASE WHEN MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end) THEN OWNERS_JOB_SUM_MN ELSE 0 END)  OWNERS_JOBS_SUM
                    ,SUM(CASE WHEN MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end) THEN GOS_JOB_SUM_MN ELSE 0 END)  GOS_JOBS_SUM
                    ,SUM(CASE WHEN MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end) THEN JOB_SUM_MN ELSE 0 END)  TOTAL_JOBS_SUM
                from
                    T#TOTAL_HOUSE T
                    JOIN MV_HOUSES_ADRESES A ON (T.HOUSE_ID = A.HOUSE_ID)
                where
                    MN BETWEEN 162 AND P#MN_UTILS.GET#MN(a#date_end)
                group by
                    T.HOUSE_ID, ADDR
            )            
            ,mn as (
                select
                    HOUSE_ID
--                    ,SUM(CASE WHEN MN = P#MN_UTILS.GET#MN(a#date_begin) THEN BALANCE_SUM_TOTAL-PAY_SUM_MN+JOB_SUM_MN ELSE 0 END)  BALANCE_BEG
                    ,SUM(CASE WHEN MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end) THEN JOB_SUM_MN ELSE 0 END)  PERIOD_JOBS_SUM
--                    ,SUM(CASE WHEN MN = P#MN_UTILS.GET#MN(a#date_end) THEN BALANCE_SUM_TOTAL ELSE 0 END)  BALANCE_END
                from
                    T#TOTAL_HOUSE    
                where
                    MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) AND P#MN_UTILS.GET#MN(a#date_end)
                group by
                    HOUSE_ID
            )
            ,alls as (
                select
                    mn.HOUSE_ID
                    ,ADDR N1
                    ,P3UTILS.get_jobs_txt(mn.HOUSE_ID,TO_DATE('01.06.2014','dd.mm.yyyy'),a#date_end ) N2
                    ,TOTAL_JOBS_SUM N3
                    ,CASE WHEN TOTAL_JOBS_SUM > 0 THEN CASE WHEN PAY_MINUS_CHARGE_SUM > 0 THEN CHARGE_SUM ELSE least(TOTAL_PAY_SUM,OWNERS_JOBS_SUM) END ELSE 0 END N4
                    ,CASE WHEN TOTAL_JOBS_SUM > 0 and PAY_MINUS_CHARGE_SUM > 0 THEN PAY_MINUS_CHARGE_SUM ELSE 0  END N5
                    ,GOS_JOBS_SUM N6
                    ,CASE WHEN TOTAL_JOBS_SUM > 0 THEN CASE WHEN TOTAL_JOBS_SUM-TOTAL_PAY_SUM-GOS_JOBS_SUM > 0 THEN TOTAL_JOBS_SUM-TOTAL_PAY_SUM-GOS_JOBS_SUM ELSE 0 END ELSE 0 END N8
--                    ,ABS(CASE WHEN BALANCE_BEG < 0 or BALANCE_END < 0 THEN BALANCE_BEG ELSE 0 END) N12
                    ,PERIOD_JOBS_SUM N13
--                    ,ABS(CASE WHEN BALANCE_BEG < 0 or BALANCE_END < 0 THEN BALANCE_END ELSE 0 END) N14
                from
                    mn join total on (mn.HOUSE_ID = total.HOUSE_ID)
            )
        select
            N1 address,
            N2 work,
            N3 Al,
            N4 c1,
            N5 c2,
            N6 c3,
            0 c4,
            N8 c5,
            0 c6,
            0 c7,
            0 c8,
            0 c9,
--            N12 c9,
            N13 c10,
--            N14 c11
            0 c11
--            ,'http://kapremont68.ru/wp-content/uploads/dogovor/listhousedocs.php?HID='||HOUSE_ID "Папка с документами по дому"
            ,'https://yadi.sk/d/uScyi1d00Fis7Q/'||HOUSE_ID "Папка с документами по дому"
        from
            alls
        order by
            address
        ;
      RETURN ret;
    END;

  /**
  * Часть 4
  * @param a#date_begin дата начала периода
  * @param a#date_end дата окончания периода
  */
  FUNCTION LST#REP_FOR_SITE_4(a#date_begin DATE,
                              a#date_end   DATE)
    RETURN sys_refcursor
    AS
      ret   sys_refcursor;
--      m_beg INT;
--      m_end INT;
    BEGIN
--      m_beg := fcr.p#mn_utils.get#mn(a#date_begin);
--      m_end := fcr.p#mn_utils.get#mn(a#date_end);


      OPEN ret FOR
            with
                beg_per as (
                    select 
                        A.*
                        ,H.ADDR
                        ,DOLG_SUM_TOTAL-DOLG_SUM_MN DOLG_BEG
                    from
                        T#TOTAL_ACCOUNT A
                        JOIN MV_HOUSES_ADRESES H on (A.HOUSE_ID = H.HOUSE_ID)
                    where
                        MN = P#MN_UTILS.GET#MN(a#date_begin)
                )
                ,end_per as (
                    select 
                        T#TOTAL_ACCOUNT.*
                        ,DOLG_SUM_TOTAL DOLG_END
                    from
                        T#TOTAL_ACCOUNT
                    where
                        MN = P#MN_UTILS.GET#MN(a#date_end)
                )
                ,year_pay as (
                    select
                        ACCOUNT_ID,
                        SUM(CHARGE_SUM_MN)  CHARGE_SUM,
                        SUM(PAY_SUM_MN-BARTER_SUM_MN)    PAY_SUM,     
                        SUM(BARTER_SUM_MN)   BARTER_SUM,
                        SUM(PENI_SUM_MN)   PENI_SUM        
                    from    
                        T#TOTAL_ACCOUNT
                    where
                        MN BETWEEN P#MN_UTILS.GET#MN(TO_DATE('01.01.'||EXTRACT(YEAR FROM TO_DATE(a#date_begin)),'dd.mm.yyyy')) AND P#MN_UTILS.GET#MN(a#date_end)
                    group by
                        ACCOUNT_ID
                )
                ,alls as (
                    select
                        b.HOUSE_ID,
                        b.ADDR,
                        b.FLAT_NUM,
                        DOLG_BEG,
                        CHARGE_SUM,
                        PAY_SUM, 
                        BARTER_SUM,
                        DOLG_END,
                        PENI_SUM
                    from
                        beg_per b
                        join end_per e on (b.account_id = e.account_id)
                        join year_pay y on (b.account_id = y.account_id)
                )
            select
                ADDR N0,
                FLAT_NUM N1,
                CASE WHEN DOLG_BEG > 0 THEN DOLG_BEG ELSE 0 END N2,
                CASE WHEN DOLG_BEG < 0 THEN ABS(DOLG_BEG) ELSE 0 END N3,
                CHARGE_SUM N4,
                PAY_SUM N5, 
                BARTER_SUM N6,
                CASE WHEN DOLG_END > 0 THEN DOLG_END ELSE 0 END N7,
                CASE WHEN DOLG_END < 0 THEN ABS(DOLG_END) ELSE 0 END N8,
                PENI_SUM N9
--                ,'http://kapremont68.ru/wp-content/uploads/dogovor/listhousedocs.php?HID='||HOUSE_ID "Папка с документами по дому"
                ,'https://yadi.sk/d/uScyi1d00Fis7Q/'||HOUSE_ID "Папка с документами по дому"
            from
               alls
            where
                CHARGE_SUM <> 0
            order by 
                ADDR, LPAD(FLAT_NUM,10,'0')
            ;   
      RETURN ret;
    END;
  /**
  * -Ежеквартальная отчетность для сайта
  */


  FUNCTION LST#TARIF
    RETURN sys_refcursor
    AS
      ret sys_refcursor;
    BEGIN
      OPEN ret FOR
      SELECT c#id,
             c#name,
             fcr.p#utils.get#house_addr(house_id) address
        FROM fcr.t#works
        WHERE house_id IS NOT NULL;
      RETURN ret;
    END;

  FUNCTION LST#HOUSE_INFO
    RETURN sys_refcursor
    AS
      ret sys_refcursor;
    BEGIN
      OPEN ret FOR
      SELECT fcr.p#utils.GET_OBJ#HOUSE_POSTAMT(hi.c#house_id).f#code || ',' || fcr.p#utils.get#house_addr(hi.c#house_id) address,
             c#2nd_date date_start,
             c#area_val area,
             c#vote_text,
             acc.c#acc_type
        FROM fcr.t#house_info hi
          LEFT JOIN (SELECT c#house_id,
                            c#acc_type
              FROM fcr.v#banking vb
                INNER JOIN fcr.t#b_account tba
                  ON (vb.c#b_account_id = tba.c#id)) acc
            ON (acc.c#house_id = hi.c#house_id)
        WHERE hi.c#end_date IS NULL;
      RETURN ret;
    END;

  PROCEDURE LST#PAYCODEOPS(a#person_id     INTEGER,
                           res         OUT sys_refcursor)
    AS
    BEGIN
      OPEN res FOR
      SELECT c#cod,
             c#name,
             c#real_date,
             sum_op
        FROM (SELECT o.c#cod,
                     o.c#name,
                     TO_CHAR(c#real_date, 'mm.yyyy') c#real_date,
                     SUM(NVL(c#sum, 0)) sum_op
            FROM fcr.v#op vop
              INNER JOIN (SELECT ops.c#id,
                                 ok.c#cod,
                                 ok.c#name
                  FROM fcr.v#ops ops
                    INNER JOIN fcr.t#ops_kind ok
                      ON (ops.C#KIND_ID = ok.c#id)) o
                ON (vop.c#ops_id = o.c#id)
            WHERE 1 = 1
              AND c#account_id IN (SELECT DISTINCT c#account_id
                  FROM fcr.v#account_spec vas
                  WHERE c#person_id = a#person_id)
            GROUP BY TO_CHAR(c#real_date, 'mm.yyyy'),
                     o.c#cod,
                     o.c#name) t
        ORDER BY TO_DATE('01.' || t.c#real_date, 'dd.mm.yyyy');
    END;



  FUNCTION LST#REESTR_NO_PAY(a#person_id INT,
                             a#mn_begin  INT,
                             a#mn_end    INT)
    RETURN sys_refcursor
    IS
      res          sys_refcursor;
      a#date_begin DATE;
      a#date_end   DATE;
    BEGIN
      SELECT fcr.p#mn_utils.Get#date(a#mn_begin)
        INTO a#date_begin
        FROM dual;
      SELECT fcr.p#mn_utils.Get#date(a#mn_end)
        INTO a#date_end
        FROM dual;
      OPEN res FOR
      SELECT (SELECT FCR.P#UTILS.GET#PERSON_NAME(a#person_id)
                 FROM dual) fio,
             r.m m_date,
             ROUND(SUM(nach) / c#tar_val, 2) area,
             c#tar_val tarif,
             SUM(nach) nach
        FROM (SELECT *
            FROM v#account
            WHERE 1 = 1
              AND c#end_date IS NULL
              OR c#date <> c#end_date) a
          INNER JOIN (SELECT ch.m,
                             ch.c#account_id,
                             c#tar_val,
                             SUM(ch.nach) nach
              FROM (SELECT t1.m,
                           t1.c#account_id,
                           t1.c#tar_val,
                           SUM(nach) nach
                  FROM (SELECT t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn), 'mm.yyyy') m,
                               tc.c#account_id,
                               v.c#tar_val,
                               SUM(tc.c#sum) nach
                      FROM fcr.t#charge tc
                        INNER JOIN (SELECT *
                            FROM (SELECT asp.c#person_id,
                                         asp.c#account_id,
                                         a.c#num,
                                         asp.c#date,
                                         NVL(LEAD(asp.c#date)
                                         OVER (PARTITION BY asp.c#account_id ORDER BY asp.c#date),
                                         fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                FROM v#account_spec asp
                                  INNER JOIN t#account a
                                    ON (a.c#id = asp.c#account_id)
                                WHERE 1 = 1
                                  AND asp.c#valid_tag = 'Y'
                                  AND asp.c#account_id IN (SELECT c#account_id
                                      FROM v#account_spec
                                      WHERE 1 = 1
                                        AND c#valid_tag = 'Y'
                                        AND c#person_id = a#person_id)) t2
                            WHERE c#person_id = a#person_id) t
                          ON (tc.c#account_id = t.c#account_id
                          AND tc.c#a_mn <= fcr.p#mn_utils.GET#MN(t.c#next_date))
                        LEFT JOIN (SELECT vw.C#ID,
                                          vw.c#date,
                                          tobj.c#account_id,
                                          vw.c#tar_val
                            FROM fcr.v#obj tobj
                              INNER JOIN fcr.v#work vw
                                ON (tobj.c#work_id = vw.c#id)) v
                          ON (v.c#account_id = tc.c#account_id
                          AND tc.c#work_id = v.c#id)
                      WHERE 1 = 1
                      GROUP BY t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn), 'mm.yyyy'),
                               tc.c#account_id,
                               v.c#tar_val) t1
                  GROUP BY t1.c#person_id,
                           t1.m,
                           t1.c#account_id,
                           t1.c#tar_val) ch
              GROUP BY ch.m,
                       ch.c#tar_val,
                       ch.c#account_id) r
            ON (r.c#account_id = a.c#id)
        GROUP BY r.m,
                 r.c#tar_val
        HAVING TO_DATE('01.' || r.m, 'dd.mm.yyyy') >= a#date_begin
          AND TO_DATE('01.' || r.m, 'dd.mm.yyyy') <= a#date_end
        ORDER BY TO_DATE(r.m, 'mm.yyyy')
      ;
      RETURN res;
    END;

  FUNCTION LST#REESTR(  a#person_id  INTEGER, 
                        a#date_begin VARCHAR2 default null,
                        a#date_end   VARCHAR2 default null)
    RETURN sys_refcursor
    IS
      res      sys_refcursor;
      a#mn_begin NUMBER;
      a#mn_end NUMBER;
    BEGIN
        if a#date_begin is null then
            a#mn_begin := 162;
        else
            a#mn_begin := fcr.p#mn_utils.get#mn(to_date(a#date_begin,'dd.mm.yyyy'));
        end if;

        if a#date_begin is null then
            a#mn_end := fcr.p#utils.GET#OPEN_MN;
        else
            a#mn_end := fcr.p#mn_utils.get#mn(to_date(a#date_end,'dd.mm.yyyy'));
        end if;
        
      OPEN res FOR
      SELECT a.C#NUM,
             fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID) AS address,
             a.C#DATE AS date_begin,
             a.C#END_DATE AS date_end,
             (SELECT SUM(vrs.C#AREA_VAL)
                 FROM fcr.v#account va
                   INNER JOIN fcr.v#rooms_spec vrs
                     ON (va.c#rooms_id = vrs.c#rooms_id)
                 WHERE va.c#id = a.c#id) AS area,
             SUM(r.nach) AS charge,
             SUM(opl) AS opl
        FROM (SELECT *
            FROM v#account
              ) a
          INNER JOIN (SELECT ch.m,
                             ch.c#account_id,
                             SUM(ch.nach) nach,
                             SUM(NVL(op.sum_op, 0)) opl
              FROM (SELECT t1.m,
                           t1.c#account_id,
                           SUM(nach) nach
                  FROM (SELECT 
                        t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                               'mm.yyyy') m,
                               tc.c#account_id,
                               v.c#tar_val,
                               SUM(tc.c#sum) nach
                      FROM fcr.t#charge tc
                        INNER JOIN (SELECT *
                            FROM (SELECT asp.c#person_id,
                                         asp.c#account_id,
                                         a.c#num,
                                         asp.c#date,
                                         NVL(LEAD(asp.c#date)
                                         OVER (PARTITION BY
                                         asp.c#account_id
                                         ORDER BY
                                         asp.c#date),
                                         fcr.p#mn_utils.GET#DATE(a#mn_end + 1)) "C#NEXT_DATE"
--                                         fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                FROM v#account_spec asp
                                  INNER JOIN t#account a
                                    ON (a.c#id =
                                    asp.c#account_id)
                                WHERE 1 = 1
                                  AND asp.c#valid_tag = 'Y'
                                  AND asp.c#account_id IN (SELECT c#account_id
                                      FROM v#account_spec
                                      WHERE 1 = 1
                                        AND c#valid_tag = 'Y'
                                        AND c#person_id =
                                        a#person_id)) t2
                            WHERE c#person_id = a#person_id) t
                          ON (tc.c#account_id = t.c#account_id
--                          AND tc.c#a_mn <
                          AND tc.c#a_mn between a#mn_begin and
                          fcr.p#mn_utils.GET#MN(t.c#next_date)-1)
                        LEFT JOIN (SELECT vw.C#ID,
                                          vw.c#date,
                                          tobj.c#account_id,
                                          vw.c#tar_val
                            FROM fcr.v#obj tobj
                              INNER JOIN fcr.v#work vw
                                ON (tobj.c#work_id = vw.c#id)) v
                          ON (v.c#account_id = tc.c#account_id
                          AND tc.c#work_id = v.c#id)
                      WHERE 1 = 1
                      GROUP BY t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                               'mm.yyyy'),
                               tc.c#account_id,
                               v.c#tar_val) t1
                  GROUP BY 
                  
                           t1.c#person_id,
                           t1.m,
                           t1.c#account_id
--                           t1.c#tar_val
                           ) ch
                LEFT JOIN (SELECT c#account_id,
                                  m,
                                  SUM(sum_op) sum_op
                    FROM (SELECT vop.c#account_id,
                                 TO_CHAR(CASE 
                                    WHEN (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id) > c#real_date
                                    then (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id)
                                 
                                    WHEN MONTHS_BETWEEN(c#real_date, (SELECT c#end_date
                                         FROM v#account va
                                         WHERE va.c#id =
                                           vop.c#account_id)) > -1 THEN CASE WHEN (SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id) > (SELECT c#date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id) THEN ADD_MONTHS((SELECT c#end_date
                                                 FROM v#account va
                                                 WHERE va.c#id =
                                                   vop.c#account_id),
                                             -1) ELSE (SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id = vop.c#account_id) END ELSE CASE WHEN MONTHS_BETWEEN(c#real_date,
                                         t.c#next_date) > -1 THEN ADD_MONTHS(t.c#next_date, -1) ELSE c#real_date END END,
                                 'mm.yyyy') m,
                                 SUM(c#sum) sum_op
                        FROM fcr.v#op vop
                          INNER JOIN (SELECT *
                              FROM (SELECT asp.c#person_id,
                                           asp.c#account_id,
                                           a.c#num,
                                           asp.c#date,
                                           NVL(LEAD(asp.c#date)
                                           OVER (PARTITION BY
                                           asp.c#account_id
                                           ORDER BY
                                           asp.c#date),
                                           fcr.p#mn_utils.GET#DATE(a#mn_end + 1)) "C#NEXT_DATE"
--                                           fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                  FROM v#account_spec asp
                                    INNER JOIN t#account a
                                      ON (a.c#id =
                                      asp.c#account_id)
                                  WHERE 1 = 1
                                    AND asp.c#valid_tag = 'Y'
                                    AND asp.c#account_id IN (SELECT c#account_id
                                        FROM v#account_spec
                                        WHERE 1 = 1
                                          AND c#valid_tag = 'Y'
                                          AND c#person_id = a#person_id)) t2
                              WHERE c#person_id =
                                a#person_id) t
                            ON (vop.c#account_id = t.c#account_id
--                            AND vop.c#a_mn <

                            AND vop.c#a_mn between a#mn_begin and
                            fcr.p#mn_utils.GET#MN(t.c#next_date)-1)
                        WHERE 1 = 1
                        GROUP BY vop.c#account_id,
                                 c#real_date,
                                 t.c#next_date) t
                    GROUP BY c#account_id,
                             m) op
                  ON (ch.m = op.m
                  AND ch.c#account_id = op.c#account_id)
              GROUP BY ch.m,
                       ch.c#account_id) r
            ON (r.c#account_id = a.C#ID)
        GROUP BY fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID),
                 a.C#NUM,
                 a.c#id,
                 a.C#DATE,
                 a.C#END_DATE
        HAVING
             SUM(r.nach) <> 0
             OR SUM(opl) <> 0
        ORDER BY fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID),
                 a.C#NUM;
      RETURN res;
    END;


PROCEDURE LST#REESTR2(a#person_id  INTEGER) IS
      a#mn_begin NUMBER;
      a#mn_end NUMBER;
    BEGIN
        a#mn_begin := 162;
        a#mn_end := fcr.p#utils.GET#OPEN_MN;

    delete from TT_LST#REESTR;
    COMMIT;
    insert into TT_LST#REESTR
      SELECT a.C#NUM,
             fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID) AS address,
             a.C#DATE AS date_begin,
             a.C#END_DATE AS date_end,
             (SELECT SUM(vrs.C#AREA_VAL)
                 FROM fcr.v#account va
                   INNER JOIN fcr.v#rooms_spec vrs
                     ON (va.c#rooms_id = vrs.c#rooms_id)
                 WHERE va.c#id = a.c#id) AS area,
             SUM(r.nach) AS charge,
             SUM(opl) AS opl
        FROM (SELECT *
            FROM v#account
              ) a
          INNER JOIN (SELECT ch.m,
                             ch.c#account_id,
                             SUM(ch.nach) nach,
                             SUM(NVL(op.sum_op, 0)) opl
              FROM (SELECT t1.m,
                           t1.c#account_id,
                           SUM(nach) nach
                  FROM (SELECT 
                        t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                               'mm.yyyy') m,
                               tc.c#account_id,
                               v.c#tar_val,
                               SUM(tc.c#sum) nach
                      FROM fcr.t#charge tc
                        INNER JOIN (SELECT *
                            FROM (SELECT asp.c#person_id,
                                         asp.c#account_id,
                                         a.c#num,
                                         asp.c#date,
                                         NVL(LEAD(asp.c#date)
                                         OVER (PARTITION BY
                                         asp.c#account_id
                                         ORDER BY
                                         asp.c#date),
                                         fcr.p#mn_utils.GET#DATE(a#mn_end + 1)) "C#NEXT_DATE"
--                                         fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                FROM v#account_spec asp
                                  INNER JOIN t#account a
                                    ON (a.c#id =
                                    asp.c#account_id)
                                WHERE 1 = 1
                                  AND asp.c#valid_tag = 'Y'
                                  AND asp.c#account_id IN (SELECT c#account_id
                                      FROM v#account_spec
                                      WHERE 1 = 1
                                        AND c#valid_tag = 'Y'
                                        AND c#person_id =
                                        a#person_id)) t2
                            WHERE c#person_id = a#person_id) t
                          ON (tc.c#account_id = t.c#account_id
--                          AND tc.c#a_mn <
                          AND tc.c#a_mn between a#mn_begin and
                          fcr.p#mn_utils.GET#MN(t.c#next_date))
                        LEFT JOIN (SELECT vw.C#ID,
                                          vw.c#date,
                                          tobj.c#account_id,
                                          vw.c#tar_val
                            FROM fcr.v#obj tobj
                              INNER JOIN fcr.v#work vw
                                ON (tobj.c#work_id = vw.c#id)) v
                          ON (v.c#account_id = tc.c#account_id
                          AND tc.c#work_id = v.c#id)
                      WHERE 1 = 1
                      GROUP BY t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                               'mm.yyyy'),
                               tc.c#account_id,
                               v.c#tar_val) t1
                  GROUP BY 
                  
                           t1.c#person_id,
                           t1.m,
                           t1.c#account_id
--                           t1.c#tar_val
                           ) ch
                LEFT JOIN (SELECT c#account_id,
                                  m,
                                  SUM(sum_op) sum_op
                    FROM (SELECT vop.c#account_id,
                                 TO_CHAR(CASE 
                                    WHEN (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id) > c#real_date
                                    then (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id)
                                 
                                    WHEN MONTHS_BETWEEN(c#real_date, (SELECT c#end_date
                                         FROM v#account va
                                         WHERE va.c#id =
                                           vop.c#account_id)) > -1 THEN CASE WHEN (SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id) > (SELECT c#date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id) THEN ADD_MONTHS((SELECT c#end_date
                                                 FROM v#account va
                                                 WHERE va.c#id =
                                                   vop.c#account_id),
                                             -1) ELSE (SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id = vop.c#account_id) END ELSE CASE WHEN MONTHS_BETWEEN(c#real_date,
                                         t.c#next_date) > -1 THEN ADD_MONTHS(t.c#next_date, -1) ELSE c#real_date END END,
                                 'mm.yyyy') m,
                                 SUM(c#sum) sum_op
                        FROM fcr.v#op vop
                          INNER JOIN (SELECT *
                              FROM (SELECT asp.c#person_id,
                                           asp.c#account_id,
                                           a.c#num,
                                           asp.c#date,
                                           NVL(LEAD(asp.c#date)
                                           OVER (PARTITION BY
                                           asp.c#account_id
                                           ORDER BY
                                           asp.c#date),
                                           fcr.p#mn_utils.GET#DATE(a#mn_end + 1)) "C#NEXT_DATE"
--                                           fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                  FROM v#account_spec asp
                                    INNER JOIN t#account a
                                      ON (a.c#id =
                                      asp.c#account_id)
                                  WHERE 1 = 1
                                    AND asp.c#valid_tag = 'Y'
                                    AND asp.c#account_id IN (SELECT c#account_id
                                        FROM v#account_spec
                                        WHERE 1 = 1
                                          AND c#valid_tag = 'Y'
                                          AND c#person_id = a#person_id)) t2
                              WHERE c#person_id =
                                a#person_id) t
                            ON (vop.c#account_id = t.c#account_id
--                            AND vop.c#a_mn <
                            AND vop.c#a_mn between a#mn_begin and
                            fcr.p#mn_utils.GET#MN(t.c#next_date))
                        WHERE 1 = 1
                        GROUP BY vop.c#account_id,
                                 c#real_date,
                                 t.c#next_date) t
                    GROUP BY c#account_id,
                             m) op
                  ON (ch.m = op.m
                  AND ch.c#account_id = op.c#account_id)
              GROUP BY ch.m,
                       ch.c#account_id) r
            ON (r.c#account_id = a.C#ID)
        GROUP BY fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID),
                 a.C#NUM,
                 a.c#id,
                 a.C#DATE,
                 a.C#END_DATE
                 ;
        COMMIT;         
    END;



  FUNCTION LST#REESTR_OLD(a#person_id INTEGER)
    RETURN sys_refcursor
    IS
      res      sys_refcursor;
      a#mn_end NUMBER;
    BEGIN
      SELECT fcr.p#utils.get#open_mn
        INTO a#mn_end
        FROM dual;
      OPEN res FOR
      SELECT a.C#NUM,
             fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID) AS address,
             a.C#DATE AS date_begin,
             a.C#END_DATE AS date_end,
             (SELECT SUM(vrs.C#AREA_VAL)
                 FROM fcr.v#account va
                   INNER JOIN fcr.v#rooms_spec vrs
                     ON (va.c#rooms_id = vrs.c#rooms_id)
                 WHERE va.c#id = a.c#id) AS area,
             SUM(r.nach) AS charge,
             SUM(opl) AS opl
        FROM (SELECT *
            FROM v#account
            WHERE 1 = 1
              AND c#end_date IS NULL
              OR c#date <> c#end_date
              ) a
          INNER JOIN (SELECT ch.m,
                             ch.c#account_id,
                             SUM(ch.nach) nach,
                             SUM(NVL(op.sum_op, 0)) opl
              FROM (SELECT t1.m,
                           t1.c#account_id,
                           SUM(nach) nach
                  FROM (SELECT 
                        t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                               'mm.yyyy') m,
                               tc.c#account_id,
                               v.c#tar_val,
                               SUM(tc.c#sum) nach
                      FROM fcr.t#charge tc
                        INNER JOIN (SELECT *
                            FROM (SELECT asp.c#person_id,
                                         asp.c#account_id,
                                         a.c#num,
                                         asp.c#date,
                                         NVL(LEAD(asp.c#date)
                                         OVER (PARTITION BY
                                         asp.c#account_id
                                         ORDER BY
                                         asp.c#date),
                                         fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                FROM v#account_spec asp
                                  INNER JOIN t#account a
                                    ON (a.c#id =
                                    asp.c#account_id)
                                WHERE 1 = 1
                                  AND asp.c#valid_tag = 'Y'
                                  AND asp.c#account_id IN (SELECT c#account_id
                                      FROM v#account_spec
                                      WHERE 1 = 1
                                        AND c#valid_tag = 'Y'
                                        AND c#person_id =
                                        a#person_id)) t2
                            WHERE c#person_id = a#person_id) t
                          ON (tc.c#account_id = t.c#account_id
                          AND tc.c#a_mn <
                          fcr.p#mn_utils.GET#MN(t.c#next_date))
                        LEFT JOIN (SELECT vw.C#ID,
                                          vw.c#date,
                                          tobj.c#account_id,
                                          vw.c#tar_val
                            FROM fcr.v#obj tobj
                              INNER JOIN fcr.v#work vw
                                ON (tobj.c#work_id = vw.c#id)) v
                          ON (v.c#account_id = tc.c#account_id
                          AND tc.c#work_id = v.c#id)
                      WHERE 1 = 1
                      GROUP BY t.c#person_id,
                               TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                               'mm.yyyy'),
                               tc.c#account_id,
                               v.c#tar_val) t1
                  GROUP BY 
                  
                           t1.c#person_id,
                           t1.m,
                           t1.c#account_id
--                           t1.c#tar_val
                           ) ch
                LEFT JOIN (SELECT c#account_id,
                                  m,
                                  SUM(sum_op) sum_op
                    FROM (SELECT vop.c#account_id,
                                 TO_CHAR(CASE 
                                    WHEN (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id) > c#real_date
                                    then (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id)
                                 
                                    WHEN MONTHS_BETWEEN(c#real_date, (SELECT c#end_date
                                         FROM v#account va
                                         WHERE va.c#id =
                                           vop.c#account_id)) > -1 THEN CASE WHEN (SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id) > (SELECT c#date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id) THEN ADD_MONTHS((SELECT c#end_date
                                                 FROM v#account va
                                                 WHERE va.c#id =
                                                   vop.c#account_id),
                                             -1) ELSE (SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id = vop.c#account_id) END ELSE CASE WHEN MONTHS_BETWEEN(c#real_date,
                                         t.c#next_date) > -1 THEN ADD_MONTHS(t.c#next_date, -1) ELSE c#real_date END END,
                                 'mm.yyyy') m,
                                 SUM(c#sum) sum_op
                        FROM fcr.v#op vop
                          INNER JOIN (SELECT *
                              FROM (SELECT asp.c#person_id,
                                           asp.c#account_id,
                                           a.c#num,
                                           asp.c#date,
                                           NVL(LEAD(asp.c#date)
                                           OVER (PARTITION BY
                                           asp.c#account_id
                                           ORDER BY
                                           asp.c#date),
                                           fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                  FROM v#account_spec asp
                                    INNER JOIN t#account a
                                      ON (a.c#id =
                                      asp.c#account_id)
                                  WHERE 1 = 1
                                    AND asp.c#valid_tag = 'Y'
                                    AND asp.c#account_id IN (SELECT c#account_id
                                        FROM v#account_spec
                                        WHERE 1 = 1
                                          AND c#valid_tag = 'Y'
                                          AND c#person_id = a#person_id)) t2
                              WHERE c#person_id =
                                a#person_id) t
                            ON (vop.c#account_id = t.c#account_id
                            AND vop.c#a_mn <
                            fcr.p#mn_utils.GET#MN(t.c#next_date))
                        WHERE 1 = 1
                        GROUP BY vop.c#account_id,
                                 c#real_date,
                                 t.c#next_date) t
                    GROUP BY c#account_id,
                             m) op
                  ON (ch.m = op.m
                  AND ch.c#account_id = op.c#account_id)
              GROUP BY ch.m,
                       ch.c#account_id) r
            ON (r.c#account_id = a.C#ID)
        GROUP BY fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID),
                 a.C#NUM,
                 a.c#id,
                 a.C#DATE,
                 a.C#END_DATE
--        HAVING
--             SUM(r.nach) <> 0
--             OR SUM(opl) <> 0
        ORDER BY fcr.p#utils.GET#ROOMS_ADDR(a.C#ROOMS_ID),
                 a.C#NUM;
      RETURN res;
    END;




  FUNCTION LST#AKT_F_OLD(a#num    VARCHAR2,
                         a#dbegin VARCHAR2,
                         a#dend   VARCHAR2)
    RETURN sys_refcursor
    IS
      res          sys_refcursor;
      a#date_begin DATE;
      a#date_end   DATE;
      a#mn_begin   INTEGER;
      a#mn_end     INTEGER;
    BEGIN
      a#date_begin := TO_DATE(a#dbegin, 'dd.mm.yyyy');
      a#date_end := TO_DATE(a#dend, 'dd.mm.yyyy');
      SELECT fcr.p#mn_utils.Get#MN(a#date_begin)
        INTO a#mn_begin
        FROM dual;
      SELECT fcr.p#mn_utils.Get#MN(a#date_end)
        INTO a#mn_end
        FROM dual;
      OPEN res FOR SELECT FCR.P#UTILS.GET#PERSON_NAME(acc.c#person_id)
                          AS
                          "FIO",
                          FCR.P#UTILS.GET#ROOMS_ADDR(acc.c#rooms_id)
                          AS
                          "address",
                          op.c#name
                          AS
                          "RKC",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN CASE WHEN acc.c#part_coef <> 0 THEN r.c#area_val * acc.c#part_coef ELSE r.c#area_val END END
                          AS
                          "area",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN TO_CHAR(FCR.P#MN_UTILS.GET#DATE(tch.c#a_mn), 'mm.yyyy') END
                          AS
                          "m_date",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN ROUND(tch.c#sum / CASE WHEN acc.c#part_coef <> 0 THEN r.c#area_val * acc.c#part_coef ELSE r.c#area_val END, 2) ELSE 0 END
                          AS
                          "tarif",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN tch.c#sum ELSE 0 END
                          AS
                          "nach",
                          vop.c#real_date
                          AS
                          "date_opl",
                          NVL(vop.c#sum, 0)
                          AS
                          "opl"
        FROM (SELECT a.c#id,
                     a.c#num,
                     asp.c#person_id,
                     a.c#rooms_id,
                     asp.c#part_coef
            FROM fcr.v#account a
              INNER JOIN fcr.v#account_spec asp
                ON (a.c#id = asp.c#account_id)
            WHERE asp.c#valid_tag = 'Y') acc
          INNER JOIN (SELECT *
              FROM fcr.t#rooms t1
                INNER JOIN fcr.v#rooms_spec t2
                  ON (t1.c#id = t2.c#rooms_id)) r
            ON (r.c#rooms_id = acc.c#rooms_id)
          LEFT JOIN (SELECT c#account_id,
                            c#work_id,
                            c#doer_id,
                            c#a_mn,
                            SUM(c#vol) AS c#vol,
                            SUM(c#sum) AS c#sum
              FROM fcr.t#charge
              GROUP BY c#account_id,
                       c#work_id,
                       c#doer_id,
                       c#a_mn
              HAVING SUM(c#vol) > 0
                AND SUM(c#sum) > 0) tch
            ON (tch.c#account_id = acc.c#id)
          LEFT JOIN (SELECT c#account_id,
                            c#date,
                            top.c#name
              FROM (SELECT c#account_id,
                           c#date,
                           taop.C#OUT_PROC_ID,
                           taop.C#OUT_NUM
                  FROM fcr.t#account_op taop) aop
                LEFT JOIN (SELECT c#id,
                                  c#name
                    FROM fcr.t#out_proc) top
                  ON (top.c#id = aop.c#out_proc_id)) op
            ON (op.c#account_id = tch.c#account_id
            AND op.c#date = (SELECT MAX(c#date)
                FROM fcr.t#account_op
                WHERE c#account_id = tch.c#account_id
                  AND c#date <= fcr.p#mn_utils.get#date(tch.c#a_mn)))
          LEFT JOIN (SELECT c#account_id,
                            c#real_date,
                            SUM(NVL(c#sum, 0)) AS c#sum
              FROM fcr.v#op
              WHERE c#type_tag = 'P'
              GROUP BY c#account_id,
                       c#real_date
              HAVING SUM(NVL(c#sum, 0)) > 0) vop
            ON (tch.c#account_id = vop.c#account_id
            AND tch.c#a_mn = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))
        WHERE acc.c#num = a#num
          AND tch.c#a_mn BETWEEN FCR.P#MN_UTILS.GET#MN(a#date_begin) AND FCR.P#MN_UTILS.GET#MN(a#date_end)
        ORDER BY tch.c#a_mn,
                 tch.c#a_mn,
                 vop.c#real_date;
      RETURN res;
    END;





  FUNCTION LST#AKT(a#person_id INTEGER,
                   a#dbegin    VARCHAR2,
                   a#dend      VARCHAR2)
    RETURN sys_refcursor
    IS
      res          sys_refcursor;
      a#date_begin DATE;
      a#date_end   DATE;
      a#mn_begin   INTEGER;
      a#mn_end     INTEGER;
    BEGIN
      a#date_begin := TO_DATE(a#dbegin, 'dd.mm.yyyy');
      a#date_end := TO_DATE(a#dend, 'dd.mm.yyyy');
      SELECT fcr.p#mn_utils.Get#MN(a#date_begin)
        INTO a#mn_begin
        FROM dual;
      SELECT fcr.p#mn_utils.Get#MN(a#date_end)
        INTO a#mn_end
        FROM dual;

      OPEN res FOR
      SELECT tall.fio,
             tall.m_date,
             tall.tarif,
             SUM(nach) / tall.tarif area,
             SUM(nach) nach,
             SUM(opl) opl,
             SUM(dolg) dolg
        FROM (SELECT (SELECT FCR.P#UTILS.GET#PERSON_NAME(ch.c#person_id)
                         FROM dual) fio,
                     ch.m m_date,
                     ch.c#tar_val tarif,
                     SUM(ch.nach) nach,
                     SUM(NVL(op.sum_op, 0)) opl,
                     SUM(ch.nach) - SUM(NVL(op.sum_op, 0)) dolg
            FROM (SELECT t1.c#person_id,
                         t1.m,
                         t1.c#account_id,
--                         t1.c#tar_val,
                         max(t1.c#tar_val) c#tar_val,
                         SUM(nach) nach
                FROM (SELECT t.c#person_id,
                             TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                             'mm.yyyy') m,
                             tc.c#account_id,
--                             v.c#tar_val,
                             max(v.c#tar_val) c#tar_val,
                             SUM(tc.c#sum) nach
                    FROM fcr.t#charge tc
                      INNER JOIN (SELECT *
                          FROM (SELECT asp.c#person_id,
                                       asp.c#account_id,
                                       a.c#num,
                                       asp.c#date,
                                       NVL(LEAD(asp.c#date)
                                       OVER (PARTITION BY
                                       asp.c#account_id
                                       ORDER BY
                                       asp.c#date),
                                       fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                              FROM v#account_spec asp
                                INNER JOIN t#account a
                                  ON (a.c#id =
                                  asp.c#account_id)
                              WHERE 1 = 1
                                AND asp.c#valid_tag = 'Y'
                                AND asp.c#account_id IN (SELECT c#account_id
                                    FROM v#account_spec
                                    WHERE 1 = 1
                                      AND c#valid_tag = 'Y'
                                      AND c#person_id =
                                      a#person_id)) t2
                          WHERE c#person_id = a#person_id) t
                        ON (tc.c#account_id = t.c#account_id
                        AND tc.c#a_mn <=
                        fcr.p#mn_utils.GET#MN(t.c#next_date))
                      LEFT JOIN (SELECT vw.C#ID,
                                        vw.c#date,
                                        tobj.c#account_id,
                                        vw.c#tar_val
                          FROM fcr.v#obj tobj
                            INNER JOIN fcr.v#work vw
                              ON (tobj.c#work_id = vw.c#id)) v
                        ON (v.c#account_id = tc.c#account_id
                        AND tc.c#work_id = v.c#id)
                    WHERE 1 = 1
                    GROUP BY t.c#person_id,
                             TO_CHAR(P#MN_UTILS.GET#DATE(tc.c#a_mn),
                             'mm.yyyy'),
                             tc.c#account_id
--                             ,v.c#tar_val
                             ) t1
                GROUP BY t1.c#person_id,
                         t1.m,
                         t1.c#account_id
--                         ,t1.c#tar_val
                         ) ch
              LEFT JOIN (SELECT c#account_id,
                                m,
                                SUM(sum_op) sum_op
                  FROM (SELECT vop.c#account_id,
                               TO_CHAR(CASE 
                                WHEN (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id) > c#real_date
                                then (SELECT c#date FROM v#account va WHERE va.c#id =  vop.c#account_id)
                               
                               WHEN MONTHS_BETWEEN(c#real_date, (SELECT c#end_date
                                       FROM v#account va
                                       WHERE va.c#id =
                                         vop.c#account_id)) > -1 THEN CASE WHEN (SELECT c#end_date
                                             FROM v#account va
                                             WHERE va.c#id =
                                               vop.c#account_id) > (SELECT c#date
                                             FROM v#account va
                                             WHERE va.c#id =
                                               vop.c#account_id) THEN ADD_MONTHS((SELECT c#end_date
                                               FROM v#account va
                                               WHERE va.c#id =
                                                 vop.c#account_id),
                                           -1) ELSE (SELECT c#end_date
                                             FROM v#account va
                                             WHERE va.c#id = vop.c#account_id) END ELSE CASE WHEN MONTHS_BETWEEN(c#real_date,
                                       t.c#next_date) > -1 THEN ADD_MONTHS(t.c#next_date, -1) ELSE c#real_date END END,
                               'mm.yyyy') m,
                               SUM(c#sum) sum_op
                      FROM fcr.v#op vop
                        INNER JOIN (SELECT *
                            FROM (SELECT asp.c#person_id,
                                         asp.c#account_id,
                                         a.c#num,
                                         asp.c#date,
                                         NVL(LEAD(asp.c#date)
                                         OVER (PARTITION BY
                                         asp.c#account_id
                                         ORDER BY
                                         asp.c#date),
                                         fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                FROM v#account_spec asp
                                  INNER JOIN t#account a
                                    ON (a.c#id =
                                    asp.c#account_id)
                                WHERE 1 = 1
                                  AND asp.c#valid_tag = 'Y'
                                  AND asp.c#account_id IN (SELECT c#account_id
                                      FROM v#account_spec
                                      WHERE 1 = 1
                                        AND c#valid_tag = 'Y'
                                        AND c#person_id =
                                        a#person_id)) t2
                            WHERE c#person_id =
                              a#person_id) t
                          ON (vop.c#account_id = t.c#account_id
                          AND vop.c#a_mn <=
                          fcr.p#mn_utils.GET#MN(t.c#next_date))
                      WHERE 1 = 1
                      GROUP BY vop.c#account_id,
                               c#real_date,
                               t.c#next_date) t
                  GROUP BY c#account_id,
                           m) op
                ON (ch.m = op.m
                AND ch.c#account_id = op.c#account_id)
            GROUP BY ch.c#person_id,
                     ch.m,
                     ch.c#tar_val) tall
        GROUP BY tall.fio,
                 tall.m_date,
                 tall.tarif
        HAVING 
            TO_DATE('01.' || tall.m_date, 'dd.mm.yyyy') >= a#date_begin
            AND TO_DATE('01.' || tall.m_date, 'dd.mm.yyyy') <= a#date_end
        ORDER BY TO_DATE(tall.m_date, 'mm.yyyy');
      RETURN res;
    END;

  FUNCTION LST#PAY_NOT_J(a#person_id INTEGER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT va.c#id,
             va.c#num,
             c#work_id,
             c#doer_id,
             c#real_date,
             c#cod,
             c#name,
             SUM(c#sum)
        FROM fcr.v#account va
          INNER JOIN fcr.v#op vop
            ON (va.c#id = vop.c#account_id)
          INNER JOIN (SELECT ops.c#id,
                             ok.c#cod,
                             ok.c#name
              FROM fcr.v#ops ops
                INNER JOIN fcr.t#ops_kind ok
                  ON (ops.C#KIND_ID = ok.c#id)) o
            ON (vop.c#ops_id = o.c#id)
        WHERE 1 = 1
          AND NOT o.c#cod IN (90, 91)
          AND c#account_id IN (SELECT DISTINCT c#account_id
              FROM fcr.v#account_spec vas
              WHERE c#person_id = a#person_id)
        GROUP BY va.c#id,
                 va.c#num,
                 c#work_id,
                 c#doer_id,
                 c#real_date,
                 c#cod,
                 c#name
        HAVING SUM(c#sum) <> 0
        ORDER BY va.c#num;
      RETURN res;
    END;

  FUNCTION LST#PAY_CODE_OPS(a#person_id INTEGER)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT c#cod,
             c#name,
             c#real_date,
             sum_op
        FROM (SELECT o.c#cod,
                     o.c#name,
                     TO_CHAR(c#real_date, 'mm.yyyy') c#real_date,
                     SUM(NVL(c#sum, 0)) sum_op
            FROM fcr.v#op vop
              INNER JOIN (SELECT ops.c#id,
                                 ok.c#cod,
                                 ok.c#name
                  FROM fcr.v#ops ops
                    INNER JOIN fcr.t#ops_kind ok
                      ON (ops.C#KIND_ID = ok.c#id)) o
                ON (vop.c#ops_id = o.c#id)
            WHERE 1 = 1
              AND c#account_id IN (SELECT DISTINCT c#account_id
                  FROM fcr.v#account_spec vas
                  WHERE c#person_id = a#person_id)
            GROUP BY TO_CHAR(c#real_date, 'mm.yyyy'),
                     o.c#cod,
                     o.c#name
            union all
            select '444','Нераспределенный остаток',TO_CHAR(sysdate,'mm.yyyy'),P#UTILS.GET#OSTATOK_J(a#person_id) from dual
                     ) t
        ORDER BY TO_DATE('01.' || t.c#real_date, 'dd.mm.yyyy');
        
      RETURN res;
    END;


  FUNCTION LST#REP_PROPERTLY_OMSU(a#date_begin DATE,
                                  a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res      sys_refcursor;
      a#mn_end NUMBER;
    BEGIN
      SELECT fcr.p#utils.get#open_mn
        INTO a#mn_end
        FROM dual;
      OPEN res FOR
      SELECT TRIM(SUBSTR(fcr.p#utils.get#house_addr(t.c#house_id), 1, INSTR(fcr.p#utils.get#house_addr(t.c#house_id), ' ') - 1)) omsu,
             CASE WHEN t.tp LIKE 'FED' THEN 'Федеральная собственность' WHEN t.tp LIKE 'OBL' THEN 'Собственность субьекта' WHEN (t.tp LIKE 'OMS') OR
                 (t.tp LIKE 'MBU') OR
                 (t.tp LIKE 'GUP') OR
                 (t.tp LIKE 'MKU') THEN 'Собственность ОМС' WHEN t.tp LIKE 'F' THEN 'Физ. лица' ELSE 'Остальные' END sobst,
             COUNT(t.c#account_id) AS "Счета",
             SUM(NVL(t.c#area_val, 0)) AS "Площадь",
             SUM(NVL(t.c#sum, 0)) "Начислено",
             SUM(NVL(t.p#sum, 0)) "Оплачено",
             SUM(NVL(t.c#sum, 0) - NVL(t.p#sum, 0)) "Долг"
        FROM (SELECT vc.tp,
                     vc.c#account_id,
                     NVL(acc.c#id, 0) c#id,
                     acc.c#house_id,
                     acc.c#area_val,
                     vc.c#sum,
                     vc.p#sum
            FROM (SELECT c.c#account_id,
                         c.tp,
                         SUM(NVL(c.c#sum, 0)) c#sum,
                         SUM(NVL(v.c#sum, 0)) p#sum
                     FROM (SELECT tc.c#account_id,
                                  pc.tp,
                                  SUM(NVL(tc.c#sum, 0)) AS c#sum
                         FROM (SELECT *
                             FROM fcr.t#charge) tc
                           INNER JOIN (SELECT td.c#account_id,
                                              td.c#person_id,
                                              td.c#date,
                                              td.c#next_date,
                                              CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#tip_ul, 'O') ELSE NVL(pj.c#tip_ul, 'F') END tp
                               FROM (SELECT asp.c#person_id,
                                            asp.c#account_id,
                                            a.c#num,
                                            asp.c#date,
                                            NVL(LEAD(asp.c#date) OVER (PARTITION BY asp.c#account_id ORDER BY asp.c#date),
                                            fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                   FROM v#account_spec asp
                                     INNER JOIN t#account a
                                       ON (a.c#id = asp.c#account_id)
                                   WHERE 1 = 1
                                     AND asp.c#valid_tag = 'Y') td
                                 LEFT JOIN fcr.t#person_j pj
                                   ON (td.c#person_id = pj.c#person_id)) pc
                             ON (tc.c#account_id = pc.c#account_id
                             AND tc.c#a_mn >= fcr.p#mn_utils.GET#MN(pc.c#date)
                             AND tc.c#a_mn < fcr.p#mn_utils.GET#MN(pc.c#next_date))
                         WHERE tc.c#a_mn >= fcr.p#mn_utils.GET#MN(a#date_begin)
                           AND tc.c#a_mn <= fcr.p#mn_utils.GET#MN(a#date_end)
                         GROUP BY tc.c#account_id,
                                  pc.tp) c
                       LEFT JOIN (SELECT vop.c#account_id,
                                         pv.tp,
                                         SUM(NVL(c#sum, 0)) AS c#sum
                           FROM (SELECT *
                               FROM fcr.v#op) vop
                             INNER JOIN (SELECT td.c#account_id,
                                                td.c#person_id,
                                                td.c#date,
                                                td.c#next_date,
                                                CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#tip_ul, 'O') ELSE NVL(pj.c#tip_ul, 'F') END tp
                                 FROM (SELECT asp.c#person_id,
                                              asp.c#account_id,
                                              a.c#num,
                                              asp.c#date,
                                              NVL(LEAD(asp.c#date) OVER (PARTITION BY asp.c#account_id ORDER BY asp.c#date),
                                              fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                     FROM v#account_spec asp
                                       INNER JOIN t#account a
                                         ON (a.c#id = asp.c#account_id)
                                     WHERE 1 = 1
                                       AND asp.c#valid_tag = 'Y') td
                                   LEFT JOIN fcr.t#person_j pj
                                     ON (td.c#person_id = pj.c#person_id)) pv
                               ON (vop.c#account_id = pv.c#account_id
                               AND vop.c#real_date >= pv.c#date
                               AND vop.c#real_date < pv.c#next_date)
                           WHERE vop.c#real_date >= a#date_begin
                             AND vop.c#real_date <= a#date_end
                           GROUP BY vop.c#account_id,
                                    pv.tp) v
                         ON (c.c#account_id = v.c#account_id
                         AND c.tp = v.tp)
                     GROUP BY c.c#account_id,
                              c.tp) vc,
                 (SELECT a.c#id,
                         type_Acc.c#acc_type,
                         tr.c#house_id,
                         c#area_val
                     FROM (SELECT c#id,
                                  c#rooms_id
                         FROM fcr.v#account
                         WHERE (c#end_date IS NULL
                           OR c#end_date > TO_DATE('01.06.2014', 'dd.mm.yyyy')
                           )
                           AND c#valid_tag = 'Y') a
                       INNER JOIN fcr.t#rooms tr
                         ON (a.c#rooms_id = tr.c#id)
                       INNER JOIN (SELECT c#rooms_id,
                                          c#area_val
                           FROM fcr.v#rooms_spec rs
                           WHERE c#date = (SELECT MAX(c#date)
                                 FROM fcr.v#rooms_spec
                                 WHERE c#rooms_id = rs.c#rooms_id)
                           GROUP BY c#rooms_id,
                                    c#area_val) vr
                         ON (tr.c#id = vr.C#ROOMS_ID)
                       INNER JOIN (SELECT c#house_id,
                                          c#acc_type
                           FROM fcr.v#banking tbo
                             INNER JOIN fcr.t#b_account ba
                               ON (tbo.c#b_account_id = ba.c#id)) type_Acc
                         ON (type_acc.c#house_id = tr.c#house_id)
                     WHERE type_Acc.c#acc_type IN (1, 2)
                     GROUP BY a.c#id,
                              type_Acc.c#acc_type,
                              tr.c#house_id,
                              c#area_val) acc
            WHERE 1 = 1
              AND vc.c#account_id = acc.c#id (+)) t
        WHERE c#id <> 0
        --and acc.c#account_id = 207252
        GROUP BY TRIM(SUBSTR(fcr.p#utils.get#house_addr(t.c#house_id), 1, INSTR(fcr.p#utils.get#house_addr(t.c#house_id), ' ') - 1)),
                 CASE WHEN t.tp LIKE 'FED' THEN 'Федеральная собственность' WHEN t.tp LIKE 'OBL' THEN 'Собственность субьекта' WHEN (t.tp LIKE 'OMS') OR
                     (t.tp LIKE 'MBU') OR
                     (t.tp LIKE 'GUP') OR
                     (t.tp LIKE 'MKU') THEN 'Собственность ОМС' WHEN t.tp LIKE 'F' THEN 'Физ. лица' ELSE 'Остальные' END
        ORDER BY CASE WHEN t.tp LIKE 'FED' THEN 'Федеральная собственность' WHEN t.tp LIKE 'OBL' THEN 'Собственность субьекта' WHEN (t.tp LIKE 'OMS') OR
              (t.tp LIKE 'MBU') OR
              (t.tp LIKE 'GUP') OR
              (t.tp LIKE 'MKU') THEN 'Собственность ОМС' WHEN t.tp LIKE 'F' THEN 'Физ. лица' ELSE 'Остальные' END
      ;
      RETURN res;
    END;


  FUNCTION LST#REP_PROPERTLY(a#date_begin DATE,
                             a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res      sys_refcursor;
      a#mn_end NUMBER;
    BEGIN
      SELECT fcr.p#utils.get#open_mn
        INTO a#mn_end
        FROM dual;
      OPEN res FOR
      SELECT CASE WHEN t.tp LIKE 'FED' THEN 'Федеральная собственность' WHEN t.tp LIKE 'OBL' THEN 'Собственность субьекта' WHEN (t.tp LIKE 'OMS') OR
                 (t.tp LIKE 'MBU') OR
                 (t.tp LIKE 'GUP') OR
                 (t.tp LIKE 'MKU') THEN 'Собственность ОМС' WHEN t.tp LIKE 'F' THEN 'Физ. лица' ELSE 'Остальные' END sobst,
             COUNT(t.c#account_id) AS "Счета",
             SUM(NVL(t.c#area_val, 0)) AS "Площадь",
             SUM(NVL(t.c#sum, 0)) "Начислено",
             SUM(NVL(t.p#sum, 0)) "Оплачено",
             SUM(NVL(t.c#sum, 0) - NVL(t.p#sum, 0)) "Долг"
        FROM (SELECT vc.tp,
                     vc.c#account_id,
                     NVL(acc.c#id, 0) c#id,
                     acc.c#area_val,
                     vc.c#sum,
                     vc.p#sum
            FROM (SELECT c.c#account_id,
                         c.tp,
                         SUM(NVL(c.c#sum, 0)) c#sum,
                         SUM(NVL(v.c#sum, 0)) p#sum
                     FROM (SELECT tc.c#account_id,
                                  pc.tp,
                                  SUM(NVL(tc.c#sum, 0)) AS c#sum
                         FROM (SELECT *
                             FROM fcr.t#charge) tc
                           INNER JOIN (SELECT td.c#account_id,
                                              td.c#person_id,
                                              td.c#date,
                                              td.c#next_date,
                                              CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#tip_ul, 'O') ELSE NVL(pj.c#tip_ul, 'F') END tp
                               FROM (SELECT asp.c#person_id,
                                            asp.c#account_id,
                                            a.c#num,
                                            asp.c#date,
                                            NVL(LEAD(asp.c#date) OVER (PARTITION BY asp.c#account_id ORDER BY asp.c#date),
                                            fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                   FROM v#account_spec asp
                                     INNER JOIN t#account a
                                       ON (a.c#id = asp.c#account_id)
                                   WHERE 1 = 1
                                     AND asp.c#valid_tag = 'Y') td
                                 LEFT JOIN fcr.t#person_j pj
                                   ON (td.c#person_id = pj.c#person_id)) pc
                             ON (tc.c#account_id = pc.c#account_id
                             AND tc.c#a_mn >= fcr.p#mn_utils.GET#MN(pc.c#date)
                             AND tc.c#a_mn < fcr.p#mn_utils.GET#MN(pc.c#next_date))
                         WHERE tc.c#a_mn >= fcr.p#mn_utils.GET#MN(a#date_begin)
                           AND tc.c#a_mn <= fcr.p#mn_utils.GET#MN(a#date_end)
                         GROUP BY tc.c#account_id,
                                  pc.tp) c
                       LEFT JOIN (SELECT vop.c#account_id,
                                         pv.tp,
                                         SUM(NVL(c#sum, 0)) AS c#sum
                           FROM (SELECT *
                               FROM fcr.v#op) vop
                             INNER JOIN (SELECT td.c#account_id,
                                                td.c#person_id,
                                                td.c#date,
                                                td.c#next_date,
                                                CASE WHEN pj.c#person_id IS NOT NULL THEN NVL(pj.c#tip_ul, 'O') ELSE NVL(pj.c#tip_ul, 'F') END tp
                                 FROM (SELECT asp.c#person_id,
                                              asp.c#account_id,
                                              a.c#num,
                                              asp.c#date,
                                              NVL(LEAD(asp.c#date) OVER (PARTITION BY asp.c#account_id ORDER BY asp.c#date),
                                              fcr.p#mn_utils.GET#DATE(fcr.p#utils.GET#OPEN_MN + 1)) "C#NEXT_DATE"
                                     FROM v#account_spec asp
                                       INNER JOIN t#account a
                                         ON (a.c#id = asp.c#account_id)
                                     WHERE 1 = 1
                                       AND asp.c#valid_tag = 'Y') td
                                   LEFT JOIN fcr.t#person_j pj
                                     ON (td.c#person_id = pj.c#person_id)) pv
                               ON (vop.c#account_id = pv.c#account_id
                               AND vop.c#real_date >= pv.c#date
                               AND vop.c#real_date < pv.c#next_date)
                           WHERE vop.c#real_date >= a#date_begin
                             AND vop.c#real_date <= a#date_end
                           GROUP BY vop.c#account_id,
                                    pv.tp) v
                         ON (c.c#account_id = v.c#account_id
                         AND c.tp = v.tp)
                     GROUP BY c.c#account_id,
                              c.tp) vc,
                 (SELECT a.c#id,
                         type_Acc.c#acc_type,
                         c#area_val
                     FROM (SELECT c#id,
                                  c#rooms_id
                         FROM fcr.v#account
                         WHERE (c#end_date IS NULL
                           OR c#end_date > TO_DATE('01.06.2014', 'dd.mm.yyyy')
                           )
                           AND c#valid_tag = 'Y') a
                       INNER JOIN fcr.t#rooms tr
                         ON (a.c#rooms_id = tr.c#id)
                       INNER JOIN (SELECT c#rooms_id,
                                          c#area_val
                           FROM fcr.v#rooms_spec rs
                           WHERE c#date = (SELECT MAX(c#date)
                                 FROM fcr.v#rooms_spec
                                 WHERE c#rooms_id = rs.c#rooms_id)
                           GROUP BY c#rooms_id,
                                    c#area_val) vr
                         ON (tr.c#id = vr.C#ROOMS_ID)
                       INNER JOIN (SELECT c#house_id,
                                          c#acc_type
                           FROM fcr.v#banking tbo
                             INNER JOIN fcr.t#b_account ba
                               ON (tbo.c#b_account_id = ba.c#id)) type_Acc
                         ON (type_acc.c#house_id = tr.c#house_id)
                     WHERE type_Acc.c#acc_type IN (1, 2)
                     GROUP BY a.c#id,
                              type_Acc.c#acc_type,
                              c#area_val) acc
            WHERE 1 = 1
              AND vc.c#account_id = acc.c#id (+)) t
        WHERE c#id <> 0
        --and acc.c#account_id = 207252
        GROUP BY CASE WHEN t.tp LIKE 'FED' THEN 'Федеральная собственность' WHEN t.tp LIKE 'OBL' THEN 'Собственность субьекта' WHEN (t.tp LIKE 'OMS') OR
              (t.tp LIKE 'MBU') OR
              (t.tp LIKE 'GUP') OR
              (t.tp LIKE 'MKU') THEN 'Собственность ОМС' WHEN t.tp LIKE 'F' THEN 'Физ. лица' ELSE 'Остальные' END

      ;
      RETURN res;
    END;

  FUNCTION LST#REP_RKC(a#date_begin DATE,
                       a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
          with
            charge as (
                select
                    C#ACCOUNT_ID ACCOUNT_ID,
                    SUM(C#SUM) CHARGE_SUM
                from
                    T#CHARGE CH 
                where 
                    C#MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) and P#MN_UTILS.GET#MN(a#date_end)
                group by
                    C#ACCOUNT_ID
            )
            ,pay as (
                select
                    C#ACCOUNT_ID ACCOUNT_ID,
                    SUM(C#SUM) PAY_SUM
                from
                    V#OP OP
                where 
                    C#TYPE_TAG = 'P'
                    and OP.C#REAL_DATE BETWEEN a#date_begin and a#date_end
                group by
                    C#ACCOUNT_ID
            )
            ,summ as (
                select
                    NVL(charge.ACCOUNT_ID, pay.ACCOUNT_ID) ACCOUNT_ID,
                    NVL(CHARGE_SUM,0) CHARGE_SUM,
                    NVL(PAY_SUM,0) PAY_SUM,
                    NVL(CHARGE_SUM,0)-NVL(PAY_SUM,0) DOLG_SUM
                from 
                    charge
                    full join pay on (charge.ACCOUNT_ID = pay.ACCOUNT_ID)
            )        
            ,rkc as (
                SELECT
                  c#account_id account_id,
                  C#OUT_PROC_ID RKC_ID,
                  op.C#NAME RKC_NAME
                FROM
                  t#account_op ao
                  left join t#out_proc op on (ao.c#out_proc_id = op.c#id)
                WHERE
                  ao.C#DATE = (select max(c#date) from t#account_op ao2 where ao.C#ACCOUNT_ID = ao2.C#ACCOUNT_ID and ao2.C#DATE <= a#date_end)
                  and op.c#id in (1,2,10,8,11,13,3,16,15,189,9)
            )
            ,area as (
              SELECT 
                a.c#id ACCOUNT_ID,
                SUM(rsvd.c#area_val) area_sum
              FROM 
                t#account a,
                t#rooms r,
                t#rooms_spec rs,
                (SELECT *
                 FROM t#rooms_spec_vd rsvd
                 WHERE 1 = 1
                   AND rsvd.c#valid_tag = 'Y'
                   AND rsvd.c#vn = (SELECT MAX(t.c#vn)
                       FROM t#rooms_spec_vd t
                       WHERE t.c#id = rsvd.c#id)) rsvd
              WHERE 
                  a.c#rooms_id = r.c#id
                  AND rs.c#rooms_id = r.c#id
                  AND rs.c#id = rsvd.c#id
                  AND rs.c#date <= a#date_end
              group by 
                a.c#id  
            )
        select
--            RKC_ID,
            RKC_NAME "РКЦ",
            count(AB.ACCOUNT_ID) "Счета",
            SUM(area_sum) "Площадь",
            SUM(CHARGE_SUM) "Начислено",
            SUM(PAY_SUM) "Оплачено",
            SUM(DOLG_SUM) "Долг"
        from
            summ AB
            join rkc on (AB.ACCOUNT_ID = rkc.ACCOUNT_ID)
            join area on (AB.ACCOUNT_ID = area.ACCOUNT_ID)
        group by
            RKC_ID, RKC_NAME
        order by
            count(AB.ACCOUNT_ID) desc
        ;

      RETURN res;
    END;

  FUNCTION LST#REP_OBOROT_HOUSE(a#date_begin VARCHAR2,
                                a#date_end   VARCHAR2)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT type_acc.c#acc_type "Тип счета",
             hi.c#house_id "Идентификатор дома",
             hi.c#prog_num "Номер в программе",
             CASE WHEN hi.c#end_date IS NULL THEN 1 ELSE 0 END "Активно",
             h.c#post_code "Индекс",
             h.addr_path "Район",
             h.c#root_name "Адрес",
             h.c#num "Дом",
             h.c#b_num "Корпус",
             h.c#s_num "Корпус_",
             hi.c#2nd_date "Дата входа",
             hi.c#end_date "Дата выхода",
             hi.c#area_val "Площадь дома",
             NVL(SB.C#0_C_SUM, 0) "Сальдо вх Начислено",
             NVL(SB.C#0_MC_SUM, 0) "Сальдо вх Изм начтсления",
             NVL(SB.C#0_M_SUM, 0) "Сальдо вх Изменения ",
             NVL(SB.C#0_MP_SUM, 0) "Сальдо вх Изм оплаты ",
             NVL(SB.C#0_P_SUM, 0) "Сальдо вх Оплата ",
             NVL(SB.C#0_C_SUM, 0) + NVL(SB.C#0_MC_SUM, 0) + NVL(SB.C#0_M_SUM, 0) - NVL(SB.C#0_MP_SUM, 0) - NVL(SB.C#0_P_SUM, 0) "Сальдо вх Долг нач",
             NVL(SB.C#FC_SUM, 0) "Сальдо вх Сальдо нач пени",
             NVL(SB.C#FP_SUM, 0) "Сальдо вх Сальдо опл пени",
             NVL(SB.C#FC_SUM, 0) - NVL(SB.C#FP_SUM, 0) "Сальдо вх Долг пени",
             NVL(CH.C#1_C_VOL, 0) "Начислено объем"--объем
             ,
             NVL(CH.C#1_C_SUM, 0) "Начисление"--начислено

             ,
             NVL(OP.C#1_MC_SUM, 0) "Оплата Изм нач"--изм. начисления
             ,
             NVL(OP.C#1_M_SUM, 0) "Оплата Изм"--изменения
             ,
             NVL(OP.C#1_MP_SUM, 0) "Оплата Изм опл"--изм. оплаты
             ,
             NVL(OP.C#1_P_SUM, 0) "Оплата"--оплачено

             ,
             NVL(OP.C#1_FC_SUM, 0) "Оплата Пени нач",
             NVL(OP.C#1_FP_SUM, 0) "Оплата Пени опл",
             NVL(SE.C#0_C_SUM, 0) "Сальдо исх Начислено"  --накопл. исх. сальдо
             ,
             NVL(SE.C#0_MC_SUM, 0) "Сальдо исх Изм нач",
             NVL(SE.C#0_M_SUM, 0) "Сальдо исх Изм",
             NVL(SE.C#0_MP_SUM, 0) "Сальдо исх Изм опл",
             NVL(SE.C#0_P_SUM, 0) "Сальдо исх Оплата",
             NVL(SE.C#0_C_SUM, 0) + NVL(SE.C#0_MC_SUM, 0) + NVL(SE.C#0_M_SUM, 0) - NVL(SE.C#0_MP_SUM, 0) - NVL(SE.C#0_P_SUM, 0) "Сальдо исх Долг кон",
             NVL(SE.C#FC_SUM, 0) "Сальдо исх Сальдо нач пени",
             NVL(SE.C#FP_SUM, 0) "Сальдо исх Сальдо опл пени",
             NVL(SE.C#FC_SUM, 0) - NVL(SE.C#FP_SUM, 0) "Сальдо исх Долг пени",
             h_sbor.C#R_NUM "счёт",
             h_sbor.C#R_NAME "Получатель",
             h_sbor.C#R_INN_NUM "инн",
             h_sbor.C#R_KPP_NUM "кпп",
             h_sbor.C#BR_NAME "БАНК",
             h_sbor.C#BR_BIC_NUM "бик",
             h_sbor.C#BR_CA_NUM "корсчёт",
             h_sbor.C#BR_TOWN_NAME "город",
             h_sbor.C#C_SUM "Собрано от населения",
             h_sbor.C#M_SUM "Изменения по счету",
             h_sbor.C#P_SUM "Перечислено на счет",
             h_sbor.C#T_SUM "Потрачено со счета",
             NVL(OLD_DEBT.SUM_DOLG, 0) "Долги более 1 года",
             NVL(NEW_DEBT.SUM_DOLG, 0) "Долги менее 1 года"

        FROM (SELECT h.c#id,
                     h.c#post_code,
                     h.c#id_house,
                     ao.c#id AS raion_id,
                     ao.c#root_name,
                     h.c#num,
                     h.c#b_num,
                     h.c#s_num,
                     FCR.p#utils.get#addr_obj_path(ao.C#ID) addr_path
                 FROM FCR.T#HOUSE H,
                      (SELECT AO.C#ID,
                              CONNECT_BY_ROOT (AO.C#ID) "C#ROOT_ID",
                              LISTAGG (AO.C#NAME || ' ' || AOT.C#ABBR_NAME, ', ') WITHIN GROUP (ORDER BY LEVEL DESC) OVER (PARTITION BY CONNECT_BY_ROOT (AO.C#ID)) "C#ROOT_NAME"
                          --,first_value(AO.C#ID) over (partition by CONNECT_BY_ROOT(AO.C#ID) order by LEVEL desc) "C#TOP_ID"
                          FROM FCR.T#ADDR_OBJ AO,
                               FCR.T#ADDR_OBJ_TYPE AOT
                          WHERE AOT.C#ID = AO.C#TYPE_ID CONNECT BY PRIOR AO.C#PARENT_ID = AO.C#ID) AO
                 WHERE H.C#ADDR_OBJ_ID = AO.C#ROOT_ID
                   AND AO.C#ID IN (SELECT C#ID
                       FROM FCR.T#ADDR_OBJ
                       WHERE C#PARENT_ID IS NULL)) h, -- информация по домам
             FCR.t#HOUSE_INFO hi,
             (SELECT c#house_id,
                     c#acc_type
                 FROM fcr.v#banking tbo
                   INNER JOIN fcr.t#b_account ba
                     ON (tbo.c#b_account_id = ba.c#id)) type_Acc,
             (SELECT R.C#HOUSE_ID,
                     SUM(TT.C#C_VOL) "C#0_C_VOL",
                     SUM(TT.C#C_SUM) "C#0_C_SUM",
                     SUM(TT.C#MC_SUM) "C#0_MC_SUM",
                     SUM(TT.C#M_SUM) "C#0_M_SUM",
                     SUM(TT.C#MP_SUM) "C#0_MP_SUM",
                     SUM(TT.C#P_SUM) "C#0_P_SUM",
                     SUM(TT.C#FC_SUM) "C#FC_SUM",
                     SUM(TT.C#FP_SUM) "C#FP_SUM"
                 FROM FCR.T#STORE T,
                      FCR.T#STORAGE TT,
                      FCR.T#ACCOUNT A,
                      FCR.T#ROOMS R
                 WHERE 1 = 1
                   AND T.C#MN = FCR.P#MN_UTILS.GET#MN(TRUNC(TO_DATE(TRIM(a#date_begin), 'dd.mm.yyyy'), 'MM'))
                   AND TT.C#ACCOUNT_ID = T.C#ACCOUNT_ID
                   AND TT.C#WORK_ID = T.C#WORK_ID
                   AND TT.C#DOER_ID = T.C#DOER_ID
                   AND TT.C#MN = (SELECT MAX(C#MN)
                       FROM FCR.T#STORAGE
                       WHERE C#ACCOUNT_ID = T.C#ACCOUNT_ID
                         AND C#WORK_ID = T.C#WORK_ID
                         AND C#DOER_ID = T.C#DOER_ID
                         AND C#MN <= T.C#MN)
                   AND A.C#ID = T.C#ACCOUNT_ID
                   AND R.C#ID = A.C#ROOMS_ID
                 GROUP BY R.C#HOUSE_ID) SB -- сальдо (входящее)
             ,
             (SELECT R.C#HOUSE_ID,
                     SUM(CASE WHEN t.c#mn = FCR.P#MN_UTILS.GET#MN(TRUNC(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 'MM')) THEN T.C#VOL ELSE 0 END) "C#1_C_VOL",
                     SUM(T.C#SUM) "C#1_C_SUM"
                 FROM FCR.T#CHARGE T,
                      FCR.T#ACCOUNT A,
                      FCR.T#ROOMS R
                 WHERE 1 = 1
                   AND T.C#MN >= FCR.P#MN_UTILS.GET#MN(TRUNC(TO_DATE(TRIM(a#date_begin), 'dd.mm.yyyy'), 'MM'))
                   AND T.C#MN <= FCR.P#MN_UTILS.GET#MN(TRUNC(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 'MM'))
                   AND A.C#ID = T.C#ACCOUNT_ID
                   AND R.C#ID = A.C#ROOMS_ID
                 GROUP BY R.C#HOUSE_ID) CH -- начисления
             ,
             (SELECT R.C#HOUSE_ID,
                     SUM(CASE WHEN T.C#TYPE_TAG = 'MC' THEN T.C#SUM END) "C#1_MC_SUM",
                     SUM(CASE WHEN T.C#TYPE_TAG = 'M' THEN T.C#SUM END) "C#1_M_SUM",
                     SUM(CASE WHEN T.C#TYPE_TAG = 'MP' THEN T.C#SUM END) "C#1_MP_SUM",
                     SUM(CASE WHEN T.C#TYPE_TAG = 'P' THEN T.C#SUM END) "C#1_P_SUM",
                     SUM(CASE WHEN T.C#TYPE_TAG = 'FC' THEN T.C#SUM END) "C#1_FC_SUM",
                     SUM(CASE WHEN T.C#TYPE_TAG = 'FP' THEN T.C#SUM END) "C#1_FP_SUM"
                 FROM FCR.V#OP T,
                      FCR.T#ACCOUNT A,
                      FCR.T#ROOMS R
                 WHERE 1 = 1
                   AND T.C#REAL_DATE >= TO_DATE(TRIM(a#date_begin), 'dd.mm.yyyy')
                   AND T.C#REAL_DATE <= LAST_DAY(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'))
                   AND T.C#VALID_TAG = 'Y'
                   AND A.C#ID = T.C#ACCOUNT_ID
                   AND R.C#ID = A.C#ROOMS_ID
                 GROUP BY R.C#HOUSE_ID) OP, -- изменения и оплата
             (SELECT R.C#HOUSE_ID,
                     SUM(TT.C#C_SUM) "C#0_C_SUM",
                     SUM(TT.C#MC_SUM) "C#0_MC_SUM",
                     SUM(TT.C#M_SUM) "C#0_M_SUM",
                     SUM(TT.C#MP_SUM) "C#0_MP_SUM",
                     SUM(TT.C#P_SUM) "C#0_P_SUM",
                     SUM(TT.C#FC_SUM) "C#FC_SUM",
                     SUM(TT.C#FP_SUM) "C#FP_SUM"

                 FROM FCR.T#STORE T,
                      FCR.T#STORAGE TT,
                      FCR.T#ACCOUNT A,
                      FCR.T#ROOMS R
                 WHERE 1 = 1
                   AND T.C#MN = FCR.P#MN_UTILS.GET#MN(TRUNC(ADD_MONTHS(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 1), 'MM'))
                   AND TT.C#ACCOUNT_ID = T.C#ACCOUNT_ID
                   AND TT.C#WORK_ID = T.C#WORK_ID
                   AND TT.C#DOER_ID = T.C#DOER_ID
                   AND TT.C#MN = (SELECT MAX(C#MN)
                       FROM FCR.T#STORAGE
                       WHERE C#ACCOUNT_ID = T.C#ACCOUNT_ID
                         AND C#WORK_ID = T.C#WORK_ID
                         AND C#DOER_ID = T.C#DOER_ID
                         AND C#MN <= T.C#MN)
                   AND A.C#ID = T.C#ACCOUNT_ID
                   AND R.C#ID = A.C#ROOMS_ID
                 GROUP BY R.C#HOUSE_ID) SE -- сальдо (исходящее) 
             ,
             (SELECT S.c#HOUSE_ID,
                     fcr.p#utils.GET#HOUSE_ADDR(S.c#HOUSE_ID, 1),
                     h.c#num,
                     h.c#b_num,
                     h.c#s_num,
                     h.c#post_code,
                     BA.C#ACC_TYPE,
                     ba.c#id,
                     BA.C#NUM "C#R_NUM" --получатель, счёт
                     ,
                     BA.C#NAME "C#R_NAME" --получатель, имя
                     ,
                     BA.C#INN_NUM "C#R_INN_NUM" --получатель, инн
                     ,
                     BA.C#KPP_NUM "C#R_KPP_NUM" --получатель, кпп
                     ,
                     B.C#NAME "C#BR_NAME" --банк получателя, имя
                     ,
                     B.C#BIC_NUM "C#BR_BIC_NUM" --банк получателя, бик
                     ,
                     B.C#CA_NUM "C#BR_CA_NUM" --банк получателя, корсчёт
                     ,
                     B.C#TOWN_NAME "C#BR_TOWN_NAME" --банк получателя, город
                     ,
                     CASE WHEN COUNT(s.c#house_id) > 1 THEN 'K' ELSE 'S' END AS FLG,
                     CASE WHEN COUNT(s.c#house_id) > 1 THEN 'Все дома в котле' ELSE TO_CHAR(MAX(s.c#house_id)) END AS HOUSE_ID,
                     SUM(SG.C#C_SUM) C#C_SUM --"Собрано от населения",
                     ,
                     SUM(SG.C#M_SUM) C#M_SUM--"Изменения по счету",
                     ,
                     SUM(SG.C#P_SUM) C#P_SUM--"Перечислено на счет",
                     ,
                     SUM(SG.C#T_SUM) C#T_SUM--"Потрачено со счета"
                 FROM T#B_STORE S,
                      T#B_STORAGE SG,
                      T#B_ACCOUNT BA,
                      T#BANK B,
                      T#house h
                 WHERE S.C#MN = FCR.P#MN_UTILS.GET#MN(TRUNC(ADD_MONTHS(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 1), 'MM'))
                   AND s.c#house_id = h.c#id
                   AND SG.C#HOUSE_ID = S.C#HOUSE_ID
                   AND SG.C#SERVICE_ID = S.C#SERVICE_ID
                   AND SG.C#B_ACCOUNT_ID = S.C#B_ACCOUNT_ID
                   AND SG.C#MN = (SELECT MAX(C#MN)
                       FROM T#B_STORAGE
                       WHERE 1 = 1
                         AND C#HOUSE_ID = SG.C#HOUSE_ID
                         AND C#SERVICE_ID = SG.C#SERVICE_ID
                         AND C#B_ACCOUNT_ID = SG.C#B_ACCOUNT_ID
                         AND C#MN <= FCR.P#MN_UTILS.GET#MN(TRUNC(ADD_MONTHS(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 1), 'MM')))
                   AND BA.C#ID = S.C#B_ACCOUNT_ID
                   AND B.C#ID = BA.C#BANK_ID
                 GROUP BY ba.c#id,
                          BA.C#ACC_TYPE,
                          BA.C#NUM,
                          BA.C#NAME,
                          BA.C#INN_NUM,
                          BA.C#KPP_NUM,
                          B.C#NAME,
                          B.C#BIC_NUM,
                          B.C#CA_NUM,
                          B.C#TOWN_NAME,
                          S.C#HOUSE_ID,
                          S.c#HOUSE_ID,
                          fcr.p#utils.GET#HOUSE_ADDR(S.c#HOUSE_ID, 1),
                          h.c#num,
                          h.c#b_num,
                          h.c#s_num,
                          h.c#post_code) h_sbor,
             (SELECT R.C#HOUSE_ID,
                     SUM(NVL(T.C#C_SUM, 0) + NVL(T.C#MC_SUM, 0) + NVL(T.C#M_SUM, 0) - NVL(T.C#MP_SUM, 0) - NVL(T.C#P_SUM, 0)) "SUM_DOLG" --Долг всего
                 FROM FCR.V#chop T,
                      FCR.T#ACCOUNT A,
                      FCR.T#ROOMS R
                 WHERE 1 = 1
                   AND T.C#MN <= FCR.P#MN_UTILS.GET#MN(TRUNC(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 'MM'))
                   AND t.c#a_mn <= FCR.P#MN_UTILS.GET#MN(ADD_MONTHS(TRUNC(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 'MM'), -12))
                   AND A.C#ID = T.C#ACCOUNT_ID
                   AND R.C#ID = A.C#ROOMS_ID
                 GROUP BY R.C#HOUSE_ID) OLD_DEBT,
             (SELECT R.C#HOUSE_ID,
                     SUM(NVL(T.C#C_SUM, 0) + NVL(T.C#MC_SUM, 0) + NVL(T.C#M_SUM, 0) - NVL(T.C#MP_SUM, 0) - NVL(T.C#P_SUM, 0)) "SUM_DOLG" --Долг всего
                 FROM FCR.V#chop T,
                      FCR.T#ACCOUNT A,
                      FCR.T#ROOMS R
                 WHERE 1 = 1
                   AND T.C#MN <= FCR.P#MN_UTILS.GET#MN(TRUNC(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 'MM'))
                   AND t.c#a_mn > FCR.P#MN_UTILS.GET#MN(ADD_MONTHS(TRUNC(TO_DATE(TRIM(a#date_end), 'dd.mm.yyyy'), 'MM'), -12))
                   AND A.C#ID = T.C#ACCOUNT_ID
                   AND R.C#ID = A.C#ROOMS_ID
                 GROUP BY R.C#HOUSE_ID) NEW_DEBT
        WHERE 1 = 1
          AND hi.c#house_id = type_acc.c#house_id
          AND type_acc.c#acc_type IN (1, 2)
          AND hi.c#end_date IS NULL
          AND h.c#id = sb.C#HOUSE_ID (+)
          AND h.c#id = ch.C#HOUSE_ID (+)
          AND h.c#id = op.C#HOUSE_ID (+)
          AND h.c#id = se.C#HOUSE_ID (+)
          AND h.c#id = h_sbor.C#HOUSE_ID (+)
          AND hi.c#house_id = h.c#id
          --and h4.id_house = h.c#id_house
          AND h.c#id = old_debt.c#house_id (+)
          AND h.c#id = new_debt.c#house_id (+)
        ORDER BY h.addr_path,
                 h.raion_id,
                 h.c#root_name,
                 h.c#id;
      RETURN res;
    END;


  FUNCTION LST#REP_TYPE_ACCOUNT(a#date_begin DATE,
                                a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR
      SELECT CASE WHEN t.c#acc_type = 1 THEN 'Котел' WHEN t.c#acc_type = 2 THEN 'Спец Счет' END "Счета",
             COUNT(t.c#account_id) AS "Количество счетов",
             SUM(NVL(t.c#area_val, 0)) AS "Площадь",
             SUM(NVL(t.c#sum, 0)) "Начислено",
             SUM(NVL(t.p#sum, 0)) "Оплачено",
             SUM(NVL(t.c#sum, 0) - NVL(t.p#sum, 0)) "Долг"
        FROM (SELECT acc.c#acc_type,
                     vc.c#account_id,
                     NVL(acc.c#account_id, 0) c#id,
                     c#house_id,
                     acc.c#area_val,
                     vc.c#sum,
                     vc.p#sum
            FROM (SELECT ac.c#id c#account_id,
                         type_acc.c#acc_type,
                         r.c#house_id,
                         vrs.c#area_val
                FROM (SELECT *
                    FROM fcr.v#account
                    WHERE (c#end_date IS NULL
                      OR c#end_date > TO_DATE('01.06.2014', 'dd.mm.yyyy'))
                      AND c#valid_tag = 'Y') ac
                  INNER JOIN fcr.t#rooms r
                    ON (ac.c#rooms_id = r.c#id)
                  INNER JOIN (SELECT c#rooms_id,
                                     c#area_val
                      FROM fcr.v#rooms_spec rs
                      WHERE c#date = (SELECT MAX(c#date)
                            FROM fcr.v#rooms_spec
                            WHERE c#rooms_id = rs.c#rooms_id)
                      GROUP BY c#rooms_id,
                               c#area_val) vrs
                    ON (r.c#id = vrs.c#rooms_id)
                  INNER JOIN (SELECT c#house_id,
                                     c#acc_type
                      FROM fcr.v#banking tbo
                        INNER JOIN fcr.t#b_account ba
                          ON (tbo.c#b_account_id = ba.c#id)) type_Acc
                    ON (type_acc.c#house_id = r.c#house_id)
                WHERE type_Acc.c#acc_type IN (1, 2)
                GROUP BY ac.c#id,
                         type_acc.c#acc_type,
                         r.c#house_id,
                         vrs.c#area_val) acc
              RIGHT JOIN (SELECT c.c#account_id,
                                 NVL(c.c#sum, 0) c#sum,
                                 NVL(op.p#sum, 0) p#sum
                  FROM (SELECT c#account_id,
                               SUM(NVL(c#sum, 0)) AS c#sum
                      FROM fcr.t#charge
                      WHERE c#a_mn BETWEEN fcr.p#mn_utils.GET#MN(a#date_begin) AND fcr.p#mn_utils.GET#MN(a#date_end)
                      GROUP BY c#account_id) c
                    LEFT JOIN (SELECT c#account_id,
                                      SUM(NVL(c#sum, 0)) AS p#sum
                        FROM fcr.v#op
                        WHERE c#real_date BETWEEN
                          CASE WHEN (SELECT c#date
                                  FROM v#account
                                  WHERE c#id = c#account_id) > a#date_begin THEN (SELECT c#date
                                    FROM v#account
                                    WHERE c#id = c#account_id) ELSE a#date_begin END
                          AND a#date_end
                        GROUP BY c#account_id) op
                      ON (c.c#account_id = op.c#account_id)) vc
                ON (vc.c#account_id = acc.c#account_id)
            WHERE 1 = 1) t
        WHERE t.c#id <> 0
        --and acc.c#account_id = 207252
        GROUP BY CASE WHEN t.c#acc_type = 1 THEN 'Котел' WHEN t.c#acc_type = 2 THEN 'Спец Счет' END
      ;
      RETURN res;
    END;

-----------------------------------------
  FUNCTION LST#REP_ACCOUNT_SPECIAL(a#date_begin DATE,
                                   a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR

        with
            charges as (
                SELECT
                    C#ACCOUNT_ID,
                    sum(C#SUM) CHARGE_SUM
                from
                    T#CHARGE
                where
                    C#A_MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) and P#MN_UTILS.GET#MN(a#date_end)
                group by
                    C#ACCOUNT_ID
            )
            ,pays as (
                SELECT
                    C#ACCOUNT_ID,
                    sum(C#SUM) PAY_SUM
                from
                    T#OP OP
                    join T#OP_VD VD on (OP.C#ID = VD.C#ID)
                    join V#ACCOUNT VA on (VA.C#ID = OP.C#ACCOUNT_ID)
                where
                    C#REAL_DATE BETWEEN GREATEST(VA.c#date,a#date_begin) and a#date_end
                group by
                    C#ACCOUNT_ID
            )
            ,acc as (
                select
                    A.C#ID c#account_id,
                    H.acc_type c#acc_type,
                    r.c#house_id,
                    r.c#area_val
                from
                    V#ACCOUNT A
                    join V#ROOMS R on (A.C#ROOMS_ID = R.C#ROOMS_ID)
                    join V#HOUSE_ACC_TYPE H on (R.C#HOUSE_ID = H.HOUSE_ID)
                where
                    H.ACC_TYPE in (1,2)
                    and (A.c#end_date IS NULL OR A.c#end_date > TO_DATE('01.06.2014','dd.mm.yyyy'))
                    and  A.c#valid_tag = 'Y'
            )
            ,chp as (
                select
                    regexp_substr(ADDR, '[^ ]+') omsu,
                    C#ACC_TYPE,
                    acc.C#AREA_VAL,
                    CHARGE_SUM,
                    PAY_SUM
                from
                    charges
                    left join pays on (charges.C#ACCOUNT_ID = pays.C#ACCOUNT_ID)
                    join acc on (charges.C#ACCOUNT_ID = acc.c#account_id)
                    join MV_HOUSES_ADRESES ha on (acc.C#HOUSE_ID = ha.HOUSE_ID)
                where
                    C#ACC_TYPE in (1,2)
            )
            ,sums as (
                select
                    omsu,
                    SUM(CASE C#ACC_TYPE WHEN 1 THEN 1 ELSE 0 END) ACC_CNT1,
                    SUM(CASE C#ACC_TYPE WHEN 1 THEN C#AREA_VAL ELSE 0 END) AREA_VAL1,
                    SUM(CASE C#ACC_TYPE WHEN 1 THEN CHARGE_SUM ELSE 0 END) CHARGE_SUM1,
                    SUM(CASE C#ACC_TYPE WHEN 1 THEN PAY_SUM ELSE 0 END) PAY_SUM1,
                    SUM(CASE C#ACC_TYPE WHEN 1 THEN CHARGE_SUM ELSE 0 END)-SUM(CASE C#ACC_TYPE WHEN 1 THEN PAY_SUM ELSE 0 END) DOLG_SUM1,
        
                    SUM(CASE C#ACC_TYPE WHEN 2 THEN 1 ELSE 0 END) ACC_CNT2,
                    SUM(CASE C#ACC_TYPE WHEN 2 THEN C#AREA_VAL ELSE 0 END) AREA_VAL2,
                    SUM(CASE C#ACC_TYPE WHEN 2 THEN CHARGE_SUM ELSE 0 END) CHARGE_SUM2,
                    SUM(CASE C#ACC_TYPE WHEN 2 THEN PAY_SUM ELSE 0 END) PAY_SUM2,
                    SUM(CASE C#ACC_TYPE WHEN 2 THEN CHARGE_SUM ELSE 0 END)-SUM(CASE C#ACC_TYPE WHEN 2 THEN PAY_SUM ELSE 0 END) DOLG_SUM2
                from
                    chp
                group by
                    omsu
            )
        SELECT
            omsu  AS "МО",
            ACC_CNT1  AS "Кол-во счетов",
            AREA_VAL1 AS "Площадь",
            CHARGE_SUM1 AS "Сумма начислено",
            PAY_SUM1 AS "Сумма оплачено",
            DOLG_SUM1 AS "Долг",
        
            ACC_CNT2 AS "Кол-во спец счетов",
            AREA_VAL2 AS "Площадь",
            CHARGE_SUM2 AS "Сумма начислено",
            PAY_SUM2 AS "Сумма оплачено",
            DOLG_SUM2 AS "Долг"
        from
            sums
        order by
            omsu
        ;



      RETURN res;
    END;


-----------------------------------------


  FUNCTION LST#REP_LIVING_ROOMS(a#date_begin DATE,
                                a#date_end   DATE)
    RETURN sys_refcursor
    IS
      res sys_refcursor;
    BEGIN
      OPEN res FOR


        with
            charges as (
                SELECT
                    C#ACCOUNT_ID,
                    sum(C#SUM) CHARGE_SUM
                from
                    T#CHARGE
                where
                    C#A_MN BETWEEN P#MN_UTILS.GET#MN(a#date_begin) and P#MN_UTILS.GET#MN(a#date_end)
                group by
                    C#ACCOUNT_ID
            )
            ,pays as (
                SELECT
                    C#ACCOUNT_ID,
                    sum(C#SUM) PAY_SUM
                from
                    T#OP OP
                    join T#OP_VD VD on (OP.C#ID = VD.C#ID)
                    join V#ACCOUNT VA on (VA.C#ID = OP.C#ACCOUNT_ID)
                where
                    C#REAL_DATE BETWEEN GREATEST(VA.c#date,a#date_begin) and a#date_end
                group by
                    C#ACCOUNT_ID
            )
            ,acc as (
                select
                    A.C#ID c#account_id,
                    H.acc_type c#acc_type,
                    r.c#house_id,
                    r.c#area_val,
                    r.C#LIVING_TAG
                from
                    V#ACCOUNT A
                    join V#ROOMS R on (A.C#ROOMS_ID = R.C#ROOMS_ID)
                    join V#HOUSE_ACC_TYPE H on (R.C#HOUSE_ID = H.HOUSE_ID)
                where
                    H.ACC_TYPE in (1,2)
                    and (A.c#end_date IS NULL OR A.c#end_date > TO_DATE('01.06.2014','dd.mm.yyyy'))
                    and  A.c#valid_tag = 'Y'
            )
            ,chp as (
                select
                    regexp_substr(ADDR, '[^ ]+') omsu,
                    acc.C#LIVING_TAG,
                    acc.C#AREA_VAL,
                    CHARGE_SUM,
                    PAY_SUM
                from
                    charges
                    left join pays on (charges.C#ACCOUNT_ID = pays.C#ACCOUNT_ID)
                    join acc on (charges.C#ACCOUNT_ID = acc.c#account_id)
                    join MV_HOUSES_ADRESES ha on (acc.C#HOUSE_ID = ha.HOUSE_ID)
                where
                    C#ACC_TYPE in (1,2)
            )
            ,sums as (
                select
                    omsu,
                    SUM(CASE C#LIVING_TAG WHEN 'Y' THEN 1 ELSE 0 END) ACC_CNT1,
                    SUM(CASE C#LIVING_TAG WHEN 'Y' THEN C#AREA_VAL ELSE 0 END) AREA_VAL1,
                    SUM(CASE C#LIVING_TAG WHEN 'Y' THEN CHARGE_SUM ELSE 0 END) CHARGE_SUM1,
                    SUM(CASE C#LIVING_TAG WHEN 'Y' THEN PAY_SUM ELSE 0 END) PAY_SUM1,
                    SUM(CASE C#LIVING_TAG WHEN 'Y' THEN CHARGE_SUM ELSE 0 END)-SUM(CASE C#LIVING_TAG WHEN 'Y' THEN PAY_SUM ELSE 0 END) DOLG_SUM1,
        
                    SUM(CASE C#LIVING_TAG WHEN 'N' THEN 1 ELSE 0 END) ACC_CNT2,
                    SUM(CASE C#LIVING_TAG WHEN 'N' THEN C#AREA_VAL ELSE 0 END) AREA_VAL2,
                    SUM(CASE C#LIVING_TAG WHEN 'N' THEN CHARGE_SUM ELSE 0 END) CHARGE_SUM2,
                    SUM(CASE C#LIVING_TAG WHEN 'N' THEN PAY_SUM ELSE 0 END) PAY_SUM2,
                    SUM(CASE C#LIVING_TAG WHEN 'N' THEN CHARGE_SUM ELSE 0 END)-SUM(CASE C#LIVING_TAG WHEN 'N' THEN PAY_SUM ELSE 0 END) DOLG_SUM2
                from
                    chp
                group by
                    omsu
            )
        SELECT
            omsu  AS "МО",
            ACC_CNT1 AS "Счетов с жилыми помещениями",
            AREA_VAL1 AS "Площадь жилых помещений",
            CHARGE_SUM1 AS "Сумма нач на жилые помещения",
            PAY_SUM1 AS "Сумма опл от жилых помещений",
            DOLG_SUM1 AS "Долг жилых помещений",
        
            ACC_CNT2 AS "Счетов с нежилыми помещениями",
            AREA_VAL2 AS "Площадь нежилых помещений",
            CHARGE_SUM2 AS "Сумма нач на нежилые помещения",
            PAY_SUM2 AS "Сумма опл от нежилых помещений",
            DOLG_SUM2 AS "Долг нежилых помещений"
        from
            sums
        order by
            omsu
        ;



--
--      SELECT omsu AS "МО",
--             SUM(NVL(CountAccL, 0)) AS "Счетов с жилыми помещениями",
--             SUM(NVL(AreaL, 0)) AS "Площадь жилых помещений",
--             SUM(NVL(SumOutL, 0)) AS "Сумма нач на жилые помещения",
--             SUM(NVL(SumInL, 0)) AS "Сумма опл от жилых помещений",
--             SUM(NVL(SumResL, 0)) AS "Долг жилых помещений",
--             SUM(NVL(CountAccN, 0)) AS "Счетов с нежилыми помещениями",
--             SUM(NVL(AreaN, 0)) AS "Площадь нежилых помещений",
--             SUM(NVL(SumOutN, 0)) AS "Сумма нач на нежилые помещения",
--             SUM(NVL(SumInN, 0)) AS "Сумма опл от нежилых помещений",
--             SUM(NVL(SumResN, 0)) AS "Долг нежилых помещений"
--        FROM (SELECT TRIM(SUBSTR(fcr.p#utils.get#house_addr(t.c#house_id), 1, INSTR(fcr.p#utils.get#house_addr(t.c#house_id), ' ') - 1)) omsu,
--                     CASE WHEN t.c#living_tag = 'Y' THEN COUNT(t.c#account_id) END CountAccL,
--                     CASE WHEN t.c#living_tag = 'Y' THEN SUM(NVL(t.c#area_val, 0)) END AreaL,
--                     CASE WHEN t.c#living_tag = 'Y' THEN SUM(NVL(t.c#Sum, 0)) END SumOutL,
--                     CASE WHEN t.c#living_tag = 'Y' THEN SUM(NVL(t.p#Sum, 0)) END SumInL,
--                     CASE WHEN t.c#living_tag = 'Y' THEN SUM(NVL(t.c#Sum, 0)) - SUM(NVL(t.p#Sum, 0)) END SumResL,
--                     CASE WHEN t.c#living_tag = 'N' THEN COUNT(t.c#account_id) END CountAccN,
--                     CASE WHEN t.c#living_tag = 'N' THEN SUM(NVL(t.c#area_val, 0)) END AreaN,
--                     CASE WHEN t.c#living_tag = 'N' THEN SUM(NVL(t.c#Sum, 0)) END SumOutN,
--                     CASE WHEN t.c#living_tag = 'N' THEN SUM(NVL(t.p#Sum, 0)) END SumInN,
--                     CASE WHEN t.c#living_tag = 'N' THEN SUM(NVL(t.c#Sum, 0)) - SUM(NVL(t.p#Sum, 0)) END SumResN
--            FROM (SELECT acc.c#living_tag,
--                         vc.c#account_id,
--                         NVL(acc.c#account_id, 0) c#id,
--                         c#house_id,
--                         acc.c#area_val,
--                         vc.c#sum,
--                         vc.p#sum
--                FROM (SELECT ac.c#id c#account_id,
--                             vrs.c#living_tag,
--                             r.c#house_id,
--                             vrs.c#area_val
--                    FROM (SELECT *
--                        FROM fcr.v#account
--                        WHERE (c#end_date IS NULL
--                          OR c#end_date > TO_DATE('01.06.2014', 'dd.mm.yyyy'))
--                          AND c#valid_tag = 'Y') ac
--                      INNER JOIN fcr.t#rooms r
--                        ON (ac.c#rooms_id = r.c#id)
--                      INNER JOIN (SELECT c#rooms_id,
--                                         c#area_val,
--                                         c#living_tag
--                          FROM fcr.v#rooms_spec rs
--                          WHERE c#date = (SELECT MAX(c#date)
--                                FROM fcr.v#rooms_spec
--                                WHERE c#rooms_id = rs.c#rooms_id)
--                          GROUP BY c#rooms_id,
--                                   c#living_tag,
--                                   c#area_val) vrs
--                        ON (r.c#id = vrs.c#rooms_id)
--                      INNER JOIN (SELECT c#house_id,
--                                         c#acc_type
--                          FROM fcr.v#banking tbo
--                            INNER JOIN fcr.t#b_account ba
--                              ON (tbo.c#b_account_id = ba.c#id)) type_Acc
--                        ON (type_acc.c#house_id = r.c#house_id)
--                    WHERE type_Acc.c#acc_type IN (1, 2)
--                    GROUP BY ac.c#id,
--                             vrs.c#living_tag,
--                             r.c#house_id,
--                             vrs.c#area_val) acc
--                  RIGHT JOIN (SELECT c.c#account_id,
--                                     NVL(c.c#sum, 0) c#sum,
--                                     NVL(op.p#sum, 0) p#sum
--                      FROM (SELECT c#account_id,
--                                   SUM(NVL(c#sum, 0)) AS c#sum
--                          FROM fcr.t#charge
--                          WHERE c#a_mn BETWEEN fcr.p#mn_utils.GET#MN(a#date_begin) AND fcr.p#mn_utils.GET#MN(a#date_end)
--                          GROUP BY c#account_id) c
--                        LEFT JOIN (SELECT c#account_id,
--                                          SUM(NVL(c#sum, 0)) AS p#sum
--                            FROM fcr.v#op
--                            WHERE c#real_date BETWEEN
--                              CASE WHEN (SELECT c#date
--                                      FROM v#account
--                                      WHERE c#id = c#account_id) > a#date_begin THEN (SELECT c#date
--                                        FROM v#account
--                                        WHERE c#id = c#account_id) ELSE a#date_begin END
--                              AND a#date_end
--                            GROUP BY c#account_id) op
--                          ON (c.c#account_id = op.c#account_id)) vc
--                    ON (vc.c#account_id = acc.c#account_id)
--                WHERE 1 = 1) t
--            WHERE t.c#id <> 0
--            -- and acc.c#account_id = 207252
--            GROUP BY TRIM(SUBSTR(fcr.p#utils.get#house_addr(t.c#house_id), 1, INSTR(fcr.p#utils.get#house_addr(t.c#house_id), ' ') - 1)),
--                     t.c#living_tag) ttt
--        GROUP BY omsu
--        ORDER BY omsu
--      ;
      RETURN res;
    END;

  FUNCTION LST#AKT_F(a#num    VARCHAR2,
                     a#dbegin VARCHAR2,
                     a#dend   VARCHAR2)
    RETURN sys_refcursor
    IS
      res          sys_refcursor;
      a#date_begin DATE;
      a#date_end   DATE;
      a#mn_begin   INTEGER;
      a#mn_end     INTEGER;
      a#account_id NUMBER;
    BEGIN
      a#date_begin := TO_DATE(a#dbegin, 'dd.mm.yyyy');
      a#date_end := TO_DATE(a#dend, 'dd.mm.yyyy');
      SELECT C#ID
        INTO a#account_id
        FROM v#account
        WHERE C#NUM = a#num;
      SELECT fcr.p#mn_utils.Get#MN(a#date_begin)
        INTO a#mn_begin
        FROM dual;
      SELECT fcr.p#mn_utils.Get#MN(a#date_end)
        INTO a#mn_end
        FROM dual;
      OPEN res FOR 
      select 
        QQQ.*
        ,sum("nach"-"opl") over(order by rownum) DOLG_TOTAL
      from (
      SELECT FCR.P#UTILS.GET#PERSON_NAME(acc.c#person_id)
                          AS
                          "FIO",
                          FCR.P#UTILS.GET#ROOMS_ADDR(acc.c#rooms_id)
                          AS
                          "address",
                          op.c#name
                          AS
                          "RKC",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN CASE WHEN acc.c#part_coef <> 0 THEN r.c#area_val * acc.c#part_coef ELSE r.c#area_val END END
                          AS
                          "area",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN TO_CHAR(FCR.P#MN_UTILS.GET#DATE(tch.c#a_mn), 'mm.yyyy') END
                          AS
                          "m_date",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN ROUND(tch.c#sum / CASE WHEN acc.c#part_coef <> 0 THEN r.c#area_val * acc.c#part_coef ELSE r.c#area_val END, 2) ELSE 0 END
                          AS
                          "tarif",
                          CASE WHEN (vop.c#real_date = (SELECT MIN(c#real_date)
                                  FROM fcr.v#op
                                  WHERE c#type_tag = 'P'
                                    AND c#account_id = vop.c#account_id
                                    AND FCR.P#MN_UTILS.GET#MN(c#real_date) = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))) OR
                              (vop.c#real_date IS NULL) THEN tch.c#sum ELSE 0 END
                          AS
                          "nach",
                          vop.c#real_date
                          AS
                          "date_opl",
                          NVL(vop.c#sum, 0)
                          AS
                          "opl"
        FROM (SELECT a.c#id,
                     a.c#num,
                     asp.c#person_id,
                     a.c#rooms_id,
                     asp.c#part_coef
            FROM fcr.v#account a
              INNER JOIN fcr.v#account_spec asp
                ON (a.c#id = asp.c#account_id)
            WHERE asp.c#valid_tag = 'Y') acc
          INNER JOIN (SELECT *
              FROM fcr.t#rooms t1
                INNER JOIN fcr.v#rooms_spec t2
                  ON (t1.c#id = t2.c#rooms_id)) r
            ON (r.c#rooms_id = acc.c#rooms_id)
          LEFT JOIN (SELECT c#account_id,
                            c#work_id,
                            c#doer_id,
                            c#a_mn,
                            SUM(c#vol) AS c#vol,
                            SUM(c#sum) AS c#sum
              FROM fcr.t#charge
              WHERE C#ACCOUNT_ID = a#account_id
              GROUP BY c#account_id,
                       c#work_id,
                       c#doer_id,
                       c#a_mn
              HAVING SUM(c#vol) > 0
--                AND SUM(c#sum) > 0 -- GERA 03.11.2017
                ) tch
            ON (tch.c#account_id = acc.c#id)
          LEFT JOIN (SELECT c#account_id,
                            c#date,
                            top.c#name
              FROM (SELECT c#account_id,
                           c#date,
                           taop.C#OUT_PROC_ID,
                           taop.C#OUT_NUM
                  FROM fcr.t#account_op taop) aop
                LEFT JOIN (SELECT c#id,
                                  c#name
                    FROM fcr.t#out_proc) top
                  ON (top.c#id = aop.c#out_proc_id)) op
            ON (op.c#account_id = tch.c#account_id
            AND op.c#date = (SELECT MAX(c#date)
                FROM fcr.t#account_op
                WHERE c#account_id = tch.c#account_id
                  AND c#date <= fcr.p#mn_utils.get#date(tch.c#a_mn)))
          LEFT JOIN (SELECT c#account_id,
                            c#real_date,
                            SUM(NVL(c#sum, 0)) AS c#sum
              FROM fcr.v#op
              WHERE c#type_tag = 'P'
                AND c#account_id = a#account_id
              GROUP BY c#account_id,
                       c#real_date
--              HAVING SUM(NVL(c#sum, 0)) > 0 -- GERA 03.11.2017
            ) vop
            ON (tch.c#account_id = vop.c#account_id
            AND tch.c#a_mn = FCR.P#MN_UTILS.GET#MN(vop.c#real_date))
        WHERE acc.c#num = a#num
          AND tch.c#a_mn BETWEEN FCR.P#MN_UTILS.GET#MN(a#date_begin) AND FCR.P#MN_UTILS.GET#MN(a#date_end)
        ORDER BY tch.c#a_mn,
                 tch.c#a_mn,
                 vop.c#real_date
        ) QQQ;         
      RETURN res;
    END;


  FUNCTION LST#GGI_PRIL6(p_YEAR VARCHAR2) RETURN sys_refcursor AS
      res sys_refcursor;
  BEGIN
    OPEN res FOR
        with
            end as (
                SELECT
                    HB.HOUSE_ID,
                    regexp_substr(ADDR, '[^ ]+')                  MUN,
                    CASE WHEN H.C#POST_CODE IS NOT NULL
                        THEN H.C#POST_CODE || ', ' END || A.ADDR ADR,
                    HI.C#AREA_VAL                                 AREA,
                    HI.C#2ND_DATE                                 BEGIN_DATE,
                    HB.PAY_SUM_TOTAL PAY_SUM,
                    HB.JOB_SUM_TOTAL TOTAL_JOB_SUM,
                    HB.OWNERS_JOB_SUM_TOTAL OWNERS_JOB_SUM,
                    HB.DOLG_SUM_TOTAL TOTAL_DOLG_SUM
                FROM
                    T#TOTAL_HOUSE  HB
                    JOIN MV_HOUSES_ADRESES A ON (HB.HOUSE_ID = A.HOUSE_ID)
                    JOIN T#HOUSE H ON (HB.HOUSE_ID = H.C#ID)
                    JOIN T#HOUSE_INFO HI ON (H.C#ID = HI.C#HOUSE_ID)
                WHERE
                    MN = P#MN_UTILS.GET#MN(TO_DATE('31.12.'||p_YEAR,'dd.mm.yyyy'))
                    AND HI.C#END_DATE IS NULL
                ORDER BY
                    ADDR
            )
            ,beg as (
                select
                    HOUSE_ID,
                    DOLG_SUM_TOTAL OLD_DOLG_SUM
                from
                    T#TOTAL_HOUSE
                WHERE
                    MN = P#MN_UTILS.GET#MN(TO_DATE('31.12.'||p_YEAR,'dd.mm.yyyy'))-12
            )
        select
            MUN,
            ADR,
            AREA,
            BEGIN_DATE,
            PAY_SUM,
            TOTAL_JOB_SUM,
            OWNERS_JOB_SUM,
            TOTAL_DOLG_SUM,
            CASE
                WHEN OLD_DOLG_SUM < 0 and TOTAL_DOLG_SUM < 0 THEN
                    GREATEST(TOTAL_DOLG_SUM,OLD_DOLG_SUM)
                ELSE
                    GREATEST(0,LEAST(TOTAL_DOLG_SUM,OLD_DOLG_SUM))
            END OLD_DOLG_SUM
        from
            end
            join beg on (end.HOUSE_ID = beg.HOUSE_ID)
        ;
    
    RETURN res;
  END LST#GGI_PRIL6;

END P#REPORTS;
/
