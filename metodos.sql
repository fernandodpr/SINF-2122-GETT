USE proyecto;

\. venderentrada.sql
\. anulaReserva.sql
\. consultarEvento.sql
\. crearEspectaculo.sql
\. eventoScrubEstadoEvento.sql
\. eventoScrubEstadoPreReserva.sql
\. localidadDeteriorada.sql
\. newEvent.sql
\. realizarReserva.sql
\. tarifas.sql
\. trigDeleteEntrada.sql

DELIMITER //
DROP PROCEDURE IF EXISTS buscarEventosPorTipo//
CREATE PROCEDURE buscarEventosPorTipo(IN tipo VARCHAR(30))
BEGIN 
    SELECT nombreEsp, tipoEsp, direccion, fechaYHora FROM eventos WHERE tipoEsp=tipo;
END
//


DROP PROCEDURE IF EXISTS listarEventosPorTipo//
CREATE PROCEDURE listarEventosPorTipo()
BEGIN 
    SELECT tipoEsp, nombreEsp, direccion, fechaYHora FROM eventos ORDER BY tipoEsp;
END
//


DROP PROCEDURE IF EXISTS listarEventosDisponibles//
CREATE PROCEDURE listarEventosDisponibles()
BEGIN 
    DROP VIEW IF EXISTS eventosView;
    CREATE VIEW eventosView AS SELECT tipoEsp, nombreEsp, direccion, fechaYHora 
    FROM eventos
    WHERE fechaYHora > now()
    ORDER BY tipoEsp;

    SELECT * FROM eventosView;
END
//



