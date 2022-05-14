DELIMITER //
DROP PROCEDURE IF EXISTS anularReserva //
CREATE PROCEDURE anularReserva(
IN idEntrada  int,
IN idCliente int,
IN idEspectaculo int, 
OUT reembolso float 
)
BEGIN
    DECLARE penalizacion int;
    DECLARE comienzo timestamp;
    DECLARE usuario VARCHAR(10);

    SELECT entradas.tipoUsuario INTO usuario FROM entradas WHERE entradas.horaReserva = idEntrada;
    SELECT espectaculos.penalizacion INTO penalizacion
    
END
