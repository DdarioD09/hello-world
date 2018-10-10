1. ANALISIS DE STOCK
Se desea ver que productos y que cantidad se deben tener en bodega en cada punto para las temporadas navideñas, de manera que se tenga la cantidad de productos mas adecuada,
esto quiere decir que se disminuya la cantidad de productos que son ofertados en los meses siguientes porque quedaron en bodega.

--Presente año y dos anteriores
--fecha de noviembre y diciembre
# VER SI SE PUEDEN SOLAMETE EXTRAER LAS FECHAS DE NOVIEMBRE Y DICIEMBRE DE TODOS LOS AÑOS POR MEDIO DE GROUP BY
# BUSCAR como consultar las fechas por un filtro de solo un mes (ejemplo todos los diciembres).

--ver como vinculara la fecha de venta con el estado del producto
codigo de barras
nombre del producto (PRODUCTO)
fecha_venta
punto_venta

stocks de este prod vendidos (DETALLE VENTA) order_by count --Codigo de barras
stocks de este producto en bodega (DETALLE COMPRA)


#CONSULTA--------------------------------------------------
SELECT
p.nom_prod "Producto", dv.cod_barras "Codigo de barras",  fv.fecha_vent "Fecha Venta", pv.nombre_pventa "Punto venta"
FROM
producto p, inventario i, detalle_vent dv, factura_venta fv, empleado e, punto_venta pv
WHERE
p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent AND fv.id_emp = e.id_emp AND e.cod_pventa = pv.cod_pventa;


--La que fue para el proyecto--primera version prototipo
SELECT
fv.fecha_vent "Fecha", p.nom_prod "Producto"
FROM
factura_venta fv, detalle_vent dv, inventario i, producto p
WHERE
fv.cod_fac_vent = dv.cod_fac_vent AND dv.cod_barras = i.cod_barras AND p.cod_prod = i.cod_prod AND
fv.fecha_vent BETWEEN '01/11/2017' AND '31/12/2017';

---------------------------------------------------------------------------------------------------

2. FIDELIZACIÓN DE CLIENTES
Decidir si es posible establecer ciertos beneficios de descuentos en nuestros productos que refuercen la fidelización de clientes, basados
en la frecuencia de compras que estos tienen en nuestros supermercados.
Para ello se va a realizar una consulta de los datos de los compradores, en que puntos de venta realizaron su compra y que productos llevaron,
para determinar en cuales de nuestros locales se podria realizar la implementación de los beneficios y que productos serían los ofertados. 

--Presente mes y dos anteriores
-- El cliente haya comoprado mas de 3 veces																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																					
--Como saber cuantos clientes por semana compraron
id

nombre y apellido
-- genero
ubicacion geo
punto_venta
producto
fecha compra
dir punto_venta

#CONSULTA--------------------------------------------------
--termina ¿r las conexiones
SELECT
fv.fecha_vent "Fecha compra", dv.cod_barras "Codigo barras", p.nom_prod "producto",
c.nombre_clie || ' ' || c.apellido_clie AS "Cliente", c.dir_clie "Dirección cliente",
pv.nombre_pventa "Punto venta", pv.dir_pventa "Dirección pventa"
FROM
cliente c, punto_venta pv, factura_venta fv, clie_punto cp, detalle_vent dv, producto p, inventario i
WHERE
p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent AND
c.id_clie = cp.id_clie AND pv.cod_pventa = cp.cod_pventa AND c.id_clie = fv.id_clie;
---------------------------------------------------------------------------------------------------

3. SELECCION DEL NUMERO OPTIMO DE EMPLEADOS
Determinar el número de vendedores por temporada para saber en que fechas se podrían hacer jornadas de contratación de empleados en este cargo,
y aproximadamente cuantos serían necesarios para cumplir con la operación del supermercado. Se hará un filtro por el cargo del empleado y se mostraran las fechas
de ingreso y retiro, si es el caso, del periodo en cual el empleado hizo parte de la empresa y el nombre del punto de venta en el que desempeño labores.

empleado nombre y apellido
fecha ingreso
fecha salida
punto_venta

--fecha de ingreso fecha de salida

/* 3. Determinar el número de vendedores mínimo por temporada (anual) necesario para cumplir con la operación del supermercado. Se hará un fitlro por el cargo
del empleado y se establecera un rango de 2 años que muestre la fecha de en que se efectuo la ventaa, el nombre del empleado y nombre del punto de venta en
dicho rango temporal. */
 

 --revisar la redaccion para incluir las horas exactas
 --archivo start view

Presente año y anterior
id
cargo
fecha (meses)
numero de ventas
nombre punto de venta
numero de empleados ventas
--AGREGAR HORAS para saber el hoario de los trabajadores (turnos) y que tantos trabajadores deberian haber por turno segun esto y la temporada
fecha venta (incluyendo horas y segundos)
stock especifico vendido
producto (nombre)
punto de venta
empleado (para filtro vendedores)
cargo
--agreagar horas minutos y segundos a las fechas de compras---------------------------------
SELECT
to_date(fv.fecha_vent,'dd-mm-yyyy HH:MI:SS') "Fecha compra", dv.cod_barras "Codigo barras", p.nom_prod "producto",
pv.nombre_pventa "Punto venta", pv.dir_pventa "Dirección pventa"
FROM
producto p, inventario i, detalle_vent dv, factura_venta fv, empleado e, punto_venta pv
WHERE
p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent 
AND fv.id_emp = e.id_emp AND e.cod_pventa = pv.cod_pventa;
--creo que la fecha de ingreso del empleado no es muy necesaria para esta consulta
--Solo se desea ver los empleados que estan trabajando actualmente
--entonces se deberia hacer un filtro que compare fechas de salida y la fecha actual?
#CONSULTA--------------------------------------------------

SELECT
e.fecha_ingreso "Fecha ingreso", e.fecha_salida "Fecha salida", e.nombre_emp || ' ' || e.apellido_emp AS "Vendedor",
pv.nombre_pventa "Punto de Venta", 
FROM
empleado e, punto_venta pv, cargo cr
WHERE
pv.cod_pventa = e.cod_pventa AND e.id_emp = fv.id_emp AND cr.cod_carg = e.cod_carg
AND cr.cod_carg = 10;

SELECT
fv.fecha_vent "Fecha venta", e.nombre_emp || ' ' || e.apellido_emp AS "Vendedor",
pv.nombre_pventa "Punto de Venta", e.fecha_ingreso "Fecha ingreso", e.fecha_salida "Fecha salida"
FROM
factura_venta fv, empleado e, punto_venta pv, cargo cr
WHERE
pv.cod_pventa = e.cod_pventa AND e.id_emp = fv.id_emp AND cr.cod_carg = e.cod_carg
AND cr.cod_carg = 10;



--QUERYS DE PRUEBA------------------------------------------------------------------------------------------------------------------

SELECT MONTH('01/01/2018')
FROM orden_com;

SELECT *
FROM orden_com
WHERE fecha_orden BETWEEN '01/01/2018' AND '06/04/2018';


select table_name,
CASE owner
  WHEN 'SYS' THEN 'The owner is SYS'
  WHEN 'SYSTEM' THEN 'The owner is SYSTEM'
  ELSE 'The owner is another value'
END
from all_tables;

SELECT MONTH(fecha_orden)
FROM orden_com;

select to_char(fecha_orden,'month') from orden_com;

/*PRECIOS DE PROVEEDOR DE LOS PRODUCTOS:
PRODUCTOS Y PRECIOS:
INSERT INTO PRODUCTO VALUES
(16,’PASTA EN CONCHITAS DORIA’,’250G’	1150
SPAGUETTI DORIA 250G			1090
CEREAL ZUCARITAS 420G			8790
FRIJOL ROJO 1K				6750
DURZANOS EN ALMIBAR 822G		6290
MANTEQUILLA CON SAL ALPINA 250G	2590
MARGARINA RAMA 500G			5840
CHOCOLATE SOL 1LB			3250
CAFE INSTANTANEO COLCAFE 170G	7560
AZUCAR BLANCA MANUELITA 1K		2160
ACEITE GIRASOLI 1L			6950
SAL REFISAL 1K				1000
HUEVOS BANDEJA 30UN			8690
LECHE ALQUERIA LARGA VIDA 900ML X 6	13090
ARROZ FLORHULIA 1LB			2390
LENTEJAS 1K				3450
CLOROX FRAGANCIA ORIGINAL 1L	2330
FABULOSO 1L				4150
DETERGENTE FAB 3K			18600
JABON BARRA FAB ORIGINAL		1460
JABON BARRA COCO PROTEX 300G	2290
LIMPIAVIDRIOS EASY OFF 500ML		5290
SABRA PAQUETE X3 BOM BRIL		2790
BRILLAOLLAS SCOTH BRITE 6UN		1850
LAVAPLATOS AXION LIMON 500G		5830
AMBIENTADOR GLADE 360 CM3 LAVANDA	7900
CREMA COLGATE X3 UN MENTA		6400
LISTERINE FRESH BURST 500ML		11280
JABON PROTEX FRESH X3 UN		5310
JABON LIQUIDO PARA MANOS FIAMME	14190
SHAMPOO SAVITAL 350ML			5950
*/