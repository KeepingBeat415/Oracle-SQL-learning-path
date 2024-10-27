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
 -- <delcarations

```
