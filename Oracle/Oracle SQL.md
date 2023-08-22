### 1. Retrieving Data

---

#### DESCRIBE Command

```sql
DESCRIBE table_name;
DESC[RIBE] table_name;
```

#### INFORMATION Command

```sql
INFORMATION table_name;
INFO table_name;
```

#### Quote(Q) Operate

1. Can use any character as quotation mark delimiter
2. Such as, [] {} <> \* \* A A

```sql
SELECT q'[Example Quote]' FROM table_name;
SELECT first_name || q'[&&]' || last_name FROM student; -- OUTPUT: John && Fisher
```

#### Concatenation Operator

```sql
SELECT column_1 || column_2 FROM table_name;
```

#### Arithmetic Expressions

Arithmetic operations with the NULL values return NULL

#### NULL Operator

'= NULL' is not the same as the 'IS NULL'

#### AND Operator

TRUE AND NULL => NULL
FALSE AND NULL => FALSE
NULL AND NULL => NULL

#### OR Operator

TRUE OR NULL => TRUE
FALSE OR NULL => NULL
NULL OR NULL => NULL

#### NULLS First and NULLS Last

`ORDER BY column_1 DESC NULLS FIRST, column_2 NULLS LAST`

#### ROWID

A unique identifier that contains the physical address of a row

#### ROWNUM

Consecutive logical sequence number given to the rows fetched from the table

#### FETCH Clause

Used in conjunction with the SELECT and ORDER BY clauses to limit the rows and retrieve a portion of the returning rows

```sql
[OFFSET rows_to_skip ROW[S]]
FETCH [FIRST | NEXT] [row_count | percent PERCENT] ROW[S] [ONLY | WITH TIES]
```

- ONLY is used to return exactly the specified number of rows
- WITH TIES returns extra rows with the same value as the last row fetched, must specify the order_by_clause.

#### Substitution Variable

Work as placeholders in an SQL script

`&` -- ampersand(&) character is used before the substitution variable in the query substitution variable with string type, '&str'

`&&`

- Work as multiple usage of the substitution variables
- Prompt once and everywhere that variable is used it will use what was entered

#### DEFINE/DEF and UNDEFINE/UNDEF Commands

```sql
DEFINE var_name = value;
UNDEFINE var_name;
```

#### ACCEPT/PROMPT

Reliable and robust method for getting input, `ACCEPT user_id PROMPT 'Please Enter an ID';`

#### SET VERIFY ON/OFF

Displays the status of the variable before and after the substitution.

<br/>

### 2. Single Row Functions

---

Character Functions, Number Functions, Date Functions, Conversion Functions, General Functions

#### Character Functions

```sql
initcap('Adam SMITH') # OUTPUT: Adam Smith

substr(source_str, position[, length]) -- starting index 1
substr('SQL Course', 1, 3) -- OUTPUT: SQL

instr(str, substring[, position, occurrence])

trim([[LEADING|TRAILING|BOTH] trim_character FROM] string)
trim(LEADING '*' FROM '*** String ***') -- OUTPUT: String ***
-- only trim same character

ltrim(string, [trim_string])
ltrim('TEST***TEST', 'TEST') -- OUTPUT: ***TEST
rtrim('TEST***TEST', 'TEST') -- OUTPUT: TEST***
ltrim('www.yourwebsite.com', 'w.') -- OUTPUT: yourwebsite.com
-- trim multiplier 'w' and multiple '.' character

replace(string, string_to_replace[, replacement_string])
-- if not specify any replacement string, then will remove any exact matched characters

lpad(string, target_length, padding_expression)
rpad(string, target_length, padding_expression)
lpad('TEST', 10, '-') -- OUTPUT: ------TEST
```

#### Numeric Functions

```sql
round(12.136, 2) -- OUTPUT: 12.14
round(145.953, -2) -- OUTPUT: 100
trunc(12.136, 2) -- OUTPUT: 12.13
```

#### Date Functions

```sql
add_months(date, n)
add_months('31-AUG-2023', 1) -- OUTPUT: 30-SEP-2023

extract(month FROM sysdate)
```

#### Conversion Functions

```sql
to_char(date|number, [format_model], [nls_parameter])
to_char(1000, '$99,999.99') -- OUTPUT: $1,000.00

to_number(char [, 'format_model'])
to_number('$1,000.00', '$99,999.99') -- OUTPUT: 1000

to_date(char [, 'format_model'])
to_date('Jun 12, 2005', 'Mon DD, YYYY')
```

#### NVL Functions

`NVL(Expression1, Expression2)`

- To replace a null value with a meaningful alternative
- Expression 1 and Expression 2 must be same data type
- If expression 1 is null, then NVL() function returns expression 2 to avoid calculation errors

`NVL2(Expression1, Expression2, Expression3)`

- If Expression 1 is not NULL, then returns Expression 2.
- If Expression 1 is NULL, then returns Expression 3.
- Expression 2 and Expression 3 must be same data type

`NULLIF(Expression1, Expression2)`

- If equal, returns NULL. If not equal, returns Expression 1.

#### COALESCE Functions

`coalesce(Expression1, Expression2, ... ,ExpressionN)`
Returns the first one that evaluates to a non-null value

#### Regular Expressions

- The starting character must be an alphabet: `^[A-Za-z]`.
- Must contain only alphabets, numbers and periods: `[A-Za-z0-9.]`.
- Must be prefixed with an “at the rate of” (@) symbol and may contain only alphabets, numbers, hyphens and periods: `@[A-Za-z0-9.-]`.
- Must be prefixed with a DOT followed by alphabets not less than 2 and no more than 4 :`\.[A-Za-z]{2,4}$`.
- `\`: used as escape.
- `*`: can be any number of occurrences

```sql
REGEXP_LIKE (EMAIL, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
```

#### MOD Function

```sql
MOD(3, 2) -- OUTPUT: 1
```

<br/>

### 3. Conditional Expression

---

#### Conditional Expression

```sql
case ... when Expression

case expression when comparsion_1 then result_1
							 [when comparsion_2 then result_2
								...
								when comparsion_n then result_n
								else result]
end
```

```sql
SELECT first_name, last_name, job_id, salary,
    CASE job_id
       WHEN 'ST_CLERK' THEN salary * 1.2
       WHEN 'SA_REP'   THEN salary * 1.3
       WHEN 'IT_PROG'  THEN salary * 1.4
       ELSE salary
    END "UPDATED SALARY"
FROM employees;

SELECT first_name, last_name, job_id, salary,
    CASE
       WHEN job_id = 'AD_PRES'  THEN salary*1.2
       WHEN job_id = 'SA_REP'   THEN salary*1.3
       WHEN job_id = 'IT_PROG'  THEN salary*1.4
       WHEN last_name = 'King'  THEN 2*salary
       ELSE salary
    END "UPDATED SALARY"
FROM employees;

SELECT first_name, last_name, job_id, salary
FROM employees
WHERE (CASE
          WHEN job_id = 'IT_PROG' AND salary > 5000 THEN 1
          WHEN job_id = 'SA_MAN' AND salary > 10000 THEN 1
          ELSE 0
       END) = 1;
```

---

#### decode Function

To provide if-then-else logic in SQL, only in Oracle

`decode (col | expression, search1, result1 [,search2, result2] ... [,default])`

```sql
SELECT first_name, last_name, job_id, salary,
	     decode(job_id, 'ST_CLERK', salary * 1.2
                        'SA_REP'  , salary * 1.3
                        'IT_PROG' , salary * 1.4
                        salary) as "UPDATED SALARY"
FROM employees;
```

<br/>

### 4. Group Functions

---

#### Group Function

Operate on multiple rows and return one result for each group ignore the NULL values

```sql
avg([DISTINCT | ALL] expression)

count([DISTINCT | ALL] expression)

sum([DISTINCT | ALL] expression) -- with numerical data
```

#### listagg Functions

- Aggregate strings from data in columns in a database table
- Concatenates values from separate rows into a single value or by a specified delimiter

```sql
LISTAGG(column_name [,delimiter]) WITHIN GROUP (ORDER BY sort_expression)

SELECT listagg(first_name,',') WITHIN GROUP (ORDER BY first_name) AS Employees
  FROM employees
  WHERE job_id = 'ST_CLERK';

SELECT listagg(first_name,',') AS Employees
  FROM employees
  WHERE job_id = 'ST_CLERK';
```

#### Group By Clause

- Column aliases cannot be used with the GROUP BY clause
- SELECT clause cannot have any different columns than what is used in the GROUP BY clause

```sql
SELECT expression1, expression2, ... , expression_n, aggregate_function
       (aggregate_expression)
  FROM table_name
  [WHERE condition]
  GROUP BY expression1, experssion2, ... , expression_n
  [HAVING group_condition]
  [ORDER BY order_expression]
```

```sql
SELECT job_id, department_id, avg(salary)
  FROM employees
  GROUP BY job_id, department_id;
```

Multiple columns Group By, then Combination Column's Values

#### Having Clause

- The group functions cannot be used in the WHERE clause
- The WHERE clause filters rows whereas the **HAVING clause filters grouped data**

#### Nested Group Functions

- Can be nested to a depth of two have to using GROUP BY
- Cannot write an individual column name in the select statement
- Cannot use WHERE Clause and HAVING Clause
- GroupFunction1(GroupFunction2())

<br/>

### 5. Joining Multiple Tables

---

#### Natural Join

`SELECT column_1 FROM table_1 NATURAL JOIN table_2;`

- Based on common columns that have the **same name** and **same data type**
- same name with different type of data, it will result in an error

#### Join

`SELECT column_1 FROM table_1 JOIN table_2 USING (column_2);`

- With the USING Clause
- Use the USING clause to specify which column to be selected
- Cannot give aliases to columns that we used in the USING Clause

#### Inner Join

```sql
SELECT column_1 FROM table_1 [INNER]
  JOIN table_2 ON (join_condition) / USING(column_name)
```

Returns all of rows which satisfy the join condition

#### Self Join

Joining a table with itself

#### Joining Non-Equijoins

- If two tables do not match with columns, we can join
- These tables using the BETWEEN operator, or the comparison operators (<, >, <=, >=, <>)

### Outer Join

`LEFT OUTER JOIN`
Returns all the matched and the unmatched rows for left table

`RIGHT OUTER JOIN`
Returns all the matched and the unmatched rows for right table

`FULL OUTER JOIN`
Returns all the matched and the unmatched rows for both tables

`CROSS JOIN`
Cartesian Product

### EXIST and NOT EXIST

Check whether the subquery returns some data

<br/>

### 6. Oracle’s Old Style

---

1. The outer join operator(+) cannot use the IN operator
2. The outer join operator(+) cannot be combined with another condition using the OR operator
3. A join condition containing the join operator cannot involve a subquery

#### INNER JOIN

```sql
SELECT column_1, column_2
  FROM table_1, table_2
  WHERE table_1_column = table_2_column;
```

#### OUTER JOIN

- LEFT JOIN

```sql
SELECT column_1, column_2
  FROM table_1, table_2
  WHERE table_1_column = table_2_column(+);

SELECT e.first_name, e.last_name, j.job_title, e.salary, j.min_salary, j.max_salary
  FROM employees e, jobs j
  WHERE e.job_id = j.job_id(+)
    AND e.salary BETWEEN j.min_salary(+)+500 AND j.max_salary(+);
    -- add (+) to each jobs table condition
```

- RIGHT JOIN

```sql
SELECT column_1, column_2
  FROM table_1, table_2
  WHERE table_1_column_3(+) = table_2_column_3
    AND table_1_column_4(+) = table_2_column_4
```

- FULL JOIN

```sql
SELECT column_1, column_2
  FROM table_1, table_2
  WHERE table_1_column = table_2_column(+)
UNION
SELECT column_1, column_2
  FROM table_1, table_2
  WHERE table_1_column(+) = table_2_column
```

<br/>

### 7. Using Subqueries

---

#### Single Row Subqueries

- If a subquery returns nothing or a NULL value, then main query will return nothing.

#### Multiple Row Subqueries

- Used with multiple-row comparison operators.(IN, ANY, ALL).

```sql
SELECT first_name, last_name, department_id, salary
  FROM employees
  WHERE salary < ALL (SELECT salary
                        FROM employees
                        WHERE job_id = 'SA_MAN');
```

#### Multiple Column Subqueries

1. Non-pairwise comparison subquery
   - check `multiple column` values with separate subqueries

```sql
SELECT first_name, last_name, department_id, salary
  FROM employees
	WHERE department_id IN
                  (SELECT department_id
                    FROM employees
                    WHERE employee_id IN (103, 105, 110)
				AND salary IN
                  (SELECT salary
                    FROM employees
                    WHERE employee_id IN (103, 105, 110);
```

2. Pairwise comparison subquery

```sql
SELECT first_name, last_name, department_id, salary
	FROM employees
	WHERE (department_id, salary) IN
                  (SELECT salary
                    FROM employees
                    WHERE employee_id IN (103, 105, 110));
```

#### Scalar Subqueries

- if a subquery returns only one column for one row
- if a scalar subquery returns NULL or 0 rows, the main query will return nothing.

#### Correlated Subqueries

- when a subquery references to the columns from the parent query

Example 1:

```sql
SELECT employee_id, first_name, last_name, department_id, salary
  FROM employees a
  WHERE salary = (SELECT max(salary)
                    FROM employees b
                    WHERE b.department_id = a.department_id);
```

```sql
SELECT employee_id, first_name, last_name, department_id, salary
 FROM employees a
 WHERE (salary, department_id) IN (SELECT max(salary), department_id
                                     FROM employees b
                                     GROUP BY department_id);
```

```sql
SELECT employee_id, first_name, last_name, department_id, salary
  FROM employees a
  WHERE salary < (SELECT avg(salary)
                  FROM employees b
                  WHERE b.department_id = a.department_id);
```

```sql
SELECT employee_id, first_name, last_name, a.department_id, salary
  FROM employees a JOIN (SELECT avg(salary) avg_sal, department_id
                          FROM employees
                          GROUP BY department_id) b
                      ON a.department_id = b.department_id
  WHERE a.salary < b.avg_sal;
```

Example 2:

```sql
SELECT employee_id, first_name, last_name, department_name, salary,
      (SELECT avg(salary)
        FROM employees
        WHERE department_id = d.department_id) "DEPARMENT'S AVERAGE SALARY"
  FROM employees e JOIN departments d
                      ON (d.department_id = e.department_id)
  ORDER BY e.employee_id;
```

```sql
SELECT employee_id, first_name, last_name, department_name, salary,
      (SELECT round(avg(salary))
        FROM employees
        WHERE department_id = d.department_id) "DEPARMENT'S AVERAGE SALARY"
  FROM employees e JOIN departments d
                      ON (d.department_id = e.department_id)
  ORDER BY e.employee_id;
```

#### EXISTS Operator

```sql
SELECT employee_id, first_name, last_name, department_id, salary
  FROM employees a
  WHERE EXISTS
            (SELECT null
						  FROM employees
						  WHERE manager_id = a.employee_id);
```

#### NOT EXISTS Operator

```sql
SELECT * FROM departments d
  WHERE NOT EXISTS
                (SELECT null FROM employees e
                  WHERE e.department_id = d.department_id);

SELECT * FROM departments d
  WHERE department_id NOT IN
                        (SELECT department_id FROM employees);
```

<br/>

### 8. Set Operators

---

#### SET Operators

`SELECT column1, column2, ... , column_n FROM table1 SET_OPERATOR`

- all SET Operators have equal precedence
- the number of columns or expressions in queries must match
- the ORDER BY clause is used only once and at the end of the compound query
- column headings come from the first query

UNION

- returns all rows of both queries by eliminating duplicate rows

UNION ALL

- returns all rows of both queries including duplicates

INTERSECT

- returns common rows of both table

MINUS

- returns unique rows of the first query

- Matching Unmatched Queries

```sql
SELECT job_id, NULL department_id, first_name, last_name
  FROM employees
UNION ALL
SELECT job_id, department_id, NULL, NULL
  FROM job_history;
```

<br/>

### 9. Data Definition Language (DDL)

---

##### Database Object Naming Rules

1. start with a letter
1. only A-Z, a-z, 0-9, \_, $, and # characters
1. cannot have the same name as another existing object in the same schema
1. table names should be in plural form. (employees, etc)
1. column names should be singular
1. be separated by an underscore

##### CREATE TABLE Statement

```sql
CREATE TABLE schema_name.table_name
  (column_name_1 datatype [DEFAULT default_value] [NULL | NOT NULL],
  column_name_2 datatype [DEFAULT default_value] [NULL | NOT NULL],
  ...);
```

```sql
DESC employees;
CREATE TABLE my_employees(employee_id   NUMBER(3)     NOT NULL,
                          first_name    VARCHAR2(50)  DEFAULT 'No Name',
                          last_name     VARCHAR2(50),
                          hire_date     DATE          DEFAULT sysdate NOT NULL);
```

#### CREATE TABLE AS SELECT Statement (CTA)

`CREATE TABLE table_name[(column1, column2, ...0)] AS select_query;`

- Important: while creating a table from a SELECT query, the only constraints that are inherited are the **NOT constraints**.
- A table's structure can be copied without any data
- Force 'select_query' return NULL

Example:

```sql
CREATE TABLE employees_copy AS (SELECT * employees WHERE 1=2);
```

#### ALETER TABLE Statement

- ADD Statement

```sql
ALTER TABLE table_name
  ADD ( column_name1 datatype [DEFAULT default_value1] [NULL | NOT NULL],
		    column_name1 datatype [DEFAULT default_value1] [NULL | NOT NULL],
		 ...);
```

- MODIFY Statement

```sql
ALTER TABLE table_name
  MODIFY (column_name datatype [DEFAULT default_value] [NULL | NOT NULL]
				  column_name datatype [DEFAULT default_value] [NULL | NOT NULL]
				...);
```

- DROP Statement

```sql
ALTER TABLE table_name DROP COLUMN column_name;
ALTER TABLE table_name DROP (column_name1, column_name2, ... );
```

- SET UNUSED Option

1. use 'ONLINE' keyword to indicate that DML operations are allowed on the table while marking columns as unused
1. columns are dropped logically by becoming invisible and inaccessible

```sql
ALTER TABLE table_name SET UNUSED COLUMN column_name;
ALTER TABLE table_name SET UNUSED (column_name1, column_name2, ... );
ALTER TABLE table_name DROP UNUSED COLUMNS;

ALTER TABLE table_name SET UNUSED (column_name1, column_name2, ... ) ONLINE;
```

- READ ONLY Tables
  set a table to read-only

```sql
ALTER TABLE table_name READ ONLY;
```

to change a read-only table to read-write again

```sql
ALTER TABLE table_name READ WRITE;
```

- DROP Statement
  moves it to the recycle bin, add 'PURGE' then delete directly.

```sql
DROP TABLE table_name [PURGE];
```

Recovered dropped table

```sql
FLASHBACK TABLE table_name TO BEFORE DROP;
```

- TRUNCATE TABLE Statement

1. the DELETE statement deletes all data row by row whereas the TRUNCATE deletes all rows from a table more quickly
1. `TRUNCATE` does not allow rollback

```sql
TRUNCATE TABLE [schema.name.]table_name;
```

#### COMMENT Statement

1. cannot directly drop comment, instead create a new comment with no text
2. query the comments from the `user_tab_comments` and `user_col_comments` view

```sql
SELECT * FROM user_tab_comments;
SELECT * FROM user_col_comments WHERE table_name = 'TABLE_NAME';
```

#### RENAME Statement

To change the name of an existing column or table

Rename column

```sql
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;
```

Rename table

```sql
RENAME old_name TO new_name;
ALTER TABLE old_name RENAME TO new_name;
```

<br/>

### 10. Data Manipulation Language (DML)

---

#### INSERT Statement

Unspecified columns will be filled with NULL values or DEFAULT values

```sql
INSERT INTO table_name (column1, column2, ... , column_n)
  VALUES (value1, value2, ... , value_n);
```

#### INSERT INTO SELECT Statement

To populate date into a table by the result of a SELECT statement

```sql
INSERT INTO target_table (col1, col2, ... ,col_n)
  SELECT col1, col2, ..., col_n FROM source_table;

INSERT INTO employee_addresses
	SELECT employee_id, first_name, last_name, city || ' - ' || street_address AS address
	  FROM employees
	  JOIN departments  USING (department_id)
	  JOIN locations    USING (location_id);

CREATE TABLE employee_addresses AS
	SELECT employee_id, first_name, last_name, city || ' - ' || street_address AS address
	  FROM employees
	  JOIN departments  USING (department_id)
	  JOIN locations    USING (location_id);
```

#### Multiple Insert Statement

1. Unconditional Insert Statement
   Subquery is mandatory in an insert all syntax

```sql
INSERT ALL
  	INTO table_name1 VALUES (val1, val2, val3, ...)
  	INTO table_name2 (col1, col2, col3, ...) VALUES (val1, val2, val3, ...)
  	...
  Subquery;
```

1. Conditional Insert Statement

- to insert rows into the related tables in one step based on the specified conditions
- conditions are specified between the WHEN-THEN keywords

```sql
INSERT ALL
  	WHEN Condition1 THEN
  		INTO Insert_statement_1;
  		INTO Insert_statement_2;
  	WHEN condition2 THEN
  		INTO Insert_statement_3;
  		...
  	ELSE
  		INTO Insert_statement_n;
  Subquery;

INSERT ALL
    WHEN hire_date > to_date('15-MAR-08') THEN
      INTO salary_history VALUES (employee_id, EXTRACT(year FROM sysdate),
            EXTRACT(month FROM sysdate),salary, commission_pct)
    WHEN job_id = 'IT_PROG' THEN
      INTO it_programmers VALUES(employee_id,first_name,last_name,hire_date)
    WHEN department_id IN
      (SELECT department_id FROM departments WHERE location_id IN
          (SELECT location_id FROM locations WHERE country_id = 'US')) THEN
      INTO working_in_the_us VALUES (employee_id,first_name,last_name,job_id,department_id)
    ELSE
      INTO employees_history VALUES (employee_id,first_name,last_name,hire_date)
  SELECT * FROM employees;
```

1. Conditional INSERT FIRST Statement

- For the first WHEN clause that evaluates to true, then database executes the corresponding INTO clause and skip subsequent WHEN clauses for the given row.

```sql
INSERT FIRST
  WHEN Condition1 THEN
    INTO Insert_statement_1;
    INTO Insert_statement_2;
  WHEN condition2 THEN
    INTO Insert_statement_3;
    ...
  ELSE
    INTO Insert_statement_n;
Subquery;
```

1. Pivoting Insert

- For converting non-relational data to a relational format and inserting it into a relational table

#### UPDATE Statement

`UPDATE table_name SET column1 = value1 [, column2 = value2, ...] [WHERE condition(s)];`

Using subquery

```sql
UPDATE employees_copy
  SET (salary, commission_pct) = (SELECT max(salary), max(commission_pct) FROM employees)
  WHERE job_id = 'IT_PROG';

UPDATE employees_copy
  SET salary = 100000
  WHERE hire_date = (SELECT MAX(hire_date) FROM employees);
```

#### DELETE Statement

`DELETE [FROM] table_name [WHERE condition];`

#### MERGE Statement

To INSERT new records, UPDATE or DELETE existing ones depending on the specified conditions at the same time

```sql
MERGE INTO target_table target_alias
  USING(source table|view|subquery) source_alias ON (join condition)
  WHEN MATCHED THEN
    UPDATE SET
      column_name1 = value1,
      column_name2 = value2,
      ...
    [WHERE <update condition>]
    [DELETE WHERE <delete condition>]
  WHEN NOT MATCHED THEN
    INSERT (columns) VALUES (values)
    [WHERE <insert condition>];
```

```sql
MERGE INTO employees_copy c
  USING employees e ON (c.employee_id = e.employee_id)
  WHEN MATCHED THEN
    UPDATE SET
    c.first_name = e.first_name,
    c.last_name = e.last_name,
    c.department_id = e.department_id,
    c.salary = e.salary
  DELETE WHERE department_id IS NULL
  WHEN NOT MATCHED THEN
    INSERT VALUES(e.employee_id, e.first_name, e.last_name, e.email,
                  e.phone_number, e.hire_date, e.job_id, e.salary,
                  e.commission_pct, e.manager_id, e.department_id);
```

#### Transaction Control Language (TCL)

1. It has to either happen in full or not at all
1. To ensure data integrity, data consistency and data security
1. Finishes with any commit, rollback or system failure, or the DDL or DCL statements.
1. After a DDL or DCL statement, the commit will be automatically executed

ROLLBACK / COMMIT

- Row Lock in Oracle
- During the transaction, the modify/delete/update rows are lock until COMMIT

SAVEPOINT Statement

- For longer transactions, savepoints are quite useful as they divide longer
- Transactions into smaller parts and mark certain points of a transaction as checkpoints.
- the SAVEPOINT statement saves the current state of a transaction and we can roll back to that state.

`SAVEPOINT name;`
`SAVEPOINT TO name;`

FOR UPDATE Statement

- Locks all the rows returned by the query
- The rows that are already locked by another session wil not be able to be locked using the FOR UPDATE statement
- The `NOWAIT` keyword tells Oracle not to wait if the rows have already been locked by another user
- The` SKIP LOCKED` keyword tells Oracle to skip the locked rows and operate on the available ones

```sql
SELECT * FROM table_name WHERE column1 = condition1 FOR UPDATE [NOWAIT|WAIT sec|SKIP LOCKED]
```

- use the `FOR UPDATE` clause in a query including joins, which the rows from all the joined ables are locked by default.

FOR UPDATE OF column(s) [SKIP LOCKED]

- To indicate which tables will be locked

<br/>

### 11. Flashback Operations

---

#### Flashback Operations

1. Data recovery technology that helps us to prevent data loss
1. Restore a table to a certain time, to a restore point, to a System Change Number (SCN)
1. While flashing back a table, all the table trigger are disabled. The `ENABLE TRIGGERS` clause will return the triggers to enabled.

`ALTER TABLE table_name ENABLE ROW MOVEMENT;`
To flashback a table, need to enable row movement.

```sql
FLASHBACK TABLE [schema_name1.]table_name1 [,[schema_name2.]table_name2,...]
					TO { { { SCN | TIMESTAMP } expr | RESTORE POINT restore_point }
					{[ ENABLE | DISABLE } TRIGGERS ] | BEFORE DROP [ RENAME TO new_table_name ]};
```

```sql
FLASHBACK TABLE employees_copy TO TIMESTAMP sysdate;
FLASHBACK TABLE employees_copy TO BEFORE DROP;

CREATE RESTORE POINT rp_test;
FLASHBACK TABLE employees_copy TO RESTORE POINT rp_test;
```

#### PURGE Operations

It is irreversible

PURGE operation while DROP table: `DROP TABLE table_name PURGE;`
PURGE dropped table in the recycle bin: `PURGE TABLE table_name;`

`VERSIONS` clause is used to trace all the changes in a table between two specific times or SCNs
Flashback a table to a specified System Change Number (SCN) or to a specific time

#### Flashback Query

`SELECT ... FROM table_name AS OF TIMESTAMP timestamp_value | SCN scn_value;`

#### Flashback Versions Query

Retrieves all the data that existed during a time interval in the pase

```sql
SELECT ... FROM table_name
	AS OF [TIMSTAMP BETWEEN time | MINVALUE AND time | MAXVALUE] |
				[SCN BETWEEN scn | MINVALUE AND scn | MAXVALUE];
```

- `VERSIONS_STARTTIME` returns the time when the change was applied
- `VERSIONS_STARTSCN` returns the SCN when the change was applied
- `VERSIONS_ENDTIME` returns the time when the row version expired
- `VERSION_ENDSCN` returns the SCN when the row version expired
- `VERSION_XID` returns the ID of a transaction which created the row version
- `VERSION_OPERATION` returns the operation type performed by the transaction. I -> insert D -> delete u -> update

```sql
SELECT versions_starttime, versions_endtime, versions_startscn, versions_endscn,
       versions_operation, versions_xid, employees_copy.*
  FROM employees_copy VERSIONS BETWEEN scn MINVALUE AND MAXVALUE
  WHERE employee_id = 100;

SELECT versions_starttime, versions_endtime, versions_startscn, versions_endscn,
       versions_operation, versions_xid, employees_copy.*
  FROM employees_copy VERSIONS
    BETWEEN TIMESTAMP (sysdate - interval '5'  minute) AND sysdate
  WHERE employee_id = 100;
```

<br/>

#### 12. Oracle Constraints in SQL

---

```sql
CREATE TABLE table_name
(
    -- Column-level Constraint
    column_1 type [CONSTRAINT constraint_name] CONSTRAINT_TYPE,
    column_2 type,
    ...
    -- Table-level Constraint
    [CONSTRAINT constraint_name] CONSTRAINT_TYPE (column_1, ... )
)
```

#### `NOT NULL` Constraint

- Prevent the insertion of NULL value
- NOT NULL constraints can only be created at the column-level

#### `UNIQUE` Constraint

- UNIQUE column or a set of columns where the combination must be unique can have multiple null values
- Composite unique constraint can contain a maximum of 32 columns, and only be created at the table-level

```sql
CREATE TABLE managers
(   manager_id    NUMBER NOT NULL UNIQUE,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50) CONSTRAINT lname_not_null
                    NOT NULL CONSTRAINT ln_uk UNIQUE,
    department_id NUMBER NOT NULL
    CONSTRAINT composite_uk UNIQUE(employee_id, first_name, last_name)
);
```

#### `PRIMARY KEY` Constraint

- Simple Primary Key(single-column) and Composite Primary Key(multiple columns)
- Composite primary key can only be created at the table-level

```sql
CREATE TABLE executives
(   executive_id NUMBER,
    first_name   VARCHAR2(50),
    last_name    VARCHAR2(50),
    CONSTRAINT exec_eid_pk PRIMARY KEY (executive_id, last_name)
);
```

#### `FOREIGN KEY` Constraint

- Foreign key is column or combination of columns used to enforce a relationship between a parent table and a child table
- The relationship is established between the parent table's primary/unique key and a column or set of columns in the child table
- Delete child record first, then able to delete parent record

```sql
CREATE TABLE managers
(
   manager_id NUMBER CONSTRAINT mgr_mid_uq UNIQUE,
   first_name VARCHAR2(50),
   last_name VARCHAR2(50),
   department_id NUMBER NOT NULL,
   phone_number VARCHAR2(11) UNIQUE NOT NULL,
   email VARCHAR2(100),
   UNIQUE (email),

   CONSTRAINT mgr_emp_fk FOREIGN KEY (manager_id)
     REFERENCES employees_copy (employee_id),
   CONSTRAINT mgr_names_fk FOREIGN KEY (first_name, last_name)
     REFERENCES employees_copy(first_name, last_name));

-- combination foreign key must unique combination in the parent table
CREATE TABLE employees_copy
(
   employee_id NUMBER(6) CONSTRAINT emp_cpy_eid_pk PRIMARY KEY,
   first_name VARCHAR(20),
   last_name VARCHAR(20),
   department_id NUMBER(4),

   CONSTRAINT emp_cpy_names_uk UNIQUE (first_name, last_name)
);
```

#### The `ON DELETE CASCADE | ON DELETE SET NULL` Clause

- The `ON DELETE CASCADE` clause deletes dependent rows in the child table
  when a related row in the parent table is deleted.

- The `ON DELETE SET NULL` clause updates dependent rows in the child table
  to NULL when a related row in the parent table is deleted.

```sql
CREATE TABLE managers
(
    manager_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    department_id NUMBER NOT NULL,
    phone_number VARCHAR2(11) UNIQUE NOT NULL,
    email VARCHAR2(100),
    UNIQUE (email),

    CONSTRAINT mgr_emp_fk FOREIGN KEY (manager_id)
      REFERENCES employees_copy (employee_id)
      ON DELETE SET NULL | ON DELETE CASCADE
);
```

#### `CHECK` Constraint

- Ensures a column or a group of columns meets a specific condition
- Cannot create check constraints referencing another table

```sql
CREATE TABLE managers
(
    manager_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    salary NUMBER,

    CONSTRAINT salary_check CHECK (salary > 100 and salary < 50000)
);
```

#### Adding Constraints via ALTER TABLE Statements

`ALTER TABLE table_name ADD [CONSTRAINT constraint_name] CONSTRAINT_TYPE
(column_name, ...);`

`ALTER TABLE employees MODIFY salary CONSTRAINT emp_salary_nn NOT NULL;`

1. To add a NOT NULL CONSTRAINT, we use the ALTER TABLE MODIFY COLUMN clause
1. The table must be empty or all the values of the NOT NULL column must
   have a value.

`ALTER TABLE table_name ADD UNIQUE(column_name);`

#### Dropping (Removing) Constraints

`ALTER TABLE table_name DROP CONSTRAINT constraint_name;`

- Use the ALTER TABLE statement to remove a constraint
- While dropping a PRIMARY KEY constraint, we can use the CASCADE option to drop all the associated FOREIGN KEY constraints.

```sql
ALTER TABLE table_name DROP CONSTRAINT constraint_name CASCADE;
ALTER TABLE table_name DROP PRIMARY KEY CASCADE;
```

#### Use the ONLINE keyword to allow DML operations while dropping constraints

`ALTER TABLE employees_copy DROP CONSTRAINT SYS_C008689 ONLINE;`

#### Cascading Constraints in Oracle

- Use the CASCADE CONSTRAINTS clause while dropping a column, all the constraints
- Referring to that column's PRIMARY and UNIQUE keys are dropped.

`ALTER TABLE table_name DROP COLUMN column_name CASCADE CONSTRAINTS;`

#### Renaming Constraints

`ALTER TABLE table_name RENAME CONSTRAINT old_name TO new_name;`

#### Disabling/Enabling Constraints

```sql
ALTER TABLE table_name DISABLE CONSTRAINT constraint_name;
ALTER TABLE table_name ENABLE CONSTRAINT constraint_name;
```

- To enable a constraint, all the data in the column or table must satisfy the constraint rules.

#### Status of Constraints

- `ENABLE VALIDATE` -- validate ALL rows
- `DISABLE VALIDATE` -- no DML operations are allowed -> read only
  <br>
- `ENABLE NOVALIDATE` -- only validate further inserts/updates
- `DISABLE NOVALIDATE` -- no validate ALL rows

`ALTER TABLE departments_copy ENABLE NOVALIDATE CONSTRAINT dept_cpy_id_pk;`

#### Deferring Constraint

Constraints only can set deferrable or not deferrable while creating DEFERRABLE

- Checking at the end of each query `INITIALLY IMMEDIATE(DEFAULT)`

- Postpones constraint enforcement until the end of transaction `INITIALLY DEFERRED`

- The NOT DEFERRABLE constraints will not change to DEFERRED `NOT DEFERRABLE (DEFAULT)`

```sql
ALTER TABLE table_name ADD CONSTRAINT
  constraint_name PRIMARY KEY (column_name) DEFERRABLE INITIALLY DEFERRED;
```

<br/>

### 13. Database Views

---

```sql
CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW view_name
  [(alias[, alias]...)] AS subquery
  [WITH CHECK OPTION [CONSTRAINT constraint_name]]
  [WITH READ ONLY [CONSTRAINT constraint_name]];
```

`REPLACE` -- Modifies the view without the need to re-grant its privileges
`FORCE `-- Create the view even if the base table does not exist
`NOFORCE` -- Create the view only if the base table exists (Default)
`WITH CHECK OPTION` -- Prevents any kind of DML operations that the view cannot select
`WITH READ ONLY` -- Prevents any DML operation on the view

```sql
CREATE VIEW empvw40 (e_id, name, surname, email) AS
  SELECT employee_id, first_name, last_name, email
    FROM employees WHERE department_id = 40;

SELECT * FROM empvw40;
```

#### Using the WITH CHECK OPTION Clause

- To ensure that the user can only perform any DML operations that the view selected
- It will check DML whether performed violating the WHERE clause

```sql
CREATE OR REPLACE VIEW empvw80 AS
  SELECT employee_id, first_name, last_name, email,
         hire_date, job_id, department_id
    FROM employees_copy
    WHERE department_id = 80 AND job_id = 'SA_MAN'
    WITH CHECK OPTION;

UPDATE empvw80 SET first_name = 'Steve' WHERE employee_id = 217; -- Good
UPDATE empvw80 SET department_id = 70 WHERE employee_id = 217; -- violated WHERE Clause
```

#### Using WITH READ ONLY Clause

can only use either WITH CHECK OPTION Clause OR WITH READ ONLY Clause

#### Dropping View

`DROP VIEW view_name;`

Dropping a view means deleting its definition from the database

<br/>

### 14. Data Dictionary Views

---

1. A data dictionary is a set of read-only tables that provides administrative
   metadata about the database and database objects.

1. Data dictionary views are a collection of tables and views that contain
   information about the database.

#### Dictionary View

- The complete list of all data dictionary views in the view named `DICTIONARY` all data dictionary view names are written in uppercase

`SELECT * FROM dictionary WHERE table_name = 'USER_TABLES';`

`SELECT * FROM dictionary WHERE UPPER(COMMENTS) LIKE '%SECURITY%';`

#### USER, DBA, ALL, V$ Prefixes

`USER` Prefix -- includes all the objects in the user's schema
`ALL` Prefix -- includes all the objects in user's schema and the objects that the user can access in all schemas
`DBA` Prefix -- includes all the objects of all users
`v$` Prefix -- includes views that have information about database performance

#### USER/DBA/ALL_OBJECTS View

To see all the objects that we own

#### USER/DBA/ALL_TABLES View

To see all the tables that we own

#### USER_TAB_COLUMNS View

To see all the columns of all tables and views that we won

#### USER_CONSTRAINTS Data Dictionary View

CONSTRAINT_TYPE

- C -> Check Constraint
- P -> Primary Key
- U -> Unique Key
- R -> Referential Integrity (Foreign Key)
- V -> With Check Option (Used For Views)
- O -> With Read-Only (Used For Views)

#### USER_TAB_COMMENTS / USER_COL_COMMENTS

![Alt text](../src/DataDicView.png 'DataDictionaryView')

<br/>

### 15. Oracle Sequences

---

- A sequence is a user-created object that automatically generates unique integer numbers
- It is generally used for populating `primary key` column values
- A sequence is a shareable object that can be shared by multiple users
- Sequence numbers are stored independent of tables so a sequence can be used by multiple users and for multiple tables
- Sequence numbers cannot be rolled back
- Sequence can be used anywhere to generate unique numbers

#### Creating Sequences

```sql
CREATE SEQUENCE [schema_name.]sequence_name
  [ { START WITH start_num }
  | { INCREMENT BY increment_num }
  | { MAXVALUE max_num | NOMAXVALUE }
  | { MINVALUE min_num | NOMINVALUE }
  | { CYCLE | NOCYCLE }
  | { CACHE cache_num | NOCACHE }
  | { ORDER | NOORDER }];

CREATE SEQUENCE employee_seq
  START WITH 100
  INCREMENT BY 3
  MAXVALUE 999
  CACHE 30
  NOCYCLE;
```

#### Modifying Sequences

- Be modified using the `ALTER SEQUENCE` statement
- Only future sequence numbers are affected
- Cannot use the `START WITH` option while modifying a sequence
- While modifying sequences, some validations are performed
- (e.g. MAXVALUE cannot be smaller than the CURRENT value)

```sql
ALTER SEQUENCE employee_seq
  INCREMENT BY 4
  NOCYCLE;
```

#### Dropping Sequences

`DROP SEQUENCE sequence_name;`

#### Using Sequences

`NEXTVAL` -- returns the next value of the sequence
`CURRVAL` -- returns the current sequence value

Can be used

- In the SELECT list of a query
- In the SELECT list of a subquery in an INSERT statement
- In the VALUES part of an INSERT statement
- In the SET clause of an UPDATE statement
  Can not be used
- With the DISTINCT keyword
- In the GROUP BY clause
- In the HAVING clause
- In the ORDER BY clause

```sql
INSERT INTO employees (employee_id, last_name, email, hire_date, job_id)
  VALUES (employee_seq.NEXTVAL, 'Smith','SMITH5',sysdate,'IT_PROG');
```

#### Using Sequences as Default Values

```sql
CREATE TABLE temp
(
  e_id INTEGER DEFAULT employee_seq.NEXTVAL,
  first_name VARCHAR2(50)
);
```

#### Sequence Caching

- Cache size can be defined when the sequence is initially created or altered (Default: 20)
- The specified number of sequence values is cached into memory on the first call
- Sequence values are retrieved from the cache on request
- After the last cached sequence value in memory is used, the next set of sequence
  values is cached

#### USER_SEQUENCES View

`IDENTITY` Column

- Restrictions
  - A table can have only one identity column
  - Identity columns must be `numeric data types`
  - Identity column is not inherited when using a CTS statement
  - Identity column cannot have another DEFAULT value
  - Identity columns implicitly have `NOT NULL` and `NOT DEFERRABLE` constraints
  - USER_TAB_IDENTITY_COLS to query all the identity columns
  - the SYS.IDENSEQ$ view stores the link between the table and

```sql
GENERATED [ ALWAYS | BY DEFAULT [ ON NULL ]] AS IDENTITY [(identity options)]
[   { START WITH start_num }
  | { INCREMENT BY increment_num }
  | { MAXVALUE max_num | NOMAXVALUE }
  | { MINVALUE min_num | NOMINVALUE }
  | { CYCLE | NOCYCLE }
  | { CACHE cache_num | NOCACHE }
  | { ORDER | NOORDER }
]
```

- `GENERATED ALWAYS`: always generates a value on each insert (default option)
- `GENERATED BY DEFAULT`: generates a value only if no value is provided
- `GENERATED BY DEFAULT ON NULL`: generates a value if a NULL value or nothing is specified
- Identity options has the same set of properties as a sequence

#### The DROP IDENTITY clause removes the identity property but keeps the column

`ALTER TABLE table_name MODIFY column_name DROP IDENTITY;`

#### START WITH LIMIT VALUE sets the existing maximum/minimum value + INCREMENT

BY value as the START WITH value

```sql
CREATE TABLE temp
(
  ID NUMBER
    GENERATED BY DEFAULT ON NULL AS IDENTITY
      START WITH 50 INCREMENT BY 3,
  txt VARCHAR2(100)
);
```

<br/>

### 16. Oracle Synonyms

---

- A synonym is a database object created to give an alternative's name to another database object.
- Useful for hiding the identity and location of the related object
- There can only be one index on the same set of columns
- NULL column values are not indexed in B-tree indexes

#### Creating, Using and Dropping Synonyms

```sql
CREATE [OR REPLACE] [PUBLIC] SYNONYM [schema_name.]synonym_name
  FOR [schema_name.]object_name[@db_link];
```

- Synonyms created without the PUBLIC option are considered private synonyms
- Private synonyms have higher precedence than public synonyms

```sql
DROP [PUBLIC] SYNONYM [schema_name.]synonym_name
```

```sql
CREATE SYNONYM test_syn FOR employees;
CREATE OR REPLACE SYNONYM test_syn FOR departments;

DROP SYNONYM test_syn;
```

#### Analyzing the USER_SYNONYMS View

To get the properties of the synonyms the user owns

<br/>

### 17.Oracle Indexes in SQL

---

1. Indexes are schema objects for speeding up the retrieval of rows by using their ROWIDs.
1. A ROWID is the physical location of a row
1. Indexes store ROWIDs of each row to get these rows faster
1. Only can create indexes while creating the table only for the primary key or foreign key or UNIQUE Constraint

```sql
CREATE [UNIQUE | BITMAP] INDEX index_name ON table_name ( column_name1,
[,column_name2]...);
```

#### The default index type is `Non-Unique B-tree Index`

```sql
CREATE INDEX temp_idx ON employees_copy (employee_id);
```

#### Unique indexes prevent duplicate value entry

```sql
CREATE UNIQUE INDEX temp_idx ON employees_copy (employee_id);
```

#### By using the ALTER TABLE statement

```sql
CREATE INDEX emp_id_idx ON emp(employee_id)
ALTER TABLE emp ADD PRIMARY KEY(employee_id) USING INDEX emp_id_idx;
```

`ALTER INDEX current_index_name RENMAE TO new_index_name;`

```sql
CREATE TABLE sales (
  sale_id NUMBER PRIMARY KEY USING INDEX
    (CREATE INDEX sales_sale_id_idx ON sales(sale_id)),
  sale_date DATE NOT NULL,
  customer_id NUMBER NOT NULL,
  transaction_id NUMBER UNIQUE USING INDEX
    (CREATE INDEX sale_tran_id_idx ON sales(transaction_id)),
  sale_detail_text VARCHAR2(4000));
```

#### Remove (Drop) Indexes

`DROP INDEX index_name [ONLINE];` -- indexes cannot be modified

#### Function-Based Indexes

```sql
CREATE [UNIQUE | BITMAP]
  INDEX index_name ON table_name
    ( function_name(column_name1, [,column_name2]...));
```

1. Multiple Indexes on the Same Columns & Invisible Indexes can be created on the same set of columns if the indexes are of different types
1. If there are multiple indexes on the same set of columns, only one index can be visible at a time

`/_+ hint _/` -- to force the optimizer to take some specific actions

```sql
CREATE INDEX emp_cpy_dpt_id_idx ON employees_copy (department_id);

CREATE BITMAP INDEX emp_cpy_dpt_id_idx2 ON employees_copy (department_id) INVISIBLE;

SELECT /_+ USE_INVISIBLE_INDEXES INDEX (employees_copy emp_cpy_dpt_id_idx2) _/ *
  FROM employees_copy WHERE department_id = 20;

ALTER INDEX emp_cpy_dpt_id_idx INVISIBLE;

ALTER SESSION SET optimizer_use_invisible_indexes = TRUE;
```

#### Analyzing the UESER\*INDEXES and USER_IND_COLUMNS Views

```sql
SELECT * FROM user*indexes;
SELECT * FROM user_ind_columns;
```

#### Altering Indexes

- Unusable indexes will be ignored by the server on index usage and maintenance `ALTER INDEX index_name UNUSABLE;`

- Unusable indexes need to rebuild `ALTER INDEX index_name REBUILD [ONLINE];`

- Function-based indexes can be enabled or disable if they are valid `ALTER INDEX index_name DISABLE | ENABLE;`

- Compiling an invalid index will make it valid again `ALTER INDEX index_name COMPILE;`

<br/>

### 18. Managing Oracle Privileges and Roles

---

#### Creating a Database User

`USER` -- a user is an account that you use to connect to a database and perform some operations
`Schema` -- a schema is a set of objects belonging to that user

```sql
CREATE USER user_name IDENTIFIED BY password;

CREATE USER user_name
  [IDENTIFIED BY password | NO AUTHENTICATION]
  [PASSWORD EXPIRE]
  [ACCOUNT {LOCK | UNLOCK}]
  [CONTAINTER = {CURRENT | ALL}];

DROP USER user_name;

ALTER USER user_name IDENTIFIED BY password;

SELECT * FROM dba_sys_privs;
SELECT * FROM user_role_privs;
```

<br/>

### 19. Using OVER and PARTITION with ORDER BY

---

#### OVER PARTITION

Works as window function
`aggregate_function OVER(PARTITION by col_name)`

```sql
select sum(weight) over(partition by color) sum_by_shape
  from bricks

```

#### OVER ORDER BY

The `order by` clause enables you to compute running totals.
`aggregate_function OVER(ORDER BY col_name)`

```sql
select sum(weight) over(partition by color order by id) running_weight_by_color
  from brick
```

#### Rank, Dense_rank, Lead and Lag Function

- Rank - Rows with the same value in the order by have the same rank.
- Dense_rank - Rows with the same value in the order by have the same rank, but there are no gaps in the ranks
- Row_number - each row has a new value

```sql
select id, weight
       row_number() over(order by weight) rn,
       rank() over(order by weight) rk,
       dense_rank() over(order by weight) dr
from bricks;
```

| id  | weight | RN  | RK  | DR  |
| --- | ------ | --- | --- | --- |
| 1   | 1      | 1   | 1   | 1   |
| 3   | 1      | 2   | 1   | 1   |
| 6   | 1      | 3   | 1   | 1   |
| 4   | 2      | 4   | 4   | 2   |
| 2   | 2      | 5   | 4   | 2   |
| 5   | 3      | 6   | 6   | 3   |

`Lead` and `Lag` to get values from rows backwards and forwards

<br/>

### Notes

---

Order of Execution
| Order | Clause | Function |
| ----- | ---------- | ----------------------------- |
| 1 | FROM | Choose and join tables to get base data |
| 2 | WHERE | Filters the base data |
| 3 | GROUP BY | Aggregates the base data |
| 4 | HAVING | Filters the aggregated data |
| 5 | SELECT | Returns the final data |
| 6 | ORDER BY | Sorts the final data |
