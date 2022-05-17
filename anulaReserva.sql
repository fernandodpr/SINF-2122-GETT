DELIMITER //
DROP PROCEDURE IF EXISTS anularReserva//

CREATE PROCEDURE anularReserva(
	IN IN_correoCliente varchar(30),

	IN IN_asientoLocalidad int,
    IN IN_nombreGrada varchar(30),

    IN IN_nombreEsp varchar(30),
    IN IN_fechaProduccion date,
    IN IN_tipoEsp varchar(30),
    in IN_productora varchar(30),

    in IN_fechaYHora DATETIME,
    in IN_direccion varchar(50)
)
BEGIN
 
SET @tipo := SELECT tipoUsuario FROM entradas WHERE asientoLocalidad=IN_asientoLocalidad AND nombreGrada=IN_nombreGrada AND nombreEsp=IN_nombreEsp 
    AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora AND fechaYHora=IN_fechaYHora AND direccion=IN_direccion;

SET @precio := SELECT precio FROM tarifas WHERE tipousuario=@tipo AND nombreGrada=IN_nombreGrada AND nombreEsp=IN_nombreEsp 
    AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora AND fechaYHora=IN_fechaYHora AND direccion=IN_direccion;

SET @estadoevento := SELECT estado FROM eventos WHERE nombreEsp=IN_nombreEsp AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora AND fechaYHora=IN_fechaYHora AND direccion=IN_direccion;

SET @tCancelacion := SELECT tCancelacion FROM espectaculos WHERE nombreEsp=IN_nombreEsp AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora ;
SET @Penalizacion := SELECT Penalizacion FROM espectaculos WHERE nombreEsp=IN_nombreEsp AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora ;

DELETE FROM entradas WHERE tipousuario=@tipo AND asientoLocalidad=IN_asientoLocalidad AND nombreGrada=IN_nombreGrada AND nombreEsp=IN_nombreEsp 
    AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora AND fechaYHora=IN_fechaYHora AND direccion=IN_direccion;

IF (@estadoevento='Finalizado') THEN
    SELECT 'Ya no es posible realizar modificaciones sobre este evento.';
    SET reembolso:= 0 ;
ELSE
    if (@precio = 0) THEN
        SELECT 'Esta entrada no existía';
        SET reembolso:= 0;
    ELSE
        if(SUBTIME(IN_fechaYHora,@tCancelacion)<NOW())THEN
            ##Se aplica penalizacion
            DELETE FROM entradas  WHERE asientoLocalidad=IN_asientoLocalidad AND nombreGrada=IN_nombreGrada AND nombreEsp=IN_nombreEsp 
                AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora AND fechaYHora=IN_fechaYHora AND direccion=IN_direccion;
            SET reembolso:= precio-penalizacion;
        ELSE
            ##No se aplica penalizacion
            DELETE FROM entradas  WHERE asientoLocalidad=IN_asientoLocalidad AND nombreGrada=IN_nombreGrada AND nombreEsp=IN_nombreEsp 
                AND tipoEsp=IN_tipoEsp AND fechaProduccion=IN_fechaProduccion AND productora=IN_productora AND fechaYHora=IN_fechaYHora AND direccion=IN_direccion;
            SET reembolso:= precio;
        END IF;

    END IF;
END IF;

Select 'Reembolso: '+reembolso;


END
//
DELIMITER ;
