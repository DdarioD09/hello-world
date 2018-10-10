--VISTAS MATERIALIZADAS el script se llama (view) (view dropper)

--SECCIÓN DE ANÁLISIS  ENTRE RELACIÓN DE EMPLEADO CLIENTE------------------------------------------------------------

En la empresa nos gustaría saber la opinión de nuestros clientes sobre nuestro personal. Para este caso haríamos una vista donde se representa
la información básica del cliente y del empleado por el cual fue atendido, de esta forma podríamos enviar un mensaje al cliente, de esta forma
él pueda dar una calificación del servicio dado.

create materialized view vm_empleusua
(Nombre, Id, Telefono, Fecha, Empleado)
BUILD IMMEDIATE REFRESH FORCE START
 WITH to_date('11-Feb-2018 11:00:00 PM','dd-Mon-yyyy HH:MI:SS
 AM') NEXT SYSDATE + 1 AS
select c.nombre_clie, c.id_clie, c.tel_clie, f.fecha_vent, e.nombre_emp
from cliente c, factura_venta f, empleado e
where c.id_clie= f.id_clie and e.id_emp = f.id_emp;



--SECCIÓN DE INFORMACIÓN ORDEN DE PEDIDOS CON RESPECTIVOS PROVEEDORES---------------------------------------------------

se necesita saber en qué temporadas la empresa decidió aumentar  a los proveedores de sus pedidos por la falta de los productos ya que los clientes
compraban con mayor frecuencia lo que podría generar una mayor demanda a falta de oferta.

create materialized view vm_ordprove
(Id, Nombre, Codigo_orden, Fecha, Precio)
BUILD IMMEDIATE REFRESH FORCE START
 WITH to_date('11-Feb-2016 01:00:00 AM','dd-Mon-yyyy HH:MI:SS
 AM') NEXT SYSDATE + 7 AS
SELECT p.id_prov, p.nom_empresa, o.cod_orden, o.fecha_orden, o.prec_tot_orden
from proveedor p, orden_com o
where p.id_prov = o.id_prov;



--Gestión producto - cliente------------------------------------------------------------------------------------------
En el tema de gestión del cliente nos gustaría que en nuestra empresa tenga presente cuáles son los gustos de los compradores.
Para ello es importante saber cuáles son los productos que más compran lo cual nos permitirá estar al tanto de cuál es la tendencia
de compra para cada cliente. así le podemos informar cuando haya algún tipo de promoción sobre el producto que más les gusta y poder informarle
vía telefónica por medio de un mensaje y de este modo podríamos crear una fuerte relación entre la empresa y sus consumidores.

create materialized view vm_clieprod
BUILD IMMEDIATE REFRESH FORCE START
 WITH to_date('11-Feb-2016 01:00:00 AM','dd-Mon-yyyy HH:MI:SS
 AM') NEXT SYSDATE + 5 AS
 SELECT
 c.id_clie "Cliente", p.nom_prod "Producto",fv.fecha_vent "Fecha Venta", c.tel_clie  "Telefono"
 FROM producto p, inventario i, detalle_vent dv, factura_venta fv, cliente c, punto_venta pv, clie_punto cp
 WHERE p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent AND 
fv.id_clie = c.id_clie AND cp.id_clie = c.id_clie AND cp.cod_pventa = pv.cod_pventa;



--ANALISIS DE STOCK---------------------------------------------------------------------------------------------

ANÁLISIS DE STOCK
Se desea ver qué productos y que cantidad se deben tener en bodega para las temporadas navideñas, de manera que se tenga la cantidad de productos más adecuada.
Para ello se hará una consulta que muestre el código de barras, nombre y fecha de venta de los productos que fueron comprados, esto con el fin
de ver en qué temporadas y que tanta cantidad de stocks son los que deberían estar listos en bodega para ser vendidos de manera óptima.

CREATE MATERIALIZED VIEW vm_analisis_stock
BUILD IMMEDIATE
REFRESH START WITH ROUND(SYSDATE) + 23/24 NEXT SYSDATE + 1
AS SELECT
p.nom_prod "Producto", dv.cod_barras "Codigo barras", fv.fecha_vent "Fecha venta", pv.nombre_pventa "Punto venta"
FROM
producto p, inventario i, detalle_vent dv, factura_venta fv, empleado e, punto_venta pv
WHERE
p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent
AND fv.id_emp = e.id_emp AND e.cod_pventa = pv.cod_pventa;

--FIDELIZACION DE CLIENTES----------------------------------------------------------------------------------------

FIDELIZACIÓN DE CLIENTES SEGÚN PUNTOS DE VENTA
Decidir si es posible establecer ciertos beneficios de descuentos en nuestros productos que refuercen la fidelización de clientes, basados
en la frecuencia de compras que estos tienen en nuestros supermercados.
Para ello se va a realizar una consulta de los datos de los compradores, en qué puntos de venta realizaron su compra y que productos llevaron,
y así determinar en cuales de nuestros locales se podría realizar la implementación de los beneficios y qué productos serían los ofertados.

CREATE MATERIALIZED VIEW vm_fideliza_cliente
REFRESH START WITH ROUND(SYSDATE) + 24/24 NEXT SYSDATE + 1
AS SELECT
fv.fecha_vent "Fecha compra", dv.cod_barras "Codigo barras", p.nom_prod "Producto",
c.nombre_clie || ' ' || c.apellido_clie AS "Cliente", c.dir_clie "Dirección cliente",
pv.nombre_pventa "Punto venta", pv.dir_pventa "Dirección pventa"
FROM
cliente c, punto_venta pv, factura_venta fv, clie_punto cp, detalle_vent dv, producto p, inventario i
WHERE
p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent AND
c.id_clie = cp.id_clie AND pv.cod_pventa = cp.cod_pventa AND c.id_clie = fv.id_clie;



--SELECCIÓN DEL NÚMERO ÓPTIMO DE EMPLEADOS------------------------------------------------------------------------------

Determinar cuándo se podrían empezar a hacer contrataciones por temporada para el cargo de ventas, y aproximadamente cuántos empleados
serían necesarios para cumplir con la operación del supermercado. Se hará un filtro por el cargo del empleado y se mostrarán las fechas
de venta de los productos, lo cuales darán información de cuando se genera un incremento en la venta de productos en sus respectivos puntos de venta.

--semanal
CREATE MATERIALIZED VIEW vm_ventas_punto
BUILD DEFERRED
REFRESH START WITH ROUND(SYSDATE) + 18/24 NEXT TRUNC(NEXT_DAY(SYSDATE - 1,'MI╔RCOLES')) + 23/24
AS SELECT
to_char(fv.fecha_vent,'dd-mm-yyyy HH:MI:SS AM') "Fecha compra", dv.cod_barras "Codigo barras", p.nom_prod "Producto",
pv.nombre_pventa "Punto venta", pv.dir_pventa "Dirección pventa"
FROM
producto p, inventario i, detalle_vent dv, factura_venta fv, empleado e, punto_venta pv
WHERE
p.cod_prod = i.cod_prod AND i.cod_barras = dv.cod_barras AND dv.cod_fac_vent = fv.cod_fac_vent 
AND fv.id_emp = e.id_emp AND e.cod_pventa = pv.cod_pventa;

--COMPROBACION DE FECHA-----------------------------------------------------
--codigo para probar la fecha de actualizacion de la vm_ventas_punto
SELECT TO_CHAR(TRUNC(NEXT_DAY(SYSDATE - 1,'MI╔RCOLES')) + 23/24, 'DD-MM-YY hh24:mi:ss') FROM DUAL;
SELECT TO_CHAR(TRUNC(NEXT_DAY(SYSDATE - 1,'S┴BADO')) + 23/24, 'DD-MM-YY hh24:mi:ss') FROM DUAL;
--PARA CONSULTAR EL DIA DE LA SEMANA (SI SE QUIERE OTRA FECHA DIFERENTE A SYSDATE SE PUEDE HACER LA RESTA DE SYSDATE - 2)
SELECT TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE=SPANISH') FROM dual;


--SELECT SOBRE LAS VISTAS---------------------------------------------------------------------------------------------------------
SELECT * FROM vm_empleusua;
SELECT * FROM vm_ordprove;
SELECT * FROM vm_clieprod;
SELECT * FROM vm_analisis_stock;
SELECT * FROM vm_fideliza_cliente;
SELECT * FROM vm_ventas_punto;

/*ELIMINAR VISTAS MATERIALIZADAS*/-----------------------------------------------------------------------------------------------------
DROP MATERIALIZED VIEW vm_empleusua;
DROP MATERIALIZED VIEW vm_ordprove;
DROP MATERIALIZED VIEW vm_clieprod;
DROP MATERIALIZED VIEW vm_analisis_stock;
DROP MATERIALIZED VIEW vm_fideliza_cliente;
DROP MATERIALIZED VIEW vm_ventas_punto;


--Codigo para comprobar los refresh de las vistas materializadas----------------------------------------------------------------------------
SELECT name, to_char(START_WITH, 'DD-MM-YY hh24:mi:ss'), to_char(LAST_REFRESH, 'DD-MM-YY hh24:mi:ss'), status
FROM user_snapshots;
--revisar where
WHERE name = '&nombre'
--CUAL ES LA DIFERENCIA ENTRE TRUNC Y ROUND