### PL/SQL Basics

- PL/SQL is the Oracle Procedural Language extension of SQL.
- A PL/SQL program can have both SQL statement and procedural statements.

### PL/SQL structure

- PL/SQL is a block-structured language, meaning that PL/SQL programs are divided and written in logical blocks of code.

```sql
Declare
 -- <declarations section>
Begin
 -- <executable command(s)>
Exception
 -- <exception handling>
end;
```

```sql
declare
 -- Global variables
 orderNumber number := 1001;
 orderId number default 1002;--using default keyword
 orderType constant varchar2(20) := 'Machine'; -- using constant keyword
 cnt number(2) := 10;
begin
 dbms_output.put_line(orderNumber);

 declare
  -- local variables
  num2 number := 1001;
  begin
    -- If Else
    if num2 > 1000 then
        dbms_output.put_line('Greater than 1000');
    elsif num2 = 1000 then
        dbms_output.put_line('Equal 1000');
    else
        dbms_output.put_line('Less than 1000');
    end if;

  end;

  -- CASE
    case
        when num2 > 1000 then
            dbms_output.put_line('Greater than 1000');
        when num2 = 1000 then
            dbms_output.put_line('Equal 1000');
        else
            dbms_output.put_line('Less than 1000');
    end case;

    -- While Loop
    while cnt < 20
    loop
        dbms_output.put_line('Counting: ' || cnt);
        cnt := cnt + 1;
    end loop;

    -- for loop
    for cnt in 10..20 -- increase +1
    loop
        dbms_output.put_line('Counting: '|| cnt);
    end loop;
    -- reverse order
    for cnt in reverse 10..20 -- increase +1
    loop
        dbms_output.put_line('Counting: '|| cnt);
    end loop;
end;
/
```

### Processing date via PL/SQL

- using "SELECT INTO", for each item, there must be a corresponding type-compatible variable in the INTO list.

```sql

declare
 c_id number := 0;
 --c_name varchar2(50);
 c_name customer.first_name%type; -- using table field type
begin
 select first_name into c_name from customer where customer_id = c_id;

end;
/
```

### PL/SQL Blocks

- anonymous blocks => without name
- named blocks => Procedures and Functions

- Procedures
- A procedure is a group of PL/SQL statements that you can call by name.

- MODE is usually one of the following: IN, OUT or IN OUT,
  - IN: read-only input variable, and PL/SQL prevents you from changing it inside the program.
  - OUT: write-only, the procedure sets the value of the parameter, and the calling program can read it.
  - IN OUT: input parameter that it can both read and update, and then have the updated value available to the calling program.

```sql
create [or replace] procedure procedure_n (parameter1 MODE datatype [default expression], ..)
as [
    variable1 DATATYPE;
    ...
]
begin
    executable_statements
[ exception
    when
        exception_name
    then
        executable_statements
]
end;
/
```

```sql
create or replace procedure add_customer
(c_id in out number,
 c_fname in varchar2,
 cnt out number) -- this variable can't modify in the block
as
begin
    insert into customer(customer_id, first_name) values (c_id, c_fname);
    commit;

    select count(1) into cnt from customer;
end add_customer;

declare
cnt number;
in_out number := 100;
begin
    add_customer(101, 'Peter',cnt); -- parameter order need to match
    add_customer(c_id => 15,
    c_fname => 'Peter', cnt := cnt);

    dbms_output.put_line('Count: ' || cnt);

    add_customer(c_id => in_out,
    c_fname => 'Lucas', cnt := cnt);

    dbms_output.put_line('IN_OUT: ' || in_out);
end;
/
```

- Function
  - A stored function is a set of PL/SQL statements you can call by name, and that a function returns a value to the environment in which it is called.
  - functions can be used as part of a SQL expression.

```sql
create [or replace] function function_name (parameter 1 MODE DATATYPE [DEFAULT expression], ...)
return DATATYPE
as
    [variable1 DATATYPE;
    ...]
begin
    executable_statements
    return expression;
[
    exception
      when
        exception_name
      then
        executable_statements
]
end;
/

```

```sql
CREATE OR REPLACE FUNCTION find_salescount(p_sales_date date)
return number
as
    num_of_sales number := 0;
begin
    select count(1) into num_of_sales from sales where sales_date = p_sales_date;

    return num_of_sales;

end find_salescount;
```

### Exceptions

```sql
declare
 -- <declarations sections>
begin
 -- <executable commands>
exception
 when exception1 then
    exception1-handing-statements
 when exception2 then
    exception2-handing-statements
 when others then -- default exception
    others-handing-statements
end;

```

- User defined exceptions

```sql
create or replace procedure get_customer (c_id in Number)
as
declare
    c_name customer.first_name%type;
    ex_customer_id exception; -- declare exception variable
begin
    if c_id <= 0
        -- keyword "raise"
        raise ex_customer_id;

    select first_name into c_name from customer where customer_id = c_id;

    dbms_output.put_line('Name: ' || c_name);

exception
    when ex_customer_id then
        dbms_output.put_line('ID must be greater than zero.');
    when others then
        dbms_output.put_line('Error');
end;
/
```

### Packages

- A package is a schema object that groups logically related PL/SQL types, items, and subprograms like procedures and functions.
- Packages usually have two parts: Specification / Body

- Package Specification: only contains the headers of the program units

```sql
create or replace package package_name
as
    program1_header;
    program2_header;
    ...
end package_name;
/
```

- Package Body:

```sql
create or replace package body package_name
as
    procedure1;
    procedure2;
    ...
end package_name;
```

### Records

- A record is composite datatype, which means that it cna hold more than one piece of information, as compared to a scalar datatype, such as a number or string.

```sql
create or replace procedure process_customer(c_id in customer.customer_id%type)
is
c_rec customer%rowtype;
begin
    select * into c_rec from customer where customer_id = c_id;

    c_rec.first_name = 'Sons'; -- modify record data

    dbms_output.put_line('First Name: '|| c_rec.first_name);

end;
/

-- update row
create or replace show_customer( customer_in in customer%rowtype)
is
begin
    update customer set row = customer_in where customer_id = customer_in.customer_id;
    commit;
end;
/
```

- User defined record types

```sql
type customer_info_rec is record
(
    name varchar2(100),
    total_sales number
);

l_customer1 customer_info_rec;
```

### Collections

- Index by Tables
  - the collection is indexed using Binary_integer values or varchar2 values, which do not need to be consecutive
  - can't store this collection in a database

```sql
declare
    -- declare type
    type customer_type is table of varchar2(100) index by binary_integer;
    -- declare variable
    customer_table customer_type;
    v_idx number;
begin
    customer_table(1) := 'Mike';
    customer_table(2) := 'Jeff';

    -- delete item by index
    customer_table.delete(2);

    -- traverse sparse collection
    v_idx := customer_table.first;

    while v_idx is not null loop
        dbms_output.put_line('Customer Name ' || customer_table(v_idx);

        v_idx := customer_table.next(v_idx);
    end loop display_loop;

end;
/
```

- Nested Tables
  - can be stored in a database.
  - be indexed only by integer
  - use the MULTISET operator to perform set operations and to perform equality comparisons on nested tables.

```sql
declare
    type customer_type is table of varchar2(100);
    customer_table customer_type := customer_type(); -- initialize the collection
    v_idx number;

begin
    -- extend space before using the table
    customer_table.extend(4);

    -- insert in sequence
    customer_table(1) := 'Mike';
    customer_table(2) := 'Jeff';
    customer_table(3) := 'John';
    -- customer_table(6) := 'King'; -- throws an error
    customer_table(4) := 'King';

    customer_table.delete(3);

    dbms_output.put_line('Customer Name ' || customer_table(customer_table.first));

    -- traverse sparse collection
    v_idx := customer_table.first;

    while v_idx is not null loop
        dbms_output.put_line('Customer Name ' || customer_table(v_idx);

        v_idx := customer_table.next(v_idx);
    end loop display_loop;

end;
/
```

- Varrays
  - must specify an upper bound in the declaration
  - must be remain dense, no delete item

```sql
declare
    type customer_type is varray(4) of varchar2(100);
    customer_table customer_type := customer_type(); -- initialize the collection
    v_idx number;

begin
    -- extend space before using the table
    customer_table.extend(4);

    -- insert in sequence
    customer_table(1) := 'Mike';
    customer_table(2) := 'Jeff';
    customer_table(3) := 'John';
    customer_table(4) := 'King';

    -- can't delete an item
    --customer_table.delete(3);

    dbms_output.put_line('Customer Name ' || customer_table(customer_table.first));

    -- traverse sparse collection
    v_idx := customer_table.first;

    while v_idx is not null loop
        dbms_output.put_line('Customer Name ' || customer_table(v_idx);

        v_idx := customer_table.next(v_idx);
    end loop display_loop;

end;
/
```

- MULTISET Operators
  - MULTISET UNION
  - MULTISET UNION DISTINCT
  - MULTISET EXCEPT
  - MULTISET INTERSECT

```sql
declare
    type t_tab is table of number;
    l_tab1 t_tab := t_tab(1,2,3,4,5,6);
    l_tab2 t_tab := t_tab(5, 6, 7, 8, 9, 10);
begin
    l_tab := l_tab1 MULTISET UNION l_tab2;

    for i in l_tab2.first .. l_tab1.last loop
        dbms_output.put_line(l_tab1(i));
    end loop;

end;
/
```

### Triggers

- Triggers are stored programs, which are automatically executed or fired when some events occur.

- Row level triggers

  - execute once for each row in a transaction

```sql
create trigger customer_after_update
before update on customer for each row

declare
    v_username varchar2(10);
begin
    -- find the user who is performing the action
    select user into v_username from dual;

insert into audit_table (table_name, userid, operation_date, operation) values ('CUSTOMER', V_USERNAME, SYSDATE, 'Insert Operation Row Level');

end;
```

- with When clause

```sql
create or replace trigger customer_after_update_values
after value
    -- of clause
    -- of customer_Id
    on customer
    for each row
    -- when clause
    when old.region = 'SOUTH'
declare
    v_username varchar2(10);
begin
    select user into v_username from dual;

    insert into audit_logs(userid,operation_date, b_customerid, a_customerid, b_firstname, a_firstname) values (v_username, sysdate, :old.customer_id, :new.customer_id, :old.first_name, :new.first_name);
end;
```

- Statement level triggers
  - execute only once for each transaction

```sql

create trigger customer_before_update
before update

on customer

declare
    v_username varchar2(10);
begin
    -- find the user who is performing the action
    select user into v_username from dual;

insert into audit_table (table_name, userid, operation_date, operation) values ('CUSTOMER', V_USERNAME, SYSDATE, 'Before Update Operation');

end;

create or replace trigger customer_after_action
after insert or update or delete
on customer

declare
    v_username varchar2(10);
begin
    -- find the user who is performing the action
    select user into v_username from dual;

if inserting then
    insert into audit_table (table_name, userid, operation_date, operation) values ('CUSTOMER', V_USERNAME, SYSDATE, 'Insert Operation');
elsif updating then
    insert into audit_table (table_name, userid, operation_date, operation) values ('CUSTOMER', V_USERNAME, SYSDATE, 'Update Operation');
elsif deleting then
    insert into audit_table (table_name, userid, operation_date, operation) values ('CUSTOMER', V_USERNAME, SYSDATE, 'Delete Operation');
end if;

end;
```

- Before Trigger

- After Trigger

### Bulk Processing

```sql
create or replace procedure update_tax (tax_rate in number)
as
    l_eligible boolean;
    type orderid_type is table of sales.order_id%type index by pls_integer; -- associative array
    l_order_ids orderid_type;
begin
    -- bulk collect the order_ids into a collection
    select distinct order_id bulk collect into l_order_ids from sales;

    -- for all to update all the rows as a bundle
    forall indx in 1 .. l_order_ids.count
        update sales s set s.tax_amount = s.total_amount * tax_rate where s.order_id = l_order_ids(indx);
end;
```

- with Limit

```sql
create or replace procedure update_tax (tax_rate in number)
as
    l_eligible boolean;
    type orderid_type is table of sales.order_id%type index by pls_integer; -- associative array
    l_order_ids orderid_type;
    l_eligible_orders orderid_type;

    cursor sales_cursor
    is
        select distinct order_id from sales;
begin

open sales_cursor;

loop
    fetch sales_cursor
        bulk collect into l_order_ids limit 100;

    for indx in 1..l_order_ids.count
    loop
        check_eligible(l_order_ids(indx), l_eligible);

        if l_eligible then
            l_eligible_orders(l_eligible_orders.count + 1) := l_order_ids(indx);
        end if;

    end loop;

    exit when l_order_ids.count = 0;
end loop;

forall indx in 1 .. l_eligibel_orders.count
    update sales s set s.tax_amount = s.total_amount * tax_rate where s.order_id = l_eligible_orders(indx);
commit;

close sales_cursor;

exception
    when others then
    if SQLCODE = -24381 then
        for indx in 1 .. SQL%BULK_EXCEPTIONS.COUNT
        loop
            dbms_output.put_line(SQL%BULK_EXCEPTIONS (indx).error_index);
            dbms_output.put_line(SQLERRM(-SQL%BULK_EXCEPTIONS (INDX).ERROR_CODE));
        end loop;
    else raise;
    end if;
end;

end;

```

- Bulk Collect Exceptions
  - SQL%BULK_EXCEPTIONS
  - if errors are raised along they way, add the SAVE EXCEPTIONS clause to the FORALL heder

### Dynamic SQL

- Execute Immediate
  - native dynamic SQL processes most dynamic SQL statements

```sql
begin
    execute immediate 'CREATE TABLE x (a NUMBER)';
end;

create procedure update_customer(s_customer_id in number)
as
begin
    execute immediate 'UPDATE SALES SET TOTAL_AMOUNT = TOTAL_AMOUNT * .9 WHERE CUSTOMER_ID = ' || s_customer_id;
    commit;
end;
```

```sql
create or replace procedure fetch_sales_dynamic (s_orderID number, s_cust_ID number)
as
sale_rec sales%rowtype;
SQL_stmt varchar2(500) := 'SELECT SALES_DATE, ORDER_ID FROM SALES WHERE 1 = 1';
begin
    if s_orderID is not null then
        SQL_stmt := SQL_stmt || 'AND ORDER_ID = ' || S_orderID;
    end if

    -- execute statement and insert into record type
    execute immediate SQL_stmt into sale_rec;

    dbms_output.put_line(sale_rec.sales_date);

end;
```
