drop procedure if exists localidadDeteriorada;

delimiter //

create procedure localidadDeteriorada(in asiento int, in nomGrada varchar(30), in nomEsp varchar(30), in tipo varchar(30), in fechaP date, in produ varchar(30), in fecha datetime, in direc varchar(50)) begin
	declare estadoViejo varchar(20);
	declare asientosLibres int;
	declare asientosExceso int;
	set estadoViejo = (
		select estado from localidades
			where asientoLocalidad = asiento 
			and nombreGrada = nomGrada 
			and nombreEsp = nomEsp 
			and tipoEsp = tipo
			and fechaProduccion = fechaP
			and productora = produ
			and fechaYHora = fecha
			and direccion = direc
		);
	if (estadoViejo = 'Reservado' or estadoViejo = 'Prereservado') then
		set asientosLibres = (
			select count(*) from localidades
				where estado = 'Libre'
				and nombreEsp = nomEsp
				and tipoEsp = tipo
				and fechaProduccion = fechaP
				and productora = produ
				and fechaYHora = fecha
				and direccion = direc
				group by estado
			);
		if (asientosLibres is null) then
			set asientosExceso = (
				select count(*) from localidades
					where nombreGrada = 'Exceso'
					and nombreEsp = nomEsp
					and tipoEsp = tipo
					and fechaProduccion = fechaP
					and productora = produ
					and fechaYHora = fecha
					and direccion = direc
					group by nombreGrada
				);			
			insert into gradas values('Exceso', nomEsp, tipo, fechaP, produ, fecha, direc);
			if (asientosExceso is null) then insert into localidades values(1, 'Exceso', nomEsp, tipo, fechaP, produ, fecha, direc, estadoViejo);
			else insert into localidades values(asientosExceso+1, 'Exceso', nomEsp, tipo, fechaP, produ, fecha, direc, estadoViejo);
			end if;
		else
			update localidades
				set estado = estadoViejo
				where estado = 'Libre'
				and nombreEsp = nomEsp
				and tipoEsp = tipo
				and fechaProduccion = fechaP
				and productora = produ
				and fechaYHora = fecha
				and direccion = direc
				limit 1;
		end if;
	end if;
	
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
end//

delimiter ;
