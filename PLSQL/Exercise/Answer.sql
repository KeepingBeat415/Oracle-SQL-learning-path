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