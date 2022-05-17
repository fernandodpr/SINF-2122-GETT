##procedimiento antiguo, unificado todo en venderentrada.sql

DROP PROCEDURE IF EXISTS realizarReserva;
 
DELIMITER //

CREATE PROCEDURE realizarReserva(
    IN Num_localidades INT,
    IN UsuarioReserva varchar(30),
    IN PagadaAlMomento BOOLEAN,
    IN Grada varchar(30),
    IN NomEsp varchar(30),
    IN TipoEsp varchar(30),
    IN ProdEsp varchar(30),
    IN FechaProdEsp DATETIME,
    IN HoraEvento DATETIME,
    IN Direccion varchar(50)

)
 
BEGIN

    DECLARE compra varchar(20);
    DECLARE var_precio_reserva, var_loc_max_reserva INT;

    SET @eventos:= (SELECT COUNT(*) 
                    FROM localidades
                    WHERE nombreEsp=NomEsp AND tipoEsp=TipoEsp 
                        AND fechaProduccion=FechaProdEsp AND productora=ProdEsp
                        AND fechaYHora = HoraEvento AND direccion = Direccion);
    
    IF (@eventos = 0) THEN
    
        SELECT 'El evento seleccionado no esta disponible';
    
    ELSE
    
        SET @grada:= (SELECT COUNT(*) 
                      FROM localidades
                      WHERE nombreEsp=NomEsp AND tipoEsp=TipoEsp 
                        AND fechaProduccion=FechaProdEsp AND productora=ProdEsp
                        AND fechaYHora = HoraEvento AND direccion = Direccion
                        AND nombreGrada = Grada);
            
        IF (@grada = 0) THEN
        
            SELECT 'La grada seleccionada no esta disponible';
        
        ELSE
        
            SET @localidades:= (SELECT COUNT(*) 
                                FROM localidades
                                WHERE nombreEsp=NomEsp AND tipoEsp=TipoEsp 
                                    AND fechaProduccion=FechaProdEsp AND productora=ProdEsp
                                    AND fechaYHora = HoraEvento AND direccion = Direccion
                                    AND nombreGrada = Grada AND estado = 'Libre'); 
                                    
            IF (@localidades = 0) THEN
            
                SELECT 'La grada seleccionada no dispone de localidades libres para este evento';
            
            ELSE
            
                SET @contador_tarifas:= (SELECT COUNT(*) 
                                     FROM tarifas 
                                     WHERE nombreEsp = NomEsp AND tipoEsp = TipoEsp 
                                         AND fechaProduccion = FechaProdEsp AND productora = ProdEsp
                                         AND fechaYHora = HoraEvento AND direccion = Direccion
                                         AND tipoUsuario = UsuarioReserva);
                                        
                IF (@contador_tarifas = 0) THEN
                
                    SELECT 'El evento no dispone de una tarifa especial para ese usuario';
                    
                ELSE
                
                    SELECT precio, maxLocalidadesReserva
                    FROM tarifas 
                    WHERE nombreEsp = NomEsp AND tipoEsp = TipoEsp 
                        AND fechaProduccion = FechaProdEsp AND productora = ProdEsp
                        AND fechaYHora = HoraEvento AND direccion = Direccion
                        AND tipoUsuario = UsuarioReserva
                    INTO var_precio_reserva, var_loc_max_reserva;
                
                    IF (var_loc_max_reserva < Num_localidades) THEN
                        
                        SELECT 'Esta superando el limite de localidades por reserva permitido.';
                        
                    ELSE 
                    
                       IF (PagadaAlMomento) THEN
                       
                             SELECT 'Realizase o pago';
                       
                             #call pago(); funcion pago a parte para chamala tamen cando queramos pagar unha localidade xa reservada
                             #engadimos a reserva a taboa
                          
                       ELSE 
                           
                           SET @i = 0;
                           
                           bucle:LOOP
                           
                               SET @compra := (SELECT asientoLocalidad
                                               FROM localidades
                                               WHERE nombreEsp=NomEsp AND tipoEsp=TipoEsp 
                                                   AND fechaProduccion=FechaProdEsp AND productora=ProdEsp
                                                   AND fechaYHora = HoraEvento AND direccion = Direccion
                                                   AND nombreGrada = Grada AND estado = 'Libre'
                                                   LIMIT 1);
                               
                               INSERT INTO entradas values('prereservada', NULL, NOW(), NULL, UsuarioReserva, @compra, Grada, NomEsp, TipoEsp, FechaProdEsp, ProdEsp, HoraEvento, Direccion);
                               
                               UPDATE localidades SET estado = 'Reservado' WHERE asientoLocalidad = @compra;
                               
                               SET @i = @i + 1;
                           
                               IF (@i = Num_localidades) THEN
                                   LEAVE bucle;
                               END IF;
                               
                           
                           END LOOP bucle;
                
                       
                          
                       END IF;
                    
                    END IF;
                    
                END IF;      
                
            END IF;
            
        END IF;
    
    END IF;
 
   
END//
DELIMITER ;
