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
    IN Evento_direccion varchar(50)

)
BEGIN
 
 ###### Existe este evento?
 ###### Existe esta grada?
 ###### Puede ese tipo de público acudir a esa grada? 
 ###### Se puede reservar la localidad?
 ###### Realizar reserva
    SET @localidad := (SELECT COUNT(*) FROM localidades WHERE estado='libre' AND asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion);
    
    SELECT @localidad;

    IF (@localidad = 1)THEN
        SELECT 'Existe la localidad, grada, evento, espectáculo';
        #Puede este tipo de público acudir a este evento??
        #Creo que lo suyo sería hacer un inner join pero es que con esta mierda de las claves deja de tener sentido.
         SET @allowed := (SELECT COUNT(*) FROM localidades WHERE estado='libre' AND asientoLocalidad=Asiento AND nombreGrada=Grada_nombre AND nombreEsp=Espectaculo_nombre AND tipoEsp=Espectaculo_tipo AND fechaProduccion=Espectaculo_fecha AND productora=Espectaculo_productora AND fechaYHora=Evento_fecha AND direccion=Evento_direccion);

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