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

    -- Conditional INSERT FIRST Statement
    -- for the first WHEN clause that evaluates to true, then database executes the corresponding
    -- INTO clause and skip subsequent WHEN clauses for the given row.
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

-- Pivoting Insert
-- for converting non-relational data to a relational format and inserting it
-- into a relational table

-- UPDATE Statement
UPDATE table_name SET column1 = value1 [, column2 = value2, ...] [WHERE condition(s)];

-- using subquery
UPDATE employees_copy
SET (salary, commission_pct) = (SELECT max(salary), max(commission_pct) FROM employees)
WHERE job_id = 'IT_PROG';

UPDATE employees_copy
SET salary = 100000
WHERE hire_date = (SELECT MAX(hire_date) FROM employees);

-- DELETE Statement
DELETE [FROM] table_name [WHERE conditon];

-- MERGE Statement
-- to INSERT new records, UPDATE or DELETE existing ones depending on the
-- specified conditions at the same time

MERGE INTO target_table target_alias
USING(source table|view|subquery) source_alias
ON (join conditon)
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

MERGE INTO employees_copy c
USING employees e
ON (c.employee_id = e.employee_id)
WHEN MATCHED THEN
UPDATE SET
c.first_name = e.first_name,
c.last_name = e.last_name,
c.department_id = e.department_id,
c.salary = e.salary
DELETE WHERE department_id IS NULL
WHEN NOT MATCHED THEN
INSERT
VALUES(e.employee_id, e.first_name, e.last_name, e.email,
e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct,
e.manager_id, e.department_id);

-- Transaction Control Language (TCL)

-- it has to either happen in full or not at all
-- to ensure data integrity, data consistency and data security
-- finishes with any commit, rollback or system failure, or the
-- DDL or DCL statements.
-- after a DDL or DCL statement, the commit will be automatically executed
ROLLBACK / COMMIT

-- Row Lock in Oracle
-- during the transaction, the modify/delete/update rows are lock untill COMMIT

-- SAVEPOINT Statement
-- for longer transactions, savepoints are quite useful as they divide longer
-- transcations into smaller parts and mark certain points of a transaction as
-- checkpoints.

-- the SAVEPOINT statement saves the current state of a transaction and we can
-- roll back to that state.

SAVEPOINT name;
SAVEPINT TO name;

-- FOR UPDATE Statement
-- locks all the rows returned by the query
-- the rows that are already locked by another session wil not be able to be locked using
---- the FOR UPDATE statement
-- the NOWAIT keyword tells Oracle not to wait if the rows have already been locked
---- by another user
-- the SKIP LOCKED keyword tells Oracle to skip the locked rows and operate on the available
---- ones
SELECT \* FROM table_name WHERE column1 = condition1 FOR UPDATE [NOWAIT|WAIT sec|SKIP LOCKED]

-- use the FOR UPDATE clause in a query including joins, which the rows from all the joined
---- tables are locked by default.
FOR UPDATE OF column(s) [SKIP LOCKED]
-- to indicate which tables will be locked
