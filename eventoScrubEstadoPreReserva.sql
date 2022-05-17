DELIMITER //
SET GLOBAL event_scheduler = ON//
#SET GLOBAL event_scheduler = OFF//
USE proyecto//
DROP EVENT IF EXISTS ScrubReservas//

CREATE EVENT ScrubReservas
  ON SCHEDULE EVERY 1 MINUTE STARTS NOW()
  ON COMPLETION PRESERVE
DO
BEGIN
  DELETE entradas FROM entradas INNER JOIN espectaculos ON entradas.nombreEsp=espectaculos.nombreEsp 
    AND entradas.tipoEsp=espectaculos.tipoEsp AND entradas.productora=espectaculos.productora 
    AND entradas.fechaProduccion=espectaculos.fechaProduccion   
    WHERE TIMEDIFF(NOW(),entradas.horaReserva) > espectaculos.tValidezReserva  AND entradas.formaPago='Prereserva' ;

    

END //
DELIMITER ;