
DELIMITER //
DROP PROCEDURE IF EXISTS crearEspectaculo//
CREATE PROCEDURE crearEspectaculo(IN nombreEsp VARCHAR(20), IN tipoEsp VARCHAR(20), IN fechaProd DATE, IN productora VARCHAR(20), IN participantes VARCHAR(30), IN penalizacion INT, IN tValidezReserva TIME, IN tAntelacionReserva TIME, IN tCancelacion TIME)
BEGIN 
        DECLARE inicio TIMESTAMP(6);
        SET inicio = CURRENT_TIMESTAMP(6);
	INSERT INTO espectaculos VALUES (nombreEsp, tipoEsp, fechaProd, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion);
        SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
END//

DELIMITER ;
