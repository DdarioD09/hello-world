--TABLAS------------------------------------------------------------------------------
CREATE TABLE CARGO
	(COD_CARG NUMBER(2) CONSTRAINT CARGO_COD_CARG_PK PRIMARY KEY,
	CARGO VARCHAR2(15) NOT NULL,
	SALARIO NUMBER(10,2) NOT NULL);

CREATE TABLE PUNTO_VENTA
	(COD_PVENTA NUMBER(2) CONSTRAINT PUNTO_VENTA_COD_PVENTA_PK PRIMARY KEY,
	NOMBRE_PVENTA VARCHAR2(30) NOT NULL,
	DIR_PVENTA VARCHAR2(40) );

CREATE TABLE EMPLEADO
	(ID_EMP NUMBER(4) CONSTRAINT EMPLEADO_ID_EMP_PK PRIMARY KEY,
	APELLIDO_EMP VARCHAR2(15) NOT NULL,
	NOMBRE_EMP VARCHAR2(15) NOT NULL,
	TEL_EMP VARCHAR2(10),
	EMAIL_EMP VARCHAR2(30),
	DIR_EMP VARCHAR2(40),
	FECHA_INGRESO DATE NOT NULL,
	FECHA_SALIDA DATE,
	COD_CARG NUMBER(2) NOT NULL,
	COD_PVENTA NUMBER(2) NOT NULL,
	CONSTRAINT EMPLEADO_COD_CARG_FK FOREIGN KEY (COD_CARG) REFERENCES CARGO (COD_CARG),	
	CONSTRAINT EMPLEADO_COD_PVENTA_FK FOREIGN KEY (COD_PVENTA) REFERENCES PUNTO_VENTA(COD_PVENTA) );

CREATE TABLE CLIENTE
	(ID_CLIE NUMBER(4) CONSTRAINT CLIENTE_ID_CLIE_PK PRIMARY KEY,
	APELLIDO_CLIE VARCHAR2(15) NOT NULL,
	NOMBRE_CLIE VARCHAR2(15) NOT NULL,
	TEL_CLIE VARCHAR2(10),
	EMAIL_CLIE VARCHAR2(30),
	DIR_CLIE VARCHAR2(40) );

CREATE TABLE CLIE_PUNTO
	(ID_CLIE NUMBER(4) NOT NULL,
	COD_PVENTA NUMBER(2) NOT NULL,
	CONSTRAINT CLIE_PUNTO_ID_CLIE_FK FOREIGN KEY (ID_CLIE) REFERENCES CLIENTE(ID_CLIE),
	CONSTRAINT CLIE_PUNTO_COD_PVENTA_FK FOREIGN KEY (COD_PVENTA) REFERENCES PUNTO_VENTA(COD_PVENTA) );

CREATE TABLE PROVEEDOR
	(ID_PROV NUMBER(4) CONSTRAINT PROVEE_ID_PROV_PK PRIMARY KEY,
	NOM_EMPRESA VARCHAR2(30) NOT NULL,
	DIR_PROV VARCHAR2(40));

CREATE TABLE MED_PAGO
	(COD_MPAGO NUMBER(2) CONSTRAINT COD_MPAGO_PK PRIMARY KEY,
	MPAGO VARCHAR2(20) NOT NULL);

CREATE TABLE ORDEN_COM
	(COD_ORDEN NUMBER(10) CONSTRAINT ORDEN_COM_COD_ORDEN_PK PRIMARY KEY,
	FECHA_ORDEN DATE NOT NULL,
	PREC_TOT_ORDEN NUMBER(10,2),
	COD_MPAGO NUMBER(2) NOT NULL,
	ID_EMP NUMBER(4) NOT NULL,
	ID_PROV NUMBER(4) NOT NULL,
	CONSTRAINT ORDEN_COM_COD_MPAGO_FK FOREIGN KEY (COD_MPAGO) REFERENCES MED_PAGO(COD_MPAGO),
	CONSTRAINT ORDEN_COM_ID_EMP_FK FOREIGN KEY (ID_EMP) REFERENCES EMPLEADO(ID_EMP),
	CONSTRAINT ORDEN_COM_ID_PROV_FK FOREIGN KEY (ID_PROV) REFERENCES PROVEEDOR(ID_PROV) );

CREATE TABLE DETALLE_ORDEN
	(COD_BARRAS NUMBER(10) CONSTRAINT DETALLE_ORDEN_COD_BARRAS_PK PRIMARY KEY,
	UPREC_COM NUMBER(8,2) NOT NULL,
	COD_ORDEN NUMBER(10) NOT NULL,
	CONSTRAINT DETALLE_ORDEN_COD_ORDEN_FK FOREIGN KEY (COD_ORDEN) REFERENCES ORDEN_COM(COD_ORDEN) );

CREATE TABLE CATEGORIA_PROD
	(COD_CATEG NUMBER(4) CONSTRAINT CATEG_COD_CATEG_PK PRIMARY KEY,
	NOM_CATEG VARCHAR2(30) NOT NULL);

CREATE TABLE PRODUCTO
	(COD_PROD NUMBER(6) CONSTRAINT PRODUCTO_COD_PROD_PK PRIMARY KEY,
	NOM_PROD VARCHAR2(30) NOT NULL,
	DESC_PROD VARCHAR2(40),
	COD_CATEG NUMBER(4) NOT NULL,
	CONSTRAINT PRODUCTO_COD_CATEG_FK FOREIGN KEY (COD_CATEG) REFERENCES CATEGORIA_PROD(COD_CATEG) );
    
CREATE TABLE TIPO_ESTADO
	(COD_EST NUMBER(2) CONSTRAINT TIPO_EST_COD_EST_PK PRIMARY KEY,
	DESC_EST VARCHAR2(20) NOT NULL);

CREATE TABLE INVENTARIO
	(COD_BARRAS NUMBER(10) CONSTRAINT INVENT_COD_BARRAS_PK PRIMARY KEY,
	LOTE_PROD VARCHAR2(10) NOT NULL,
	FECHA_CADUC DATE NOT NULL,
	COD_EST NUMBER(2) NOT NULL,
	COD_PROD NUMBER(6) NOT NULL,
	CONSTRAINT INVENT_COD_EST_FK FOREIGN KEY (COD_EST) REFERENCES TIPO_ESTADO(COD_EST),
	CONSTRAINT INVENT_COD_PROD_FK FOREIGN KEY (COD_PROD) REFERENCES PRODUCTO(COD_PROD),
	CONSTRAINT INVENT_COD_BARRAS_FK FOREIGN KEY (COD_BARRAS) REFERENCES DETALLE_ORDEN(COD_BARRAS) );

CREATE TABLE FACTURA_VENTA
	(COD_FAC_VENT NUMBER(10) CONSTRAINT FACT_VENT_COD_FAC_VENT_PK PRIMARY KEY,
	FECHA_VENT DATE NOT NULL,
	ID_EMP NUMBER(4) NOT NULL,
	ID_CLIE NUMBER(4) NOT NULL,
	PREC_TOT_VENT NUMBER(9,2),
	COD_MPAGO NUMBER(2) NOT NULL,
	CONSTRAINT FACT_VENT_ID_EMP_FK FOREIGN KEY (ID_EMP) REFERENCES EMPLEADO(ID_EMP),
	CONSTRAINT FACT_VENT_ID_CLIE_FK FOREIGN KEY (ID_CLIE) REFERENCES CLIENTE(ID_CLIE),
	CONSTRAINT FACT_VENT_COD_MPAGO_FK FOREIGN KEY (COD_MPAGO) REFERENCES MED_PAGO(COD_MPAGO) );	

CREATE TABLE DETALLE_VENT
	(COD_BARRAS NUMBER(10) CONSTRAINT DETALLE_VENT_COD_BARRAS_PK PRIMARY KEY,
	UPREC_VENT NUMBER(8,2) NOT NULL,
	COD_FAC_VENT NUMBER(10) NOT NULL,
	CONSTRAINT DETALLE_VENT_COD_FAC_VENT_FK FOREIGN KEY (COD_FAC_VENT) REFERENCES FACTURA_VENTA(COD_FAC_VENT),
	CONSTRAINT DETALLE_VENT_COD_BARRAS_FK FOREIGN KEY (COD_BARRAS) REFERENCES INVENTARIO(COD_BARRAS) );

--VISTAS--------------------------------------------------------------------------------------------------------

--CREACION DE VISTAS SIMPLES:
CREATE VIEW CLIENTE_VU
(CEDULA, APELLIDO, NOMBRE, EMAIL)
AS SELECT ID_CLIE, APELLIDO_CLIE, NOMBRE_CLIE, EMAIL_CLIE
FROM CLIENTE;

CREATE VIEW PVENTA_VU
(PUNTO_VENTA, UBICACION)
AS SELECT NOMBRE_PVENTA, DIR_PVENTA
FROM PUNTO_VENTA;

--CREACION DE VISTAS COMPLEJAS:

CREATE VIEW LUGARCOMP_VU
(CLIENTE,PUNTO,UBICACION)
AS SELECT c.nombre_clie, pt.nombre_pventa, pt.dir_pventa
FROM cliente c, punto_venta pt, clie_punto ptc
WHERE c.id_clie = ptc.id_clie AND pt.cod_pventa = ptc.cod_pventa;

CREATE VIEW PRODUCT_VU
(COD_BARRAS, PRODUCTO, CATEGORIA, ESTADO)
AS SELECT i.cod_barras, p.nom_prod, ctg.nom_categ, est.desc_est
FROM inventario i, producto p, categoria_prod ctg, tipo_estado est
WHERE i.cod_prod = p.cod_prod AND p.cod_categ = ctg.cod_categ
AND i.cod_est = est.cod_est;

CREATE VIEW FACTURA_VU
(COD_FACT, CLIENTE, COD_BARRAS, PRODUCTO, FECHA_COMPRA, PUNTO, MED_PAGO, VENDEDOR)
AS SELECT f.COD_FAC_VENT, c.nombre_clie, df.cod_barras, p.nom_prod, f.fecha_vent,
pt.nombre_pventa, mp.mpago, v.nombre_emp
FROM factura_venta f, cliente c, detalle_vent df, inventario i, producto p,
punto_venta pt, clie_punto ptc, med_pago mp, empleado v
WHERE p.cod_prod = i.cod_prod AND i.cod_barras = df.cod_barras AND df.COD_FAC_VENT = f.COD_FAC_VENT
AND f.id_clie = c.id_clie  AND c.id_clie = ptc.id_clie AND pt.cod_pventa = ptc.cod_pventa
AND f.cod_mpago = mp.cod_mpago AND f.id_emp = v.id_emp;

----SECUENCIAS PARA LLAVES PRIMARIAS EN CADA TABLA-------------------------------------------------------------
CREATE SEQUENCE cargo_cod_carg
    INCREMENT BY 5
    START WITH 35
    MAXVALUE 90
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE punto_venta_cod_pventa
    INCREMENT BY 10
    START WITH 80
    MAXVALUE 90
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE empleado_id_emp
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE cliente_id_clie
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE proveedor_id_prov
    INCREMENT BY 1
    START WITH 8
    MAXVALUE 4000
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE med_pago_cod_mpago
    INCREMENT BY 1
    START WITH 4
    MAXVALUE 20
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE orden_com_cod_orden
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;
    
CREATE SEQUENCE detalle_orden_cod_barras
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;
    
CREATE SEQUENCE catgoria_prod_cod_categ
    INCREMENT BY 1
    START WITH 1005
    MAXVALUE 5000
    NOCACHE
    NOCYCLE;
    
CREATE SEQUENCE producto_cod_prod
    INCREMENT BY 1
    START WITH 8
    MAXVALUE 600000
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE tipo_estado_cod_est
    INCREMENT BY 1
    START WITH 5
    MAXVALUE 90
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE factura_venta_cod_fac_vent
    INCREMENT BY 1
    START WITH 112235
    MAXVALUE 9999999999
    NOCACHE
    NOCYCLE;

--INDICES---------------------------------------------------------------
CREATE INDEX empleado_emp_nombre_idx
ON EMPLEADO(apellido_emp, nombre_emp, cod_carg);

CREATE INDEX inventario_info_inv_idx
ON INVENTARIO(fecha_caduc, cod_est);

CREATE INDEX proveedor_nom_empresa_idx
ON PROVEEDOR(nom_empresa);

CREATE INDEX producto_info_prod_idx
ON PRODUCTO(nom_prod, cod_categ);

CREATE INDEX factura_venta_info_fvent_idx
ON FACTURA_VENTA(id_emp, id_clie, prec_tot_vent);

--SINONIMOS---------------------------------------------------------------
CREATE PUBLIC SYNONYM compra
FOR detalle_orden;

CREATE PUBLIC SYNONYM venta
FOR detalle_vent;

CREATE PUBLIC SYNONYM sede
FOR punto_venta;

CREATE PUBLIC SYNONYM f_vent
FOR factura_venta;

CREATE PUBLIC SYNONYM p_est
FOR tipo_estado;