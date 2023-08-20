# MySQL Basic Knowledge

- [MySQL Basic Knowledge](#mysql-basic-knowledge)
  - [Creating Databases \& Tables](#creating-databases--tables)
    - [Create Database](#create-database)
    - [Drop Database](#drop-database)
    - [Use Database](#use-database)
    - [Create Table](#create-table)
    - [Show Columns From Table](#show-columns-from-table)
  - [CRUD Data](#crud-data)
    - [Single Insert](#single-insert)
    - [Multiple Insert](#multiple-insert)
    - [Two method for specifying a PRIMARY KEY](#two-method-for-specifying-a-primary-key)
    - [Update](#update)
    - [Delete](#delete)
    - [ALTER TABLE](#alter-table)
    - [Modify column definition](#modify-column-definition)
  - [Functions](#functions)
    - [Concat](#concat)
    - [Substring](#substring)
    - [Combine String Functions](#combine-string-functions)
    - [Replace](#replace)
    - [CHAR_LENGTH](#char_length)
    - [UPPER \& LOWER](#upper--lower)
    - [INSERT(str, pos, len, newstr)](#insertstr-pos-len-newstr)
    - [LEFT(str, len)](#leftstr-len)
    - [REPEAT(str, count)](#repeatstr-count)
    - [TRIM(str)](#trimstr)
    - [LIMIT count OR LIMIT begin_index, count](#limit-count-or-limit-begin_index-count)
    - [LIKE '%' means wildcard '\_' means exactly 1 character](#like--means-wildcard-_-means-exactly-1-character)
    - [GROUP BY](#group-by)
    - [GROUP BY Multiple Columns](#group-by-multiple-columns)
    - [GROUP BY With HAVING clause](#group-by-with-having-clause)
    - [GROUP BY WITH ROLLUP](#group-by-with-rollup)
  - [Notes](#notes)
    - [Data Type with Decimal](#data-type-with-decimal)
    - [Date Functions](#date-functions)
    - [DEFAULT \& UPDATE TIMESTAMPS](#default--update-timestamps)
    - [Comparing Dates](#comparing-dates)
    - [IN Operator](#in-operator)
    - [CASE Statements](#case-statements)
    - [CHECK Constraints](#check-constraints)
    - [FOREIGN KEY](#foreign-key)
    - [IFNULL](#ifnull)
    - [IF Condition](#if-condition)
    - [VIEW](#view)
    - [Replacing/Altering Views](#replacingaltering-views)

<br/><br/>

## Creating Databases & Tables

---

#### Create Database

```sql
CREATE DATABASE <database_name>;

CREATE DATABASE pet_shop;
```

#### Drop Database

```sql
DROP DATABASE <database_name>;
```

#### Use Database

```sql
USE <database_name>;
```

#### Create Table

```sql
CREATE TABLE <talbe_name>(
	name VARCHAR(50),
	age INT
);
```

#### Show Columns From Table

```sql
SHOW <tables_name>;
SHOW COLUMNS FROM <table_name>;

DESC <table_name>;
```

<br/>

## CRUD Data

---

#### Single Insert

Order not matter

```sql
INSERT INTO <table_name> (<column_1>, <column_2>) VALUES (<value_1>, <value_2>);
```

#### Multiple Insert

```sql
INSERT INTO <table_name> (<column_1>, <column_2>)
    VALUES  (<value_1>, <value_1>),
		    (<value_2>, <value_2>)
			(<value_3>, <value_3>);
```

- `NOT NULL`, insert NULL into NOT NULL column cause ERROR

- Escape quote with using backslash => \'

#### Two method for specifying a PRIMARY KEY

```sql
CREATE TABLE unique_cats(
	cat_id INT PRIMARY KEY
);
CREATE TABLE unique_cats(
	cat_id INT AUTO_INCREMENT,
	PRIMARY KEY (cat_id)
);
```

#### Update

```sql
UPDATE <table_name> SET <column_1> = <new_value> WHERE <column_1> = <old_value>;
```

#### Delete

```sql
DELETE FROM <table_name> WHERE <column_1> = <value_1>;
```

#### ALTER TABLE

```sql
ALTER TABLE table_name ADD COLUMN column_name <data_type>;

ALTER TABLE table_name DROP COLUMN column_name;

ALTER TABLE table_name RENAME TABLE old_name TO new_name

RENAME TABLE old_name TO new_name;

ALTER TABLE table_name RENAME COLUMN  old_name TO new_name;
```

#### Modify column definition

```sql
ALTER TABLE table_name MODIFY column_name <new_data_type>;

ALTER TABLE table_name CHANGE old_name new_name <new_data_type>;
```

<br/>

## Functions

---

#### Concat

```sql
SELECT CONCAT('H','e','l','l','o'); -- OUTPUT: Hello

SELECT CONCAT(<column_1>, <column_2>, value) FROM <table_name>;

SELECT CONCAT_WS('-', <column_1>, <column_2>, <column_3>) FROM <table_name>
-- '-'as separator, OUTPUT: value_1-value_2-value_3
```

#### Substring

```sql
SUBSTRING('Hello World', 1, 4) -- OUTPUT: Hell
SUBSTRING('Hello World', 7) -- OUTPUT: World
SUBSTRING('Hello World', -1) -- OUTPUT: d
```

#### Combine String Functions

```sql
CONCAT(SUBSTR(<column_name>, begin_index, end_index), 'str')
```

#### Replace

```sql
REPLACE(str, from_str, to_str)
```

#### CHAR_LENGTH

```sql
LENGTH('Hey!') -- OUTPUT: 4
```

#### UPPER & LOWER

```sql
UPPER('hello') -- OUTPUT: HELLO
LOWER('HELLO') -- OUTPUT: hello
```

#### INSERT(str, pos, len, newstr)

```sql
INSERT('Hello Bobby', 6, 0, 'There') -- OUTPUT: Hello There Bobby
INSERT('Hello Booby', 6, 4, 'There') -- OUTPUT: Hello Thereby
```

#### LEFT(str, len)

```sql
LEFT('foobarbar', 5) -- OUTPUT: 'fooba'
```

#### REPEAT(str, count)

```sql
REPEAT('My', 3) -- OUTPUT: 'MyMyMy'
```

#### TRIM(str)

```sql
TRIM('   pickle ') -- OUTPUT: 'pickle'
```

#### LIMIT count OR LIMIT begin_index, count

```sql
LIMIT 5
LIMIT 0,5
```

#### LIKE '%' means wildcard '\_' means exactly 1 character

```sql
LIKE '%str%'
LIKE '_str_'
```

#### GROUP BY

```sql
SELECT author_lname, COUNT(*) FROM books
    GROUP BY author_lname;
```

#### GROUP BY Multiple Columns

```sql
SELECT CONCAT(author_lname,' ',author_fname) AS Author, COUNT(*)
    FROM books
    GROUP BY Author;
```

#### GROUP BY With HAVING clause

```sql
SELECT author_lname, COUNT(*) FROM books
    GROUP BY author_lname
    HAVING COUNT(*) > 1
```

#### GROUP BY WITH ROLLUP

Will add extra row with summary average grade

```sql
SELECT author_lname, AVG(grade) FROM books
    GROUP BY author_lname WITH ROLLUP;
```

-- Subqueries
SELECT title, pages FROM books
WHERE pages = (SELECT MAX(pages) FROM books);

<br/>

## Notes

#### Data Type with Decimal

```sql
DECIMAL (<Total Number Of Digits>, <Digits After Decimal>)
```

#### Date Functions

```sql
DAY('2007-02-03') -- OUTPUT: 3
DAYOFWEEK('2007-02-03') -- OUTPUT: 7, 1 For Monday, ... , 6 For Saturday
MONTHNAME('2000-12-25') -- OUTPUT: December
DATE_FORMAT('2000-12-25', '%a %b %D') -- OUTPUT: Mon Dec 25th

DATEDIFF(expr1, expr2)
DATEDIFF('2000-12-25', '2000-12-28') -- OUTPUT: 3

DATE_ADD('2000-12-25', INTERVAL 1 YEAR) -- OUTPUT: 2001-12-25
```

#### DEFAULT & UPDATE TIMESTAMPS

```sql
CREATE TABLE captions (
  text VARCHAR(150),
  created_at TIMESTAMP default CURRENT_TIMESTAMP,
  updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Comparing Dates

```sql
CAST(expr AS type [ARRAY])
CAST('12:31:00' AS TIME)
```

#### IN Operator

```sql
<column> IN ('value_1', 'value_2', 'value_3')
```

#### CASE Statements

```sql
CASE
	WHEN condition_1 THEN value_1
	WHEN condition_2 THEN value_2
	ELSE value_2
END AS alias
```

#### CHECK Constraints

```sql
CREATE TABLE users(
	username VARCHAR(20) NOT NULL,
	age INT CHECK (age > 0) -- CHECK works as Conditions check
    word VARCHAR(10) CHECK(REVERSE(word) = word)
)
CREATE TABLE users(
	username VARCHAR(20) NOT NULL,
	age INT
	CONSTRAINT age_not_negative CHECK (age > 0)
);
```

#### FOREIGN KEY

```sql
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
	-- DELETE customer will auto delete orders belong to that customer
);
```

#### IFNULL

```sql
IFNULL(do_something, else_do_something)
```

#### IF Condition

```sql
IF (Condition, 'true_result', 'false_result')
```

#### VIEW

Virtual table

```sql
CREATE VIEW view_table_name AS
    SELECT * FROM table_name
```

#### Replacing/Altering Views

```sql
CREATE OR REPLACE VIEW view_table_name AS
    SELECT * FROM table_name

ALTER VIEW view_table AS
    SELECT * FROM table_name
```
