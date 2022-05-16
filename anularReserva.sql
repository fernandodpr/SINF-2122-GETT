DELIMITER //
DROP PROCEDURE IF EXISTS anularReserva//

CREATE PROCEDURE anularReserva(
IN idReserva DATETIME, #horaReserva
IN idCliente VARCHAR(20),  #correo del cliente
IN idEspectaculo VARCHAR(20), #nombre del espectaculo
OUT reembolso float
)
BEGIN
DECLARE correoCliente,estado, grada varchar(20);
DECLARE penalizacion,localidad,minutos, tCancelacion int;
DECLARE produccion DATE;
DECLARE comienzoEvento DATETIME;

SELECT entradas.correoCliente, entradas.asientoLocalidad, entradas.fechaProduccion, entradas.nombreGrada, entradas.fechaYHora INTO correoCliente, localidad, produccion, grada, comienzoEvento FROM entradas WHERE entradas.correoCliente = idCliente AND entradas.horaReserva = idReserva AND entradas.nombreEsp = idEspectaculo;
SELECT espectaculos.penalizacion, espectaculos.tCancelacion INTO penalizacion, tCancelacion FROM espectaculos WHERE espectaculos.nombreEsp = idEspectaculo AND espectaculos.fechaProduccion = produccion;
SELECT localidades.estado INTO estado FROM localidades WHERE localidades.asientoLocalidad = localidad AND localidades.nombreGrada = grada AND localidades.nombreEsp = idEspectaculo AND localidades.fechaProduccion = produccion;

IF correoCliente = idCliente then
    IF estado = 'Reservado' then
        SELECT 'NO ENTIENDO NADA';
        IF now() < comienzoEvento then
            SELECT timestampdiff(MINUTE, now(), comienzoEvento) INTO minutos;
            IF minutos < tCancelacion THEN
                DELETE FROM entradas WHERE entradas.correoCliente = idCliente AND entradas.horaReserva = idReserva AND entradas.nombreEsp = idEspectaculo;
                UPDATE localidades SET estado = "Libre" WHERE estado = "Reservado" AND localidades.asientoLocalidad = localidad AND localidades.nombreGrada = grada AND localidades.nombreEsp = idEspectaculo AND localidades.fechaProduccion = produccion;
                SET reembolso = precio - precio*penalizacion/100;
            ELSE
                DELETE FROM entradas WHERE entradas.correoCliente = idCliente AND entradas.horaReserva = idReserva AND entradas.nombreEsp = idEspectaculo;
                UPDATE localidades SET estado = "Libre" WHERE estado = "Reservado" AND localidades.asientoLocalidad = localidad AND localidades.nombreGrada = grada AND localidades.nombreEsp = idEspectaculo AND localidades.fechaProduccion = produccion;
                SET reembolso = precio;
            END IF;
        ELSE
            SELECT 'Ya comenzo el evento. No puede cancelar la reserva';
            SET reembolso = 0;
        END IF;
    ELSE
        SELECT 'Asiento no disponible';
        SET reembolso = 0;
    END IF;
ELSE
    SELECT 'La reserva no se encuentra en la base de datos';
    SET reembolso = 0;
END IF;
END
//
DELIMITER ;
