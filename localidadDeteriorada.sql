drop procedure if exists localidadDeteriorada;

delimiter //

create procedure localidadDeteriorada(in asiento int, in nomGrada varchar(30), in fecha datetime, in direc varchar(50)) begin
	declare estadoViejo varchar(20);
	declare asientosLibres int;
	declare asientosExceso int;
	declare asientoNuevo int;
	declare gradaNueva varchar(30);
	
	declare nomEsp varchar(30);
	declare tipo varchar(30);
	declare fechaP date;
	declare produ varchar(30);
	set estadoViejo = (
		select estado from localidades
			where asientoLocalidad = asiento 
			and nombreGrada = nomGrada
			and fechaYHora = fecha
			and direccion = direc
		);
	
	if (estadoViejo = 'Reservado' or estadoViejo = 'Prereservado') then
		set asientosLibres = (
			select count(*) from localidades
				where estado = 'Libre'
				and fechaYHora = fecha
				and direccion = direc
				group by estado
			);
		if (asientosLibres is null) then
			set asientosExceso = (
				select count(*) from localidades
					where nombreGrada = 'Exceso'
					and fechaYHora = fecha
					and direccion = direc
					group by nombreGrada
				);
			set nomEsp = (
				select nombreEsp from eventos
					where fechaYHora = fecha
					and direccion = direc
				);
			set tipo = (
				select tipoEsp from eventos
					where fechaYHora = fecha
					and direccion = direc
				);
			set fechaP = (
				select fechaProduccion from eventos
					where fechaYHora = fecha
					and direccion = direc
				);
			set produ = (
				select productora from eventos
					where fechaYHora = fecha
					and direccion = direc
				);
				
			if (asientosExceso is null) then 
				insert into gradas values('Exceso', nomEsp, tipo, fechaP, produ, fecha, direc);
				insert into localidades values(1, 'Exceso', nomEsp, tipo, fechaP, produ, fecha, direc, estadoViejo);
				set asientoNuevo = 1;
			else insert into localidades values(asientosExceso+1, 'Exceso', nomEsp, tipo, fechaP, produ, fecha, direc, estadoViejo);
			set asientoNuevo = asientosExceso + 1;
			end if;
			update entradas
				set nombreGrada = 'Exceso', asientoLocalidad = asientoNuevo
				where nombreGrada = nomGrada
				and asientoLocalidad = asiento
				and fechaYHora = fecha
				and direccion = direc
			;
		else
			set asientoNuevo = (
				select asientoLocalidad from localidades
					where estado = 'Libre'
					and nombreGrada = nomGrada
					and fechaYHora = fecha
					and direccion = direc
					limit 1
				);
			if (asientoNuevo is not null) then
				update localidades
					set estado = estadoViejo
					where asientoLocalidad = asientoNuevo
					and nombreGrada = nomGrada
					and fechaYHora = fecha
					and direccion = direc;
				update entradas
					set asientoLocalidad = asientoNuevo
					where asientoLocalidad = asiento
					and nombreGrada = nomGrada
					and fechaYHora = fecha
					and direccion = direc;
			else
				set gradaNueva = (
					select nombreGrada from localidades
						where estado = 'Libre'
						and fechaYHora = fecha
						and direccion = direc
						limit 1
					);
				set asientoNuevo = (
					select asientoLocalidad from localidades
						where estado = 'Libre'
						and nombreGrada = gradaNueva
						and fechaYHora = fecha
						and direccion = direc
						limit 1
					);
				update localidades
					set estado = estadoViejo
					where asientoLocalidad = asientoNuevo
					and nombreGrada = gradaNueva
					and fechaYHora = fecha
					and direccion = direc;
				update entradas
					set asientoLocalidad = asientoNuevo, nombreGrada = gradaNueva
					where asientoLocalidad = asiento
					and nombreGrada = nomGrada
					and fechaYHora = fecha
					and direccion = direc;
			end if;
		end if;
	end if;
	
	update localidades
		set estado = 'Deteriorado'
		where asientoLocalidad = asiento
		and nombreGrada = nomGrada
		and fechaYHora = fecha
		and direccion = direc;
end//

delimiter ;
