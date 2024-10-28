-- Exercise 1

-- Q6
declare
 num number := 1;
 cnt number;
begin
 case
 when num = 1 then
    cnt := 300;
    while cnt <= 400
    loop
        dbms_output.put_line('Count: ' || cnt);
        cnt := cnt + 1;
    end loop;
when num = 2 then 
    for cnt in 400..800 loop
        dbms_output.put_line('Count: '|| cnt);
    end loop;
else
    dbms_output.put_line('Wrong choice');
end case;

end;

-- Exercise 3

-- Q1/Q2
create or replace procedure fetch_sale_date(in_order_id in number,
cnt out number)
as
l_order_date sales.sales_date%type;
begin

select sales_date into l_order_date from sales where order_id = in_order_id;

select count(1) from sales where order_date = l_order_date;

dbms_output.put_line('Sale date: ' || l_order_date);

end;

declare 
    total_rows number;
begin
    fetch_sale_date(1001, total_rows);
    dbms_output.put_line('Total number of rows: ' || total_rows);
end;

-- Q3
create or replace function num_power(n1 in number, n2 in number)
return number
as
power_value number :=1;
begin
    for cnt in 1..n2
    loop
        power_value := power_value * n1;
    end loop;

    return power_value;
end;

select num_power(10,3) from dual;

-- Exercise 4

-- II

create or replace function num_power(n1 in number, n2 in number)
return number
as
power_value number :=1;
num_null_zero exception;
greater_hundred exception;
begin
    
    case
    when n1 is null or n2 is null then
        raise num_null_zero;
    when n1 == 0 or n2 == 0 then
        raise num_null_zero;
    when n1 > 100 or n2 > 100 then
        raise greater_hundred;
    end case;

    for cnt in 1..n2
    loop
        power_value := power_value * n1;
    end loop;

    return power_value;

    exception
        when num_null_zero then 
            dbms_output.put_line('Must be a valid number');
        when greater_hundred then
            dbms_output.put_line('Number must less or equal then 100.');
        when others then
            dbms_output.put_line('Error');
end;

-- Exercise 6

-- Q1
create or replace procedure fetch_sales(s_orderID number)
as
c_rec sales%rowtype;
begin
    select * into c_rec from sales where order_id = s_orderID;
    dbms_output.put_line('Order ID: ' || c_rec.order_id);
end;
/

-- Q6
create or replace procedure fetch_sales(s_orderID number)
as
type sales_info_rec is record (
sale_date sales.sales_date%type
);
sale_rec sales_info_rec;
begin
    select sales_date into sale_rec from sales where order_id = s_orderID;

    dbms_output.put_line('Sale date: '|| sale_rec.sale_date);
end;
/


-- Exercise 7

-- Q1

create or replace procedure fetch_sales_cur(s_date date)
as 
	cursor sale_cursor
		is
		select sales_date, order_id
			from sales
			where sales_date = s_date;

sale_rec sales%rowtype;

begin
 open sale_cursor;

 loop 
  fetch sale_cursor into sale_rec;

  exit when sale_cursor%notfound;

  dbms_output.put_line(sale_rec.sales_date);

 end loop;

 close sale_cursor;

end;

exec fetch_sales_cur(to_date('01-JAN-2015','DD-MON-YYYY'));

-- Q2

create or replace procedure fetch_sales_cur(s_date date)
as 
begin

for sale_rec in 
    (select sales_date, order_id from sales where sales_date = s_date)
loop
    dbms_output.put_line(sale_rec.sales_date);
end loop;

end;

exec fetch_sales_cur(to_date('01-Jan-2015','DD-MON-YYYY'));

-- Q3

create or replace procedure send_sales_ref(s_date DATE, sales_cur out SYS_REFCURSOR)
as
begin

open sales_cur for
    select sales_date, order_id from sales where sales_date = s_date;

end;

create or replace procedure get_sales_ref(s_date DATE)
as
s_rec_curser SYS_REFCURSOR;
sale_rec sales%rowtype;
begin

    send_sales_ref(s_date, s_rec_curser);

        loop
          fetch s_rec_curser into sale_rec;
          exit when s_rec_curser%notfound;
            dbms_output.put_line(sales_rec.sales_date);

        end loop;
    
    close s_rec_curser;

end;

exec get_sales_ref(to_date('01-JAN-2015','DD-MON-YYYY'));

-- Exercise 8

-- Q1

declare
    type customer_type is a table varchar2(100) index by binary_integer;

    customer_table customer_type;

    idx number;

begin
    customer_table(1) := 'Mike';
    customer_table(2) := 'John';

    customer_table.delete(1);

    idx := customer_table.first;

    while customer_table(idx) is not null loop
        dbms_output.put_line('Customer name: ' || customer_table(idx));

        idx := customer_table.lase;
    end loop;
end;
/

-- Q2

declare
    type customer_type is a table varchar2(100);

    customer_table customer_type := customer_type();

    idx number;

begin

    customer_table.extend(10);
    
    customer_table(1) := 'Mike';
    customer_table(2) := 'John';

    customer_table.delete(1);

    idx := customer_table.first;

    while customer_table(idx) is not null loop
        dbms_output.put_line('Customer name: ' || customer_table(idx));

        idx := customer_table.lase;
    end loop;
end;
/

-- Q3

declare
    type customer_type is a table varray(10) of varchar2(100); -- limit upper bound of array as 10

    customer_table customer_type:= customer_type();

    idx number;

begin

    customer_table.extend(10);

    customer_table(1) := 'Mike';
    customer_table(2) := 'John';

    customer_table.delete(1);

    idx := customer_table.first;

    while customer_table(idx) is not null loop
        dbms_output.put_line('Customer name: ' || customer_table(idx));

        idx := customer_table.lase;
    end loop;
end;
/