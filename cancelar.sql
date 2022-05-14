DELIMITER //
drop procedure if exists anularReserva
create procedure anularReserva(
@id_reserva int,
@id_cliente int,
@id_evento int
)
as
begin
    declare penalizacion float;
    declare comienzo timestamp;

end
