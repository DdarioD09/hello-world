/* Se tiene que crear la cantidad de tablas con las debidas auditorias de los cambios realizadon en DML
los campos de las tablas tienen que tener incluido fecha del cambio y quien lo hizo 

TABLAS:
empleado		insert, update, delete,
cliente			insert, update, delete,
inventario		update, delete
orden_com		insert, delete
factura_venta	insert, delete

Cada tabla va a tener un tipo de estado que determinará si fue una insercion, actualizacion o eliminacion
del dato al que se le está haciendo la auditoria


*/

/*CREACION DE LAS TABLAS QUE SE USARÁN EN LA AUDITORIA */
CREATE TABLE AUD_EMPLEADO
	(FECHA DATE NOT NULL,
	USUARIO VARCHAR2(20) NOT NULL,
	DML_OPERATION VARCHAR2(15) NOT NULL,
	VIEJO_VAL VARCHAR2(40),
	NUEVO_VAL VARCHAR2(40) );

CREATE TABLE AUD_CLIENTE
	(FECHA DATE NOT NULL,
	USUARIO VARCHAR2(20) NOT NULL,
	DML_OPERATION VARCHAR2(15) NOT NULL,
	VIEJO_VAL VARCHAR2(40),
	NUEVO_VAL VARCHAR2(40) );

CREATE TABLE AUD_INVENTARIO
	(FECHA DATE NOT NULL,
	USUARIO VARCHAR2(20) NOT NULL,
	DML_OPERATION VARCHAR2(15) NOT NULL,
	VIEJO_VAL VARCHAR2(20),
	NUEVO_VAL VARCHAR2(20) );

CREATE TABLE AUD_ORDEN_COM
	(FECHA DATE NOT NULL,
	USUARIO VARCHAR2(20) NOT NULL,
	DML_OPERATION VARCHAR2(15) NOT NULL,
	VIEJO_VAL VARCHAR2(10),
	NUEVO_VAL VARCHAR2(10) );

CREATE TABLE AUD_FACTURA_VENTA
	(FECHA DATE NOT NULL,
	USUARIO VARCHAR2(20) NOT NULL,
	DML_OPERATION VARCHAR2(15) NOT NULL,
	VIEJO_VAL VARCHAR2(10),
	NUEVO_VAL VARCHAR2(10) );

/*ELIMINADOR DE TABLAS DE AUDITORIA */
DROP TABLE AUD_CLIENTE;
DROP TABLE AUD_INVENTARIO;
DROP TABLE AUD_EMPLEADO;
DROP TABLE AUD_FACTURA_VENTA;
DROP TABLE AUD_ORDEN_COM;

--TRIGGERS---------------------------------------------------------

--AUD_EMPLEADO
CREATE OR REPLACE TRIGGER auditar_empleado
AFTER DELETE OR INSERT OR UPDATE OF dir_emp, tel_emp, cod_pventa ON empleado
FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

IF inserting THEN
	 INSERT INTO AUD_EMPLEADO
	 VALUES (SYSDATE, v_user, 'INSERT', 'NO_APLICA', :new.dir_emp);

ELSIF updating THEN
	 INSERT INTO AUD_EMPLEADO
	 VALUES (SYSDATE, v_user, 'UPDATE', :old.dir_emp, :new.dir_emp);

ELSE
	 INSERT INTO AUD_EMPLEADO
	 VALUES (SYSDATE, v_user, 'DELETE', :old.dir_emp, :new.dir_emp);
 END IF;
END auditar_empleado;
/

--AUD_CLIENTE
CREATE OR REPLACE TRIGGER auditar_cliente
AFTER DELETE OR INSERT OR UPDATE OF tel_clie, dir_clie ON cliente
FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

IF inserting THEN
	 INSERT INTO AUD_CLIENTE
	 VALUES (SYSDATE, v_user, 'INSERT', 'NO_APLICA', :new.tel_clie);

ELSIF updating THEN
	 INSERT INTO AUD_CLIENTE
	 VALUES (SYSDATE, v_user, 'UPDATE', :old.tel_clie, :new.tel_clie);

ELSE
	 INSERT INTO AUD_CLIENTE
	 VALUES (SYSDATE, v_user, 'DELETE', :old.tel_clie, :new.tel_clie);
 END IF;
END auditar_cliente;
/

--AUD_INVENTARIO
CREATE OR REPLACE TRIGGER auditar_estado_inventario
AFTER DELETE OR UPDATE OF cod_est ON inventario
FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
	v_estado tipo_estado.desc_est%TYPE;
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

IF updating THEN
	 INSERT INTO AUD_INVENTARIO
	 VALUES (SYSDATE, v_user, 'UPDATE', :old.cod_est, :new.cod_est);

ELSE
	 INSERT INTO AUD_INVENTARIO
	 VALUES (SYSDATE, v_user, 'DELETE', :old.cod_est, :new.cod_est);
 END IF;
END auditar_estado_inventario;
/


--AUD_ORDEN_COM
CREATE OR REPLACE TRIGGER auditar_cod_orden
AFTER DELETE OR INSERT ON orden_com
FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

IF inserting THEN
	 INSERT INTO AUD_ORDEN_COM
	 VALUES (SYSDATE, v_user, 'INSERT', 'NO_APLICA', :new.cod_orden);

ELSE
	 INSERT INTO AUD_ORDEN_COM
	 VALUES (SYSDATE, v_user, 'DELETE', :old.cod_orden, :new.cod_orden);
 END IF;
END auditar_cod_orden;
/

--AUD_FACTURA_VENTA
CREATE OR REPLACE TRIGGER auditar_cod_venta
AFTER DELETE OR INSERT ON factura_venta
FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

IF inserting THEN
	 INSERT INTO AUD_FACTURA_VENTA
	 VALUES (SYSDATE, v_user, 'INSERT', 'NO_APLICA', :new.cod_fac_vent);

ELSE
	 INSERT INTO AUD_FACTURA_VENTA
	 VALUES (SYSDATE, v_user, 'DELETE', :old.cod_fac_vent, :new.cod_fac_vent);
 END IF;
END auditar_cod_venta;
/


CREATE OR REPLACE TRIGGER auditar_dir_empleado
	AFTER INSERT ON empleado
	FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

	INSERT INTO AUD_EMPLEADO
	VALUES (SYSDATE, v_user, 'INSERT', 'NO_APLICA', :new.dir_emp);
END auditar_dir_empleado;
/

CREATE OR REPLACE TRIGGER auditar_dir_empleado
	AFTER UPDATE OF dir_emp ON empleado
	FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

	INSERT INTO AUD_EMPLEADO
	VALUES (SYSDATE, v_user, 'UPDATE', :old.dir_emp, :new.dir_emp);
END auditar_dir_empleado;
/

CREATE OR REPLACE TRIGGER auditar_dir_empleado
	AFTER DELETE ON empleado
	FOR EACH ROW
DECLARE
	v_user VARCHAR2(20);
BEGIN
	--Guarda en una variable el usuario conectado
	SELECT USER
	INTO v_user
	FROM DUAL;

	INSERT INTO AUD_EMPLEADO
	VALUES (SYSDATE, v_user, 'DELETE', :old.dir_emp, :new.dir_emp);
END auditar_dir_empleado;
/



UPDATE empleado
SET dir_emp= 'FONTIBON'
WHERE id_emp = 7383;

UPDATE inventario SET cod_est = 2 WHERE cod_barras = 9809;
UPDATE inventario SET cod_est = 1 WHERE cod_barras = 9810;
UPDATE inventario SET cod_est = 1 WHERE cod_barras = 9811;
UPDATE inventario SET cod_est = 1 WHERE cod_barras = 9812;
UPDATE inventario SET cod_est = 3 WHERE cod_barras = 9813;
UPDATE inventario SET cod_est = 4 WHERE cod_barras = 9814;
UPDATE inventario SET cod_est = 4 WHERE cod_barras = 9815;

DELETE empleado
WHERE id_emp = 7383;

INSERT INTO empleado VALUES (7384,'SMITH','CLERK','34427646',NULL,'VIEJO',10,20);

INSERT INTO CLIENTE VALUES (7655,'MARTIN','LISETH','466775332',NULL,'fd');