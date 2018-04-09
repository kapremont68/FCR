--------------------------------------------------------
--  DDL for Package P#FIAS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FIAS" 
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
