
USE proyecto;
DELIMITER //

DROP PROCEDURE IF EXISTS nuevoEvento;

CREATE PROCEDURE nuevoEvento(
	IN espectaculo VARCHAR(20),
	IN TipoEspec VARCHAR(20),
	IN FechaProduc DATE,
	IN productorain VARCHAR(20),
	IN horario VARCHAR(20),
	IN Recinto VARCHAR(50)
)
BEGIN
	
	IF ((SELECT COUNT(*) FROM horarios WHERE fechaYHora=horario) < 1) THEN
        SELECT 'No se ha encotrado un horario con estos datos. Creado uno nuevo.';
		INSERT INTO horarios VALUES (horario);	
    END IF;
	
	IF ((SELECT COUNT(*) FROM recintos WHERE direccion=Recinto) < 1) THEN
        SELECT 'No se ha encotrado un recinto.';
		INSERT INTO recintos (direccion) VALUES (Recinto);	
	END IF;

	IF ((SELECT COUNT(*) FROM horariosRecintos WHERE direccion=Recinto AND fechaYHora=horario) < 1) THEN
        SELECT 'No se ha encotrado la tupla horario-recinto';
		INSERT INTO horariosRecintos VALUES (horario, Recinto);	
	END IF;


	IF ((SELECT COUNT(*) FROM espectaculos WHERE nombreEsp=espectaculo AND tipoEsp=TipoEspec AND fechaProduccion=FechaProduc AND productora=productorain) < 1) THEN
        SELECT 'No se ha encotrado este espectaculo, creando uno nuevo.';
		CALL crearEspectaculo(espectaculo,TipoEspec,FechaProduc,productorain, NULL, 0,0,0,0);	
    END IF;

	INSERT IGNORE INTO eventos VALUES (espectaculo, TipoEspec, FechaProduc, productorain, horario, Recinto);
	
END //

DELIMITER ;