DELIMITER //
SET GLOBAL event_scheduler = ON//
#SET GLOBAL event_scheduler = OFF//
USE proyecto//
DROP EVENT IF EXISTS ScrubEventos//

CREATE EVENT ScrubEventos
  ON SCHEDULE EVERY 1 MINUTE STARTS NOW()
  ON COMPLETION PRESERVE
DO
BEGIN
    
    UPDATE eventos INNER JOIN espectaculos ON eventos.nombreEsp=espectaculos.nombreEsp AND eventos.tipoEsp=espectaculos.tipoEsp 
        AND eventos.productora=espectaculos.productora AND eventos.fechaProduccion=espectaculos.fechaProduccion
    SET eventos.estado='Cerrado'  
    WHERE SUBTIME(eventos.fechaYHora,espectaculos.tAntelacionReserva)<NOW();

    UPDATE eventos SET eventos.estado='Finalizado' WHERE eventos.fechaYHora<NOW();
END //

delimiter ;

