DELIMITER //
DROP PROCEDURE IF EXISTS anularReserva//

CREATE PROCEDURE anularReserva(
IN idReserva DATETIME, #horaReserva
IN idCliente VARCHAR(20),  #correo del cliente
IN idEspectaculo VARCHAR(20) #nombre del espectaculo
)
BEGIN
DECLARE correoCliente,estado, grada varchar(20);
DECLARE penalizacion, localidad int;
DECLARE produccion DATE;

SELECT entradas.correoCliente, entradas.asientoLocalidad, entradas.fechaProduccion, entradas.nombreGrada INTO correoCliente, localidad, produccion, grada FROM entradas WHERE entradas.correoCliente = idCliente AND entradas.horaReserva = idReserva AND entradas.nombreEsp = idEspectaculo;
SELECT espectaculos.penalizacion INTO penalizacion FROM espectaculos WHERE espectaculos.nombreEsp = idEspectaculo AND espectaculos.fechaProduccion = produccion;
SELECT localidades.estado INTO estado FROM localidades WHERE localidades.asientoLocalidad = localidad AND localidades.nombreGrada = grada AND localidades.nombreEsp = idEspectaculo AND localidades.fechaProduccion = produccion;

IF correoCliente = idCliente then
    IF estado = 'Reservado' then SELECT 'Asiento reservado';
    ELSEIF estado = 'Pre-reservado' then SELECT 'Asiento preReservado';
    ELSE SELECT 'Asiento no disponible';
    END IF;
ELSE
SELECT '>La reserva no se encuentra en la base de datos';
END IF;
END
//

DELIMITER ;
