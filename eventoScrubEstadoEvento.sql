SET GLOBAL event_scheduler = ON;
#SET GLOBAL event_scheduler = OFF;
USE proyecto;
DROP EVENT IF EXISTS ScrubEventos;

CREATE EVENT ScrubEventos
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
ON COMPLETION PRESERVE
DO
    UPDATE eventos SET estado='Finalizado' WHERE fechaYHora=Now();
    #NO SE PODRA REALIZAR UNA RESERVA(CERRADO) SI FALTAN MENOS DE T2 MINUTOS PARA EL COMIENZO
    SET @t2 := (SELECT tAntelacionReserva FROM espectaculos WHERE ) 

    UPDATE eventos SET estado='Cerrado' WHERE fechaYHora-t2=(Now());
