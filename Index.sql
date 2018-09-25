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