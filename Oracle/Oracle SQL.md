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
