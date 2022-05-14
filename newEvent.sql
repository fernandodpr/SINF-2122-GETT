
USE proyecto;
DELIMITER //

DROP PROCEDURE IF EXISTS novoEvento;

CREATE PROCEDURE novoEvento(
	IN espectaculo VARCHAR(20),
	IN TipoEspec VARCHAR(20),
	IN FechaProduc VARCHAR(20),
	IN productorain VARCHAR(20),
	IN DateTime VARCHAR(20),
	IN Recinto VARCHAR(50)
)
BEGIN
	
	IF ((SELECT COUNT(*) FROM espectaculos WHERE nombreEsp=espectaculo AND tipoEsp=TipoEspec AND fechaProduccion=FechaProduc AND productora=productorain ) < 1) THEN
        	SELECT 'No se ha encotrado este espectaculo, creando uno nuevo. INCOMPLETO';
		# CALL crearEspectaculo(espectaculo,TipoEspec,FechaProduc,productorain);	
    	END IF;
	IF ((SELECT COUNT(*) FROM horarios WHERE fechaYHora=DateTime) < 1) THEN
        	SELECT 'No se ha encotrado un horario con estos datos. Creado. INCOMPLETO';
		INSERT INTO horarios VALUES (DateTime);
		
    	END IF;
	IF ((SELECT COUNT(*) FROM recintos WHERE direccion=Recinto) < 1) THEN
        	SELECT 'No se ha encotrado un recinto. Añadalo usando el metodo addVenue. INCOMPLETO';
    	END IF;

	


END //

DELIMITER ;