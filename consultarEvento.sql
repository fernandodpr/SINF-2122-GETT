DROP PROCEDURE IF EXISTS consultarEvento;

DELIMITER //

CREATE PROCEDURE consultarEvento(
    IN Espectaculo_nombre varchar(20),
    IN Espectaculo_tipo varchar(20),
    IN Espectaculo_fecha_produccion DATE,
    IN Espectaculo_productora varchar(20),
    IN Evento_fecha DATETIME,
    IN Evento_direccion varchar(50),
    IN Grada varchar(20)
)
BEGIN

    SET @eventos:= (SELECT COUNT(*) 
                    FROM localidades
                    WHERE nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo 
                        AND fechaProduccion=Espectaculo_fecha_produccion AND productora=Espectaculo_productora
                        AND fechaYHora = Evento_fecha AND direccion = Evento_direccion);
    
    IF (@eventos = 0) THEN
    
        SELECT 'El evento seleccionado no esta disponible';
    
    ELSE
    
        SET @grada:= (SELECT COUNT(*) 
                      FROM localidades
                      WHERE nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo 
                          AND fechaProduccion=Espectaculo_fecha_produccion AND productora=Espectaculo_productora 
                          AND fechaYHora=Evento_fecha AND direccion=Evento_direccion
                          AND nombreGrada = Grada);
            
        IF (@grada = 0) THEN
        
            SELECT 'La grada seleccionada no esta disponible';
        
        ELSE
        
            SET @localidades:= (SELECT COUNT(*) 
                                FROM localidades
                                WHERE nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo 
                                    AND fechaProduccion=Espectaculo_fecha_produccion AND productora=Espectaculo_productora 
                                    AND fechaYHora=Evento_fecha AND direccion=Evento_direccion
                                    AND estado = 'Libre');
                                    
            IF (@localidades = 0) THEN
            
                SELECT 'La grada seleccionada no dispone de localidades libres para este evento';
            
            END IF;
            
            SELECT asientoLocalidad AS Localidad, estado AS Estado, nombreGrada AS Grada, nombreEsp AS Espectaculo, tipoEsp AS Tipo, fechaProduccion AS Produccion, 
            fechaYHora as Horario, direccion AS Direccion_recinto
            FROM localidades 
            WHERE nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo 
                AND fechaProduccion=Espectaculo_fecha_produccion AND productora=Espectaculo_productora 
                AND fechaYHora=Evento_fecha AND direccion=Evento_direccion
                AND nombreGrada = Grada;
        
        END IF;
            
        
    
    END IF;
    
END//

DELIMITER ;
