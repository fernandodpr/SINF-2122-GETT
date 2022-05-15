USE proyecto;

DELIMITER //
DROP PROCEDURE IF EXISTS buscarEventosPorTipo//
CREATE PROCEDURE buscarEventosPorTipo(IN tipo VARCHAR(20))
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
    CREATE VIEW eventosView AS SELECT tipoEsp, nombreEsp, direccion, fechaYHora 
    FROM eventos
    WHERE fechaYHora > now()
    ORDER BY tipoEsp;

    SELECT * FROM eventosView;
END
