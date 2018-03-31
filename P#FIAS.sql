CREATE OR REPLACE PACKAGE P#FIAS
  AS

  /**
  * Дерево для кронкретного GUID
  */
  FUNCTION lst#addr_tree(a#parent_guid VARCHAR2)
    RETURN sys_refcursor;

  /**
  * Все дома для кронкретного GUID адреса
  */
  FUNCTION lst#house(a#aoguid VARCHAR2)
    RETURN sys_refcursor;

  /**
  * Все помещения для кронкретного GUID дома
  */
  FUNCTION lst#ROOMS(a#houseguid VARCHAR2)
    RETURN sys_refcursor;


  /**
  * Строка адреса для GUID 
  */
  FUNCTION GET#ADDR_OBJ_PATH(A#AO_guid VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Строка адреса для GUID для конкретного дома
  */
  FUNCTION GET#HOUSE_ADDR(A#H_GUID VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Строка адреса для GUID для конкретного помещения
  */
  FUNCTION GET#ROOM_ADDR(A#R_GUID VARCHAR2)
    RETURN VARCHAR2;

END P#FIAS;

/


CREATE OR REPLACE PACKAGE BODY     P#FIAS AS

function lst#ROOMS(a#houseguid varchar2) return sys_refcursor is
    res sys_refcursor;
  begin
    open res for
    select fcr.p#FIAS.GET#HOUSE_ADDR(r.houseguid)
        ,CADNUM, ENDDATE, FLATNUMBER, FLATTYPE, HOUSEGUID, LIVESTATUS, NEXTID, NORMDOC, OPERSTATUS, POSTALCODE, PREVID, REGIONCODE, ROOMCADNUM, ROOMGUID, ROOMID, ROOMNUMBER, ROOMTYPE, STARTDATE, UPDATEDATE
    from fcr.t_room68 R
    where 1=1
    and r.houseguid = a#houseguid;
    return res;
  end;

function lst#house(a#aoguid varchar2) return sys_refcursor is
    res sys_refcursor;
  begin
    open res for
    select P#FIAS.GET#ADDR_OBJ_PATH(h.aoguid),
           AOGUID, BUILDNUM, CADNUM, COUNTER, DIVTYPE, ENDDATE, ESTSTATUS, HOUSEGUID, HOUSEID, HOUSENUM, IFNSFL, IFNSUL, NORMDOC, OKATO, OKTMO, POSTALCODE, STARTDATE, STATSTATUS, STRSTATUS, STRUCNUM, TERRIFNSFL, TERRIFNSUL, UPDATEDATE
    from fcr.t_house68 H
    where 1=1
    and startdate = (select max(startdate) from fcr.t_house68 where h.houseguid = houseguid)
    and h.aoguid = a#aoguid order by HOUSENUM;
    return res;
  end;

function lst#addr_tree(a#parent_guid varchar2) return sys_refcursor is
    res sys_refcursor;
  begin
    open res for
      select 
        ACTSTATUS
      , AOGUID
      , AOID
      , AOLEVEL
      , AREACODE
      , AUTOCODE
      , CENTSTATUS
      , CITYCODE
      , CODE
      , CTARCODE
      , CURRSTATUS
      , ENDDATE
      , EXTRCODE
      , FORMALNAME
      , IFNSFL
      , IFNSUL
      , LIVESTATUS
      , NEXTID
      , NORMDOC
      , OFFNAME
      , OKATO
      , OKTMO
      , OPERSTATUS
      , PARENTGUID
      , PLACECODE
      , PLAINCODE
      , PLANCODE
      , POSTALCODE
      , PREVID
      , REGIONCODE
      , SEXTCODE
      , SHORTNAME
      , STARTDATE
      , STREETCODE
      , TERRIFNSFL
      , TERRIFNSUL
      , UPDATEDATE
        from fcr.t_addrobj68 ao
       where 1 = 1
         and (ao.AOGUID = a#parent_guid or (a#parent_guid is null and ao.aoguid is null))
       order by ao.FORMALNAME;
    return res;
  end;

function GET#ADDR_OBJ_PATH(A#AO_guid varchar2) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   select listagg(AO.FORMALNAME||' '||AO.SHORTNAME,', ') within group (order by LEVEL desc)
     into A#RESULT
     from fcr.t_addrobj68 ao
    where 1 = 1
    start with AO.AOGUID = A#AO_guid 
    connect by prior AO.PARENTGUID = AO.AOGUID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

function GET#HOUSE_ADDR(A#H_GUID varchar2) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   select (
           select listagg(AO.FORMALNAME||' '||AO.SHORTNAME,', ') within group (order by LEVEL desc)
            from fcr.t_addrobj68 ao
            where 1 = 1
            start with AO.AOGUID = H.AOGUID
            connect by  prior AO.PARENTGUID  = AO.AOGUID  
          )||', '|| H.HOUSENUM ||rtrim('-'||H.BUILDNUM||'-'||H.STRUCNUM,'-') 
     into A#RESULT
     from fcr.t_house68 H
    where 1=1
    and startdate = (select max(startdate) from fcr.t_house68 where h.houseguid = houseguid)
    and h.houseguid = A#H_GUID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

function GET#ROOM_ADDR(A#R_GUID varchar2) return varchar2 is
  A#RESULT varchar2(4000);
 begin
  begin
   select (
          GET#HOUSE_ADDR(R.HOUSEGUID)
          )||', '|| R.FLATNUMBER
     into A#RESULT
     from fcr.t_room68 R
    where 1=1
    and r.roomguid = A#R_GUID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
  return A#RESULT;
 end;

  
END P#FIAS;
/
