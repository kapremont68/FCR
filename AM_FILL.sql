--------------------------------------------------------
--  DDL for Package AM_FILL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."AM_FILL" as
/*
*    Purpose: using the Microsoft XLSX files as a templates for data output
*
*    Uses AS_ZIP package designed by Anton Scheffer 
*    Download from: http://technology.amis.nl/wp-content/uploads/2010/06/as_zip7.txt
*
*    Based on the code of packages designed by Anton Scheffer
*        https://technology.amis.nl/wp-content/uploads/2011/02/as_xlsx11.txt
*        https://technology.amis.nl/wp-content/uploads/2013/01/as_read_xlsx9.txt 
*
*    Author: miktim@mail.ru, Petrozavodsk State University
*    Date: 2013-06-24
*    Updated:
*      2015-02-27 support Oracle non UTF-8 charSets.
*      2015-03-18 procedure in_sheet added. Thanks to odie_63 (ORACLE Community)
*                     (https://community.oracle.com/message/12933878)
*      2016-02-01 free xmlDocument objects
*      2016-06-07 fixed bugs: get sheet xml name, sheets without merges (align_loc)
*                 Thanks github.com/Zulus88
*      2016-06-08 fixed bug: calc new rId (IN_SHEET)
*      2017-03-28 fixed bug: 200 rows 'limitation' (IN_TABLE),
*                 options added (IN_SHEET),
*                 build-in workbook changed
*    
******************************************************************************
* Copyright (C) 2011 - 2013 by Anton Scheffer
*               2013 - 2017 by MikTim
* License: MIT
******************************************************************************
*/
version constant varchar2(16):='2.70329';
/* 
   INIT: Initialize package by xlsx template
   p_options:
      e - enable exception on #REF!, otherwise ignore filling
*/      
Procedure init
( p_xtemplate BLOB
, p_options varchar2:=''  
);
/* INIT: Clear internal structures */
Procedure init;
/* 
   IN_FIELD: Fill in cell or upper left cell of named area
   p_cell_addr: A1 style cell address (sheet_name!cell_address) or range name
   p_options:
     i - row insert mode (sequentially on every call), default - overwrite
         WARNING: insert mode cut vertical merges
*/
Procedure in_field
( p_value date
, p_cell_addr varchar2
, p_options varchar2:='');
Procedure in_field
( p_value number
, p_cell_addr varchar2
, p_options varchar2:='');
Procedure in_field
( p_value varchar2
, p_cell_addr varchar2
, p_options varchar2:='');
/* 
   IN_TABLE: Fill in table
   p_sql: sql query text (without trailing semicolon) 
   p_cell_addr: default A1 of current sheet
   p_options:
     h - print headings (field names)
     i - row insert mode.
         WARNING: insert mode cut vertical merges (one record - one row)
*/
Procedure in_table
( p_sql CLOB
, p_cell_addr varchar2 := ''
, p_options varchar2 := '');
/*
   IN_SHEET: Save filled sheet with new name after source sheet,
             clears data from source sheet, a new sheet becomes active null
         WARNING: the new sheet name does not check (length, allowed chars)
    
   p_options:
     h - hide source sheet
     b - insert BEFORE source sheet
*/
Procedure in_sheet
( p_sheet_name varchar2      -- source sheet name
, p_newsheet_name varchar2   -- new sheet name 
, p_options varchar2:=''     -- options
);
/*
   FINISH: Generate workbook, clear internal structures
         WARNING: all formulas from filled sheets will be removed
*/
Procedure finish
( p_xfile in out nocopy BLOB -- filled in xlsx returns
);
/*
   ADDRESS: Calculate relative (sheet or named range) address
            
*/
Function address
( p_row pls_integer
, p_col pls_integer
, p_range_name varchar2 := '' -- if omitted, the current sheet is used
) return varchar2;            -- A1 style address
/*
   NEW_WORKBOOK: empty workbook returned 
   Workbook has only sheet 'Sheet1'. A1 cell contains 'YYYY-MM-DD' formatted date. 
*/
Function new_workbook return BLOB;
/*
******************************************************************************
* Package usage:
*
* begin
* ...
* -- specify xlsx BLOB as template for filling
*    am_fill.init(<some_xlsx_blob>); 
* ...
* -- insert rows of query into Sheet1 from row 12 column B use styles of cells B12, C12, D12, ...
*    am_fill.in_table('select <some_fields> from <some_table>','Sheet1!B12','i');  
* ...
* -- fill named range cell with 2 cols null rows offset using destination cell style
*    am_fill.in_field(<some_variable>, 'range1!C11');
* ...
* -- manually insert rows using 'Sheet1!B12' cell style 
* -- in this case, result of previous am_fill.x_table first column will be overprinted
*    for c in (select  <some_field> from <some_table>)
*    loop
*        am_fill.in_field(c.<some_field>, 'Sheet1!B12','i');
*    end loop;
* ...
* -- generate and return filled xlsx BLOB
*    am_fill.finish(<some_filled_blob>);   
* end;
*/
end;

/
