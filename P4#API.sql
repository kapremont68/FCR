CREATE OR REPLACE package P4#API
is

-- insert
procedure pay2hosts_ins (
    p_C#HOUSE_ID in T4_PAY_TO_HOSTS.C#HOUSE_ID%type
    ,p_C#HOST_ID in T4_PAY_TO_HOSTS.C#HOST_ID%type
    ,p_C#SUM in T4_PAY_TO_HOSTS.C#SUM%type
    ,p_C#PAY_DATE in T4_PAY_TO_HOSTS.C#PAY_DATE%type
    ,p_C#INVOICE in T4_PAY_TO_HOSTS.C#INVOICE%type
    ,p_C#NOTE in T4_PAY_TO_HOSTS.C#NOTE%type default null 
);

-- delete
procedure pay2hosts_del (
    p_C#ID in T4_PAY_TO_HOSTS.C#ID%type
);

-- insert
procedure house_hosts_ins (
    p_C#HOUSE_ID in T4_HOUSE_HOSTS.C#HOUSE_ID%type
    ,p_C#HOST_ID in T4_HOUSE_HOSTS.C#HOST_ID%type
    ,p_C#DATE_TO_HOST in T4_HOUSE_HOSTS.C#DATE_TO_HOST%type
);

-- delete
procedure house_hosts_del (
    p_C#ID in T4_HOUSE_HOSTS.C#ID%type
);


end P4#API;
/


CREATE OR REPLACE package body P4#API
is
-- insert
procedure pay2hosts_ins (
    p_C#HOUSE_ID in T4_PAY_TO_HOSTS.C#HOUSE_ID%type
    ,p_C#HOST_ID in T4_PAY_TO_HOSTS.C#HOST_ID%type
    ,p_C#SUM in T4_PAY_TO_HOSTS.C#SUM%type
    ,p_C#PAY_DATE in T4_PAY_TO_HOSTS.C#PAY_DATE%type
    ,p_C#INVOICE in T4_PAY_TO_HOSTS.C#INVOICE%type
    ,p_C#NOTE in T4_PAY_TO_HOSTS.C#NOTE%type default null 
) is
begin
    insert into T4_PAY_TO_HOSTS(
        C#NOTE
        ,C#PAY_DATE
        ,C#HOST_ID
        ,C#HOUSE_ID
        ,C#SUM
        ,C#INVOICE
    ) values (
        p_C#NOTE
        ,p_C#PAY_DATE
        ,p_C#HOST_ID
        ,p_C#HOUSE_ID
        ,p_C#SUM
        ,p_C#INVOICE
    );
end;



-- del
procedure pay2hosts_del (
    p_C#ID in T4_PAY_TO_HOSTS.C#ID%type
) is
begin
    delete from T4_PAY_TO_HOSTS
    where C#ID = p_C#ID;
end;


-- insert
procedure house_hosts_ins (
    p_C#HOUSE_ID in T4_HOUSE_HOSTS.C#HOUSE_ID%type
    ,p_C#HOST_ID in T4_HOUSE_HOSTS.C#HOST_ID%type
    ,p_C#DATE_TO_HOST in T4_HOUSE_HOSTS.C#DATE_TO_HOST%type
) is
begin
    insert into T4_HOUSE_HOSTS(
        C#DATE_TO_HOST
        ,C#HOST_ID
        ,C#HOUSE_ID
    ) values (
        p_C#DATE_TO_HOST
        ,p_C#HOST_ID
        ,p_C#HOUSE_ID
    );
end;


-- del
procedure house_hosts_del (
    p_C#ID in T4_HOUSE_HOSTS.C#ID%type
) is
begin
    delete from T4_HOUSE_HOSTS
    where C#ID = p_C#ID;
end;

end P4#API;
/
