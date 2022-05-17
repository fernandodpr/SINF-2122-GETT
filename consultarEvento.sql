DROP PROCEDURE IF EXISTS consultarEvento;

DELIMITER //

CREATE PROCEDURE consultarEvento(
    IN Evento_fecha DATETIME,
    IN Evento_direccion varchar(50),
    IN Grada varchar(20)
)
BEGIN

    DECLARE inicio TIMESTAMP(6);
    
    SET inicio = CURRENT_TIMESTAMP(6);

    SET @eventos:= (SELECT COUNT(*) 
                    FROM localidades
                    WHERE fechaYHora = Evento_fecha AND direccion = Evento_direccion);
    
    IF (@eventos = 0) THEN
    
        SELECT 'El evento seleccionado no esta disponible' AS 'Error en la consulta';
    
    ELSE
    
        SET @grada:= (SELECT COUNT(*) 
                      FROM localidades
                      WHERE fechaYHora=Evento_fecha AND direccion=Evento_direccion
                          AND nombreGrada = Grada);
            
        IF (@grada = 0) THEN
        
            SELECT 'La grada seleccionada no esta disponible' AS 'Error en la consulta';
        
        ELSE
        
            SET @localidades:= (SELECT COUNT(*) 
                                FROM localidades
                                WHERE fechaYHora=Evento_fecha AND direccion=Evento_direccion
                                    AND nombreGrada = Grada AND estado = 'Libre');
                                    
            IF (@localidades = 0) THEN
            
                SELECT 'La grada seleccionada no dispone de localidades libres para este evento' AS 'Error en la consulta';
            
            END IF;
            
            
            SELECT Grada, nombreEsp AS Espectaculo, tipoEsp AS Tipo, fechaProd AS Produccion, 
            Evento_fecha as Horario, Evento_direccion AS Direccion_recinto
            FROM eventos
            WHERE fechaYHora=Evento_fecha AND direccion=Evento_direccion;
            
            SELECT precio AS Precio, tipoUsuario AS Usuario 
            FROM tarifas 
            WHERE fechaYHora=Evento_fecha AND direccion=Evento_direccion
                AND nombreGrada = Grada;
                
                
            SELECT asientoLocalidad AS Localidad, estado AS Estado
            FROM localidades
            WHERE fechaYHora=Evento_fecha AND direccion=Evento_direccion
                AND nombreGrada = Grada;
                    
        END IF;
            
        
    
    END IF;
    
    SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
    
END//

DELIMITER ;

