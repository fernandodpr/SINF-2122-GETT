USE proyecto;

\. venderentrada.sql
\. anulaReserva.sql
\. consultarEvento.sql
\. crearEspectaculo.sql
\. eventoScrubEstadoEvento.sql
\. eventoScrubEstadoPreReserva.sql
\. localidadDeteriorada.sql
\. newEvent.sql

\. tarifas.sql
\. trigDeleteEntrada.sql

DELIMITER //
DROP PROCEDURE IF EXISTS buscarEventosPorTipo//
CREATE PROCEDURE buscarEventosPorTipo(IN tipo VARCHAR(30))
BEGIN 
<<<<<<< HEAD
    DECLARE inicio TIMESTAMP(6);
    SET inicio = CURRENT_TIMESTAMP(6);
    SELECT nombreEsp, tipoEsp, direccion, fechaYHora FROM eventos WHERE tipoEsp=tipo;
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
=======

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    SELECT nombreEsp, tipoEsp, direccion, fechaYHora FROM eventos WHERE tipoEsp=tipo;
    
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
    
>>>>>>> e0c54948c515f8297b69345eb75bb0e76709ab8d
END
//


DROP PROCEDURE IF EXISTS listarEventosPorTipo//
CREATE PROCEDURE listarEventosPorTipo()
BEGIN 
<<<<<<< HEAD
    DECLARE inicio TIMESTAMP(6);
    SET inicio = CURRENT_TIMESTAMP(6);
    SELECT tipoEsp, nombreEsp, direccion, fechaYHora FROM eventos ORDER BY tipoEsp;
=======

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    SELECT tipoEsp, nombreEsp, direccion, fechaYHora FROM eventos ORDER BY tipoEsp;
  
>>>>>>> e0c54948c515f8297b69345eb75bb0e76709ab8d
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
END
//


DROP PROCEDURE IF EXISTS listarEventosDisponibles//
CREATE PROCEDURE listarEventosDisponibles()
BEGIN 
<<<<<<< HEAD
    DECLARE inicio TIMESTAMP(6);
    SET inicio = CURRENT_TIMESTAMP(6);
=======

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

>>>>>>> e0c54948c515f8297b69345eb75bb0e76709ab8d
    DROP VIEW IF EXISTS eventosView;
    CREATE VIEW eventosView AS SELECT tipoEsp, nombreEsp, direccion, fechaYHora 
    FROM eventos
    WHERE fechaYHora > now()
    ORDER BY tipoEsp;

    SELECT * FROM eventosView;
<<<<<<< HEAD
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';

END
//

=======
    
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
    
END//
>>>>>>> e0c54948c515f8297b69345eb75bb0e76709ab8d

DROP PROCEDURE IF EXISTS modificarEspectaculo//
CREATE PROCEDURE modificarEspectaculo(
    IN INnombreEsp VARCHAR(30),
    IN INtipoEsp varchar(30),
    IN INfechaProduccion DATE,
    IN INproductora VARCHAR(30),
    IN INpenalizacion INT,
    IN t1 TIME,
    IN t2 TIME,
    IN t3 TIME
)
BEGIN 
    DECLARE inicio TIMESTAMP(6);
    SET inicio = CURRENT_TIMESTAMP(6);
    #SET @espectaculo = (SELECT * FROM espectaculos WHERE nombreEsp=INnombreEsp AND tipoEsp=INtipoEsp AND fechaProduccion=INfechaProduccion AND productora=INproductora);

    IF (INpenalizacion IS NOT NULL) THEN
        UPDATE espectaculos SET penalizacion = INpenalizacion
        WHERE nombreEsp=INnombreEsp AND tipoEsp=INtipoEsp AND fechaProduccion=INfechaProduccion AND productora=INproductora;
    END IF;

    IF (t1 IS NOT NULL) THEN
        UPDATE espectaculos SET tValidezReserva = t1 
        WHERE nombreEsp=INnombreEsp AND tipoEsp=INtipoEsp AND fechaProduccion=INfechaProduccion AND productora=INproductora;
    END IF;

    IF (t2 IS NOT NULL) THEN
        UPDATE espectaculos SET tAntelacionReserva = t2
        WHERE nombreEsp=INnombreEsp AND tipoEsp=INtipoEsp AND fechaProduccion=INfechaProduccion AND productora=INproductora;
    END IF;

    IF (t3 IS NOT NULL) THEN
        UPDATE espectaculos SET tCancelacion = t3
        WHERE nombreEsp=INnombreEsp AND tipoEsp=INtipoEsp AND fechaProduccion=INfechaProduccion AND productora=INproductora;
    END IF;
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';

END
//


DROP PROCEDURE IF EXISTS insertGrada//
CREATE PROCEDURE insertGrada(
    IN Grada_nombre VARCHAR(30),
    IN Espectaculo_nombre VARCHAR(30),
    IN Espectaculo_tipo VARCHAR(30),
    IN Espectaculo_fecha DATE,
    IN Espectaculo_productora VARCHAR(30),
    IN Evento_fecha VARCHAR(30),
    IN Evento_direccion varchar(50),
)
BEGIN 
    DECLARE inicio TIMESTAMP(6);
    SET inicio = CURRENT_TIMESTAMP(6);
    
    INSERT IGNORE INTO gradas VALUES (Grada_nombre, Espectaculo_nombre, Espectaculo_tipo, Espectaculo_fecha, Espectaculo_productora, Evento_fecha, Evento_direccion);

    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';

END
//



DELIMITER ;

