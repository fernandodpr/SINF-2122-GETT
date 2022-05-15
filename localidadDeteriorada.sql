drop procedure if exists localidadDeteriorada;

delimiter //

create procedure localidadDeteriorada(in asiento int, in nomGrada varchar(30), in nomEsp varchar(30), in tipo varchar(30), in fechaP date, in produ varchar(30), in fecha datetime, in direc varchar(50)) begin
	declare estadoViejo varchar(20);
	set estadoViejo = (
		select estado from localidades where asientoLocalidad = asiento 
			and nombreGrada = nomGrada 
			and nombreEsp = nomEsp 
			and tipoEsp = tipo
			and fechaProduccion = fechaP
			and productora = produ
			and fechaYHora = fecha
			and direccion = direc
		);
	if (estadoViejo = 'Reservado' or estadoViejo = 'Prereservado') then
		select 'Hay que gestionar la cancelación';
	else
		update localidades
			set estado = 'Deteriorado'
			where asientoLocalidad = asiento
				and nombreGrada = nomGrada
				and nombreEsp = nomEsp
				and tipoEsp = tipo
				and fechaProduccion = fechaP
				and productora = produ
				and fechaYHora = fecha
				and direccion = direc;
	end if;
end//

delimiter ;
