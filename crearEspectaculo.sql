
DELIMITER //
DROP PROCEDURE IF EXISTS crearEspectaculo//
CREATE PROCEDURE crearEspectaculo(IN nombreEsp VARCHAR(20), IN tipoEsp VARCHAR(20), IN fechaProd DATE, IN productora VARCHAR(20), IN participantes VARCHAR(30), IN penalizacion INT, IN tValidezReserva TIME, IN tAntelacionReserva TIME, IN tCancelacion TIME)
BEGIN 

	INSERT INTO espectaculos VALUES (nombreEsp, tipoEsp, fechaProd, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion);
END//

DELIMITER ;
