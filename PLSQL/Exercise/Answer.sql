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