CREATE OR REPLACE PACKAGE P#GIS AS 

  function GET#HOUSE_ADDR_GIS(A#H_ID number) return varchar2;

  function GET#HOUSE_ADDR_GIS_LIKE(A#H_ID number) return varchar2;

  function GET#ACC_TYPE_BY_HOUSE_ID(p_HOUSE_ID number) return number;

  FUNCTION GET#ADRES_BY_FIAS_HOUSEGUID(p_HOUSEGUID varchar2) RETURN varchar2;

  FUNCTION GET#ADRES_BY_FIAS_AOGUID(p_AOGUID varchar2) RETURN varchar2;
 
  FUNCTION GET#FIAS_HOUSEGUID_BY_AOGUID(p_AOGUID varchar2, p_H_NUM VARCHAR2) RETURN varchar2;

  FUNCTION GET#GIS_HOUSEGUID_BY_HOUSE_ID(p_HOUSE_ID number) RETURN varchar2;

  FUNCTION GET#GIS_HOUSEGUID_BY_ADDR(p_ADDR varchar2) RETURN varchar2;

  FUNCTION GET#GIS_HOUSEGUID_BY_ADDR_LIKE(p_ADDR varchar2) RETURN varchar2;
  
  FUNCTION get#house_addr_like ( a#h_id   NUMBER ) RETURN VARCHAR2;

END P#GIS;
/


CREATE OR REPLACE PACKAGE BODY P#GIS AS


  function GET#ACC_TYPE_BY_HOUSE_ID(p_HOUSE_ID number) return number is
  res number;
  begin
    select C#ACC_TYPE into res from V#BANKING join T#B_ACCOUNT on (C#B_ACCOUNT_ID = T#B_ACCOUNT.C#ID) where C#HOUSE_ID = p_HOUSE_ID;
    return res;
  end;

  FUNCTION GET#ADRES_BY_FIAS_AOGUID(p_AOGUID varchar2) RETURN varchar2 AS
  tmp_ADDR VARCHAR2(500);
  BEGIN
    SELECT LISTAGG(OFFNAME||' '||SHORTNAME,', ') WITHIN GROUP (ORDER BY LEVEL DESC)
    INTO tmp_ADDR
    FROM FIAS_ADDROBJ68
    START WITH AOGUID = p_AOGUID
    CONNECT BY PRIOR PARENTGUID = AOGUID;
    RETURN tmp_ADDR;
  END GET#ADRES_BY_FIAS_AOGUID;

  FUNCTION GET#ADRES_BY_FIAS_HOUSEGUID(p_HOUSEGUID VARCHAR2) RETURN VARCHAR2 AS
  tmp_HOUSE VARCHAR2(100);
  tmp_GUID VARCHAR2(36);
  BEGIN
    SELECT HOUSENUM||NVL2(BUILDNUM,'-'||BUILDNUM,null)||NVL2(STRUCNUM,'-'||STRUCNUM,null), AOGUID 
    INTO tmp_HOUSE, tmp_GUID
    FROM FIAS_HOUSE68
    WHERE HOUSEGUID = p_HOUSEGUID;
    RETURN GET#ADRES_BY_FIAS_AOGUID(tmp_GUID)||', '||tmp_HOUSE;
  END GET#ADRES_BY_FIAS_HOUSEGUID;


  FUNCTION GET#FIAS_HOUSEGUID_BY_AOGUID(p_AOGUID varchar2, p_H_NUM VARCHAR2) RETURN varchar2 AS
  out_HOUSEGUID VARCHAR2(36);
  BEGIN
    SELECT HOUSEGUID 
    INTO out_HOUSEGUID
    FROM FIAS_HOUSE68 
    WHERE AOGUID = p_AOGUID
    AND NVL2(HOUSENUM,LOWER(HOUSENUM),'')||NVL2(BUILDNUM,'-'||LOWER(BUILDNUM),'')||NVL2(STRUCNUM,'-'||LOWER(STRUCNUM),'') = p_H_NUM
    AND rownum < 2;
    RETURN out_HOUSEGUID;
  END GET#FIAS_HOUSEGUID_BY_AOGUID;

  function GET#HOUSE_ADDR_GIS(A#H_ID number) return varchar2 AS
  A#RESULT varchar2(4000);
  begin
  begin
   select (
           select listagg(AOT.C#ABBR_NAME||'. '||AO.C#NAME,', ') within group (order by LEVEL desc)
             from T#ADDR_OBJ AO, T#ADDR_OBJ_TYPE AOT
            where AOT.C#ID = AO.C#TYPE_ID
            start with AO.C#ID = H.C#ADDR_OBJ_ID connect by prior AO.C#PARENT_ID = AO.C#ID
          )||', '||'ä. '||H.C#NUM||rtrim(', ê. '||H.C#B_NUM||'-'||H.C#S_NUM,'-, ê.')
     into A#RESULT
     from T#HOUSE H
    where H.C#ID = A#H_ID
   ;
  exception
   when NO_DATA_FOUND then null;
   when others then raise;
  end;
--  A#RESULT := lower(A#RESULT);
  return A#RESULT;
  END GET#HOUSE_ADDR_GIS;

  FUNCTION GET#GIS_HOUSEGUID_BY_HOUSE_ID(p_HOUSE_ID number) RETURN varchar2 AS
  res VARCHAR2(4000);    
  BEGIN
--    select HOUSE_ID_GIS
--    into res
--    FROM VGIS
--    where 
--    C#HOUSE_ID = p_HOUSE_ID
--    AND HOUSE_ID_FIAS is not null
--    and rownum < 2;
--    if (res is null) then
--        select HOUSE_ID_GIS
--        into res
--        FROM VGIS
--        where 
--        C#HOUSE_ID = p_HOUSE_ID
--        and rownum < 2;
--    end if;
    RETURN res;
  END GET#GIS_HOUSEGUID_BY_HOUSE_ID;

  FUNCTION GET#GIS_HOUSEGUID_BY_ADDR(p_ADDR varchar2) RETURN varchar2 AS
  res VARCHAR2(50);
  BEGIN
    select GIS_GUID
    into res
    from TT#GIS_UNIQ_ADDR
    where ADDR = TRIM(LOWER(p_ADDR));
    RETURN res;
  END GET#GIS_HOUSEGUID_BY_ADDR;

  function GET#HOUSE_ADDR_GIS_LIKE(A#H_ID number) return varchar2 AS
  A#RESULT varchar2(200);
  begin
      begin
       select (
--               select listagg(case when AOT.C#ABBR_NAME = 'ð-í' or AOT.C#ABBR_NAME = 'ã' then AOT.C#ABBR_NAME||'. ' else '' end||AO.C#NAME,'%') within group (order by LEVEL desc)
               select listagg(AO.C#NAME,'%') within group (order by LEVEL desc)
                 from T#ADDR_OBJ AO, T#ADDR_OBJ_TYPE AOT
                where AOT.C#ID = AO.C#TYPE_ID
                start with AO.C#ID = H.C#ADDR_OBJ_ID connect by prior AO.C#PARENT_ID = AO.C#ID
              )||'%'||H.C#NUM
--              ||rtrim(', ê. '||H.C#B_NUM||'-'||H.C#S_NUM,'-, ê.')
         into A#RESULT
         from T#HOUSE H
        where H.C#ID = A#H_ID
       ;
      exception
       when NO_DATA_FOUND then null;
       when others then raise;
      end;
      A#RESULT := lower(A#RESULT);
      return A#RESULT;
  END GET#HOUSE_ADDR_GIS_LIKE;

  FUNCTION GET#GIS_HOUSEGUID_BY_ADDR_LIKE(p_ADDR varchar2) RETURN varchar2 AS
  res VARCHAR2(50);
  BEGIN
    select GIS_GUID
    into res
    from TT#GIS_UNIQ_ADDR
    where ADDR like p_ADDR
    and rownum < 2;
    RETURN res;
  END GET#GIS_HOUSEGUID_BY_ADDR_LIKE;

    FUNCTION get#house_addr_like ( a#h_id   NUMBER ) RETURN VARCHAR2 IS
        a#result   VARCHAR2(4000);
    BEGIN
        BEGIN
            SELECT
                (
                    SELECT
                        LISTAGG(
                            '%'
                             || ao.c#name,
                            '%'
                        ) WITHIN GROUP(ORDER BY
                            level
                        DESC)
                    FROM
                        t#addr_obj ao
                    START WITH
                        ao.c#id = h.c#addr_obj_id
                    CONNECT BY
                        PRIOR ao.c#parent_id = ao.c#id
                )
                 || '%'
                 || h.c#num
                 || '%'
            INTO
                a#result
            FROM
                t#house h
            WHERE
                h.c#id = a#h_id;
    
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
            WHEN OTHERS THEN
                RAISE;
        END;
    
        RETURN a#result;
    END;
END P#GIS;
/
