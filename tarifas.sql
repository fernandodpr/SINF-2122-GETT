drop procedure if exists crearTarifa;

delimiter //

create procedure crearTarifa(in nomEsp varchar(20), in produ varchar(20), in tipEsp varchar(20), in fechaP date, in fecha date, in direc varchar(50), in nomGrada varchar(20), in tipoUs enum('bebe', 'infantil', 'juvenil', 'adulto', 'jubilado'), in precio numeric, in maxReservas int) begin 
        DECLARE inicio TIMESTAMP(6);
        SET inicio = CURRENT_TIMESTAMP(6);
	insert into tarifas values(tipoUs, precio, maxReservas, nomGrada, nomEsp, tipEsp, fechaP, produ, fecha, direc);
	SELECT timestampdiff(MICROSECOND, inicio, CURRENT_TIMESTAMP(6))/1000000 AS 'Tiempo de ejecucion';
end//

delimiter ;
