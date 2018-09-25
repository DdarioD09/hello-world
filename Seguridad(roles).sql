--ROLES-------------------------------------------------------------------------------------
CREATE ROLE sm_recursos_humanos;	
CREATE ROLE sm_bodega;	
CREATE ROLE sm_cajero;	
CREATE ROLE sm_gerente;	
CREATE ROLE sm_desarrollador;
 
 --ELIMINAR ROLES-----------------------------------------------------------------------------
DROP ROLE sm_recursos_humanos;
DROP ROLE sm_bodega;
DROP ROLE sm_cajero;
DROP ROLE sm_gerente;
DROP ROLE sm_desarrollador;

--REVOCAR PRIVILEGIOS-------------------------------------------------------------------------
--Ejemplos:
REVOKE create table, create sequence, create view
FROM super_dba;	

REVOKE select, update
ON FACTURA_VENTA
FROM super_cjr;

REVOKE select, update
ON INVENTARIO
FROM super_bdg;

--ORTORGANDO PRIVILEGIOS DE SISTEMA----------------------------------------------------------
GRANT create session
TO sm_recursos_humanos;

GRANT create session
TO sm_bodega;

GRANT create session
TO sm_cajero;

GRANT create session
TO sm_gerente;

GRANT create session, create view
TO sm_desarrollador;

--PRIVILEGIOS DE OBJETOS-----------------------------------------------------------------------

--Cajero--
GRANT select, update
ON FACTURA_VENTA
TO sm_cajero;

GRANT select
ON DETALLE_VENT;
TO sm_cajero;

--Bodega---
GRANT insert, select
ON INVENTARIO
TO sm_bodega;

GRANT update(cod_est)
ON INVENTARIO
TO sm_bodega;

GRANT select
ON DETALLE_VENT
TO sm_bodega;

--recursos humanos--
GRANT select, delete, insert, update
ON EMPLEADO
TO sm_recursos_humanos;

--gerente--
GRANT select, update, delete
ON EMPLEADO
TO sm_gerente;

GRANT select, update, delete
ON INVENTARIO
TO sm_gerente;

GRANT select
ON PUNTO_VENTA
TO sm_gerente;

/*desarrollador:
se le permite hacer consulta de los datos de las tablas
para que pueda realizar las vistas de la aplicación*/
GRANT select
ON DETALLE_VENT
TO sm_desarrollador;

GRANT select
ON FACTURA_VENTA
TO sm_desarrollador;

GRANT select
ON INVENTARIO
TO sm_desarrollador;

GRANT select
ON TIPO_ESTADO
TO sm_desarrollador;

GRANT select
ON PRODUCTO
TO sm_desarrollador;

GRANT select
ON CATEGORIA_PROD
TO sm_desarrollador;

GRANT select
ON DETALLE_ORDEN
TO sm_desarrollador;

GRANT select
ON ORDEN_COM
TO sm_desarrollador;

GRANT select
ON MED_PAGO
TO sm_desarrollador;

GRANT select
ON PROVEEDOR
TO sm_desarrollador;

GRANT select
ON CLIE_PUNTO
TO sm_desarrollador;

GRANT select
ON PUNTO_VENTA
TO sm_desarrollador;

GRANT select
ON CLIENTE
TO sm_desarrollador;

GRANT select
ON EMPLEADO
TO sm_desarrollador;

GRANT select
ON CARGO
TO sm_desarrollador;
-----------------------------------------------------------------------------------------------
