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

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    SELECT nombreEsp, tipoEsp, direccion, fechaYHora FROM eventos WHERE tipoEsp=tipo;
    
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
    
END
//


DROP PROCEDURE IF EXISTS listarEventosPorTipo//
CREATE PROCEDURE listarEventosPorTipo()
BEGIN 

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    SELECT tipoEsp, nombreEsp, direccion, fechaYHora FROM eventos ORDER BY tipoEsp;
  
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
END
//


DROP PROCEDURE IF EXISTS listarEventosDisponibles//
CREATE PROCEDURE listarEventosDisponibles()
BEGIN 

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    DROP VIEW IF EXISTS eventosView;
    CREATE VIEW eventosView AS SELECT tipoEsp, nombreEsp, direccion, fechaYHora 
    FROM eventos
    WHERE fechaYHora > now()
    ORDER BY tipoEsp;

    SELECT * FROM eventosView;
    
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
    
END//

DROP PROCEDURE IF EXISTS modificarEspectaculo//
CREATE PROCEDURE modificarEspectaculo(
    IN INnombreEsp VARCHAR(30),
    IN INtipoEsp varchar(30),
    IN INfechaProduccion DATE,
    IN INproductora VARCHAR(30) ,
    IN INpenalizacion INT,
    IN t1 TIME,
    IN t2 TIME,
    IN t3 TIME
)
BEGIN 

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    #SET @espectaculo = (SELECT * FROM espectaculos WHERE nombreEsp=INnombreEsp AND tipoEsp=INtipoEsp AND fechaProduccion=INfechaProduccion AND productora=INproductora);

    IF (penalizacion IS NOT NULL) THEN
        UPDATE espectaculos SET penalizacion = INpenalizacion
        WHERE nombreEsp=nombreEsp AND tipoEsp=tipoEsp AND fechaProduccion=fechaProduccion AND productora=productora;
    END IF;

    IF (t1 IS NOT NULL) THEN
        UPDATE espectaculos SET tValidezReserva = t1 
        WHERE nombreEsp=nombreEsp AND tipoEsp=tipoEsp AND fechaProduccion=fechaProduccion AND productora=productora;
    END IF;

    IF (t2 IS NOT NULL) THEN
        UPDATE espectaculos SET tAntelacionReserva = t2
        WHERE nombreEsp=nombreEsp AND tipoEsp=tipoEsp AND fechaProduccion=fechaProduccion AND productora=productora;
    END IF;

    IF (t3 IS NOT NULL) THEN
        UPDATE espectaculos SET tCancelacion = t3
        WHERE nombreEsp=nombreEsp AND tipoEsp=tipoEsp AND fechaProduccion=fechaProduccion AND productora=productora;
    END IF;
    
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
    
END//

DELIMITER ;

