USE proyecto;

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


DROP PROCEDURE IF EXISTS crearEspectaculo//
CREATE PROCEDURE crearEspectaculo(IN nombreEsp VARCHAR(30), IN tipoEsp VARCHAR(30), IN fechaProd DATE, IN productora VARCHAR(30), IN participantes VARCHAR(30), IN penalizacion INT, IN tValidezReserva INT, IN tAntelacionReserva INT, IN tCancelacion INT)
BEGIN 
	INSERT INTO espectaculos VALUES (nombreEsp, tipoEsp, fechaProd, productora, participantes, penalizacion, tValidezReserva, tAntelacionReserva, tCancelacion);
END
//

/** 

DROP PROCEDURE IF EXISTS localidadesDelEventoYGrada// 
CREATE PROCEDURE localidadesDelEventoYGrada(IN nombreGrada VARCHAR(30), IN nombreEsp VARCHAR(30), IN tipoEsp VARCHAR(30), IN fechaProd DATE, IN productora VARCHAR(30), IN fechaYHora DATETIME, IN dirRecinto VARCHAR(50))
BEGIN 
    
END
//**/
