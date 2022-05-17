DELIMITER //
DROP TRIGGER IF EXISTS trigDeleteEntrada//
CREATE TRIGGER trigDeleteEntrada
AFTER DELETE
ON entradas FOR EACH ROW
BEGIN
    DECLARE inicio TIMESTAMP(6);
    SET inicio = CURRENT_TIMESTAMP(6);
    INSERT INTO cancelaciones VALUES(old.formaPago,old.horaReserva,old.correoCliente,old.tipoUsuario,old.asientoLocalidad,old.nombreGrada,old.nombreEsp,old.tipoEsp,old.fechaProduccion,old.productora,old.fechaYHora,old.direccion,NOW());
    UPDATE localidades SET estado = "Libre" WHERE asientoLocalidad=old.asientoLocalidad AND nombreGrada = old.nombreGrada 
        AND nombreEsp=old.nombreEsp AND tipoEsp=old.tipoEsp AND fechaProduccion=old.fechaProduccion 
        AND productora=old.productora AND fechaYHora=old.fechaYHora AND direccion=old.direccion;
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
END//
