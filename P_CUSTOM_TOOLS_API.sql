--------------------------------------------------------
--  DDL for Package P#CUSTOM_TOOLS_API
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "FCR"."P#CUSTOM_TOOLS_API" 
is


-- insert
function ins (
    p_C#TITLE in T#CUSTOM_TOOLS.C#TITLE%type
    ,p_C#TEXT in T#CUSTOM_TOOLS.C#TEXT%type
) return number;
-- update
procedure upd (
    p_C#ID in T#CUSTOM_TOOLS.C#ID%type
    ,p_C#TITLE in T#CUSTOM_TOOLS.C#TITLE%type
    ,p_C#TEXT in T#CUSTOM_TOOLS.C#TEXT%type
);
-- delete
procedure del (
p_C#ID in T#CUSTOM_TOOLS.C#ID%type
);
end P#CUSTOM_TOOLS_API;

/
