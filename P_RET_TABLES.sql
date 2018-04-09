--------------------------------------------------------
--  DDL for Package P#RET_TABLES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#RET_TABLES" AS 

    type t_room_addr is record
     (
      room_id integer,
      addr varchar2(250)
     );
     
    type t_room_addr_table is table of t_room_addr;

    function get_rooms_addr return t_room_addr_table pipelined;
 
END P#RET_TABLES;

/
