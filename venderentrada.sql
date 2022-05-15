USE proyecto;

DELIMITER //
DROP PROCEDURE IF EXISTS venderentrada//
CREATE PROCEDURE venderentrada(
   
    IN Espectador_tipo varchar(10),
    IN Asiento INT,
    IN Grada_nombre VARCHAR(20),
    IN Espectaculo_nombre VARCHAR(20),
    IN Espectaculo_tipo VARCHAR(20),
    IN Espectaculo_fecha DATE,
    IN Espectaculo_productora VARCHAR(20),
    IN Evento_fecha VARCHAR(20),
    IN Evento_direccion varchar(50),
    IN Cliente_correo varchar(30),
    IN modo varchar(30),
    IN Entrada_pago VARCHAR(20)

)
##MODO: Reserva, metodo de pago

BEGIN
 
 ###### Existe este evento?
 ###### Existe esta grada?
 ###### Puede ese tipo de público acudir a esa grada? 
 ###### Se puede reservar la localidad?
 ###### Realizar reserva
    SET @localidad := (SELECT COUNT(*) FROM localidades WHERE  asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion);
    
    SELECT @localidad;

    IF (@localidad = 1)THEN
        SET @estado := (SELECT estado FROM localidades WHERE  asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion);
        SET @precio := (SELECT precio FROM tarifas WHERE tipoUsuario=Espectador_tipo AND  nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion);
        
        IF (NOT @precio=NULL) THEN
            SELECT 'El tipo de usuario puede asistir a esta grada.';
            CASE
                WHEN @estado='Deteriodado' THEN
                    ##No se puede reservar ni comprar
                    SELECT "Esta localidad está deteriorada."
                WHEN @estado='Reservado' THEN
                    ##Ocupado
                    SELECT "Esta localidad ha sido reservada con anterioridad."

                WHEN @estado='Libre' THEN
                    ##Se puede reservar o comprar, revisamos modo?
                    IF (modo = 'Comprar') THEN
                        IF (NOT METODOPAGO='Efectivo') THEN
                            ##Sólo se puede comprar directamente en ventanilla
                        ELSE
                            INSERT INTO entradas VALUES('Efectivo',NOW(),NULL,Espectador_tipo,Asiento,Grada_nombre,Espectaculo_nombre,Espectaculo_tipo,Espectaculo_fecha,Espectaculo_productora,Evento_fecha,Evento_direccion);
                            UPDATE localidades SET estado='Reservado' WHERE  asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion;
                        END IF;
                      
                    ELSE IF (modo = 'preReservar') THEN
                        UPDATE localidades SET estado='Prereservado' WHERE  asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion;

                    END IF;
                
                WHEN @estado='Prereservado' THEN
                    ##Sólo se puede comprar
                    IF (modo = 'Comprar') THEN
                        IF ((SELECT correoCliente FROM entradas WHERE formaPago=NULL 
                                    AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre 
                                    AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora
                                    AND fechaYHora=Evento_fecha AND direccion=Evento_direccion
                                    AND asientoLocalidad=Asiento AND nombreGrada=Grada_nombre)=Cliente_correo) THEN

                                    ##EL CLIENTE QUE HA RESERVADO ES EL MISMO QUE QUIERE COMPRAR ENTONCES SE PUEDE hacer
                                    SELECT 'El cliente que quiere comprar es el mismo que el que reservo';
                                    INSERT INTO entradas VALUES(Entrada_pago,NOW(),Cliente_correo,Espectador_tipo,Asiento,Grada_nombre,Espectaculo_nombre,Espectaculo_tipo,Espectaculo_fecha,Espectaculo_productora,Evento_fecha,Evento_direccion);
                                    UPDATE localidades SET estado='Reservado' WHERE  asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion;

                        ELSE
                            ##EL CLIENTE QUE QUIERE COMPRAR NO ES EL MISMO QUE HA REALIZADO LA RESERVA
                            SELECT 'El cliente que quiere comprar no es el mismo que el que reservo';
                        END IF;
                    ELSE
                        ##Esta localidad está prereservada, sólo disponible para compra
                        SELECT 'Ejecute el método en modo compra, la localidad ha sido reservada con anterioridad.'
                    END;
                ELSE "The quantity is under 30"
            END;

        ELSE
        ##No puede asistir
        END IF;

        SELECT 'Existe la localidad, grada, evento, espectáculo';
        #Puede este tipo de público acudir a este evento??
        #Creo que lo suyo sería hacer un inner join pero es que con esta mierda de las claves deja de tener sentido.
        SET @precio := (SELECT precio FROM tarifas WHERE tipoUsuario=Espectador_tipo AND asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion);

        IF ( true ) THEN
            SELECT NULL;
        END IF;


    END IF;


IF ((SELECT COUNT(*) FROM eventos WHERE nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion ) > 0 ) THEN
        SELECT 'Existe este evento, vamos a seguir comprobando cosas';
        
        
    ELSE
        SELECT 'No se puede realizar la reserva, no existe el evento.';
    END IF;
END//
DELIMITER ;



##Comandos de prueba
#venderentrada('Adulto','3','Sur','espectaculo 0','teatro','1998-09-10','productora 0','3 agosto 8 pm','Calle de las flores número 0 puerta C')