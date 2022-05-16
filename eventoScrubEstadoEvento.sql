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
    SELECT espectaculos.nombreEsp,eventos.tipoEsp ,tValidezReserva, tAntelacionReserva, tCancelacion  
                FROM eventos INNER JOIN espectaculos ON eventos.nombreEsp=espectaculos.nombreEsp 
                AND eventos.tipoEsp=espectaculos.tipoEsp AND eventos.productora=espectaculos.productora 
                AND eventos.fechaProduccion=espectaculos.fechaProduccion;

    UPDATE eventos,espectaculos SET eventos.estado='Cerrado' WHERE SUBTIME( LastModifiedDate, MINUTOS(pero tienen que estar en TIME)) )=Now();
