--------------------------------------------------------
--  DDL for Package P#FIAS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#FIAS" 
  AS

  /**
  * ������ ��� ������������ GUID
  */
  FUNCTION lst#addr_tree(a#parent_guid VARCHAR2)
    RETURN sys_refcursor;

  /**
  * ��� ���� ��� ������������ GUID ������
  */
  FUNCTION lst#house(a#aoguid VARCHAR2)
    RETURN sys_refcursor;

  /**
  * ��� ��������� ��� ������������ GUID ����
  */
  FUNCTION lst#ROOMS(a#houseguid VARCHAR2)
    RETURN sys_refcursor;


  /**
  * ������ ������ ��� GUID 
  */
  FUNCTION GET#ADDR_OBJ_PATH(A#AO_guid VARCHAR2)
    RETURN VARCHAR2;

  /**
  * ������ ������ ��� GUID ��� ����������� ����
  */
  FUNCTION GET#HOUSE_ADDR(A#H_GUID VARCHAR2)
    RETURN VARCHAR2;

  /**
  * ������ ������ ��� GUID ��� ����������� ���������
  */
  FUNCTION GET#ROOM_ADDR(A#R_GUID VARCHAR2)
    RETURN VARCHAR2;

END P#FIAS;

/
