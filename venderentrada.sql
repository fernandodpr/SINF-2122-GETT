USE proyecto;

DELIMITER //
DROP PROCEDURE IF EXISTS venderentrada//
CREATE PROCEDURE venderentrada(
   
    IN Espectador_tipo varchar(10),
    IN Asiento INT,
    IN Grada_nombre VARCHAR(20),
    IN Espectaculo_nombre VARCHAR(20),
    IN Espectaculo_tipo VARCHAR(20),
    IN Espectaculo_fecha DATE,
    IN Espectaculo_productora VARCHAR(20),
    IN Evento_fecha VARCHAR(20),
    IN Evento_direccion varchar(50)

)
BEGIN
 ###### Primero comprobamos si esa entrada ya existe
 ###### Existe este evento?
 ###### Existe esta grada?
 ###### Se puede reservar la localidad?
 ###### Realizar reserva
    IF ((SELECT COUNT(*) FROM horariosRecintos WHERE direccion=Recinto AND fechaYHora=horario) < 1) THEN
        SELECT 'No se ha encotrado la tupla horario-recinto';
		INSERT INTO horariosRecintos VALUES (horario, Recinto);	
    END IF;
END//
DELIMITER ;