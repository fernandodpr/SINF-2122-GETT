DELIMITER //
DROP PROCEDURE IF EXISTS anularReserva //
CREATE PROCEDURE anularReserva(
IN idEntrada  int,
IN idCliente int,  #id de cliente = correo
IN idEspectaculo int, 
OUT reembolso float 
)
BEGIN
    DECLARE precio, penalizacion int;
    DECLARE comienzo timestamp;
    DECLARE estado, usuario VARCHAR(10);
    DECLARE correoCliente int; #Autentificar el cliente

    SELECT entradas.estado entradas.tipoUsuario, entradas.correoCliente INTO usuario, correoCliente FROM entradas WHERE entradas.horaReserva = idEntrada;
    SELECT espectaculos.penalizacion INTO penalizacion FROM espectaculos WHERE espectaculos.nombreEsp = idEspectaculo;
    SELECT tarifas.precio INTO precio FROM tarifas WHERE tarifas.tipoUsuario = usuario AND tarifas.nombreEsp = idEspectaculo;

    IF idCliente = correoCliente then
      IF (strcmp(estado, 'Reservado') == 0) then
         SELECT * "Reserva encontrada"
END //

DELIMITER;
