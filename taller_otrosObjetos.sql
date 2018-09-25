1
CREATE SEQUENCE dept_id_seq
INCREMENT BY 10
START WITH 60
MAVALUE 200
NOCACHE
NOCYCLE;

2
edit p13q2.sql
SELECT 	sequence_name, max_value,
	increment_by,last_number
FROM	user_sequences;
start p13q2.sql

3
edit p13q3.sql
ACCEPT department_name PROMPT 'Ingrese el nombre del departmento que 
desea crear:'
ACCEPT department_loc PROMPT 'Ingrese el nombre de la localizacion 
del departmento'
INSERT INTO dept (deptno, dname, loc)
VALUES (dept_id_seq.NEXTVAL, '&department_name', '&department_loc');
start p13q3.sql
SELECT * FROM dept;

4
CREATE INDEX emp_dept_id_idx
ON EMPLOYEE(dept_id);

5
edit p13q5.sql
SELECT 	ic.index_name, ic.table_name, ix.uniqueness
FROM	user_indexes ix, user_ind_columns ic
WHERE	ic.index_name = ix.index_name
AND		ic.table_name = 'EMPLOYEE';
start p13q5.sql