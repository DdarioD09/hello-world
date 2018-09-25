--Opcional porque es de una vista---------------------------------
CREATE INDEX factura_vu_info_vent_idx
ON FACTURA_VU (cliente, product, vendedor);

--ELIMINADOR DE OTROS OBJETOS-------------------------------------------

--ELIMINADOR DE SYNONYM
DROP PUBLIC SYNONYM compra;
DROP PUBLIC SYNONYM venta;
DROP PUBLIC SYNONYM sede;
DROP PUBLIC SYNONYM f_vent;
DROP PUBLIC SYNONYM p_est;

--ELIMINADOR DE INDEX
DROP INDEX empleado_emp_nombre_idx;
DROP INDEX inventario_info_inv_idx;
DROP INDEX proveedor_nom_empresa_idx;
DROP INDEX producto_info_prod_idx;
DROP INDEX factura_venta_info_fvent_idx;

--ELIMINADOR DE SEQUENCE
DROP SEQUENCE cargo_cod_carg;
DROP SEQUENCE punto_venta_cod_pventa;
DROP SEQUENCE empleado_id_emp;
DROP SEQUENCE cliente_id_clie;
DROP SEQUENCE proveedor_id_prov;
DROP SEQUENCE med_pago_cod_mpago;
DROP SEQUENCE orden_com_cod_orden;
DROP SEQUENCE detalle_orden_cod_barras;
DROP SEQUENCE catgoria_prod_cod_categ;
DROP SEQUENCE producto_cod_prod;
DROP SEQUENCE tipo_estado_cod_est;
DROP SEQUENCE factura_venta_cod_fac_vent;