/*
Ejercicio 2 - Problema de Batman vs Villanos

Se tiene una lista de poderes con su danio y su costo de energia.
Tambien una lista de villanos con su vida y sus debilidades.

Se quiere saber si Batman puede derrotar a todos los villanos con una energia maxima.
Batman puede intentar poderes distintos contra el mismo villano (si un poder no sirve, puede probar otro),
pero cada intento consume energia segun el costo del poder.

Se usa DFS visto en clase.
*/


% base de conocimiento

power_list([
    power(logica, 100, 10),
    power(sigilo, 150, 30),
    power(fuerza, 250, 50)
]).

villain_list([
    villain(riddler, 90, [logica, sigilo]),
    villain(bane, 240, [fuerza])
]).


% modelo del estado
% estado(VillanosPendientes, PoderesDisponibles, EnergiaRestante)


% regla de utilidad
% danio_efectivo(+NombrePoder, +Debilidades, +DanioBase, -DanioReal)
danio_efectivo(NombrePoder, Debilidades, DanioBase, DanioReal) :-
    ( member(NombrePoder, Debilidades) ->
        DanioReal is DanioBase
    ;   DanioReal is 0
    ).


% aplicar_poder_a_villano(+Villano, +Poder, -VillanoActualizado, -FueDerrotado)
aplicar_poder_a_villano(
    villain(NombreVillano, VidaActual, Debilidades),
    power(NombrePoder, DanioBase, _CostoEnergia),
    VillanoActualizado,
    FueDerrotado
) :-
    danio_efectivo(NombrePoder, Debilidades, DanioBase, DanioReal),
    VidaNueva is VidaActual - DanioReal,
    ( VidaNueva =< 0 ->
        FueDerrotado = true,
        VillanoActualizado = none
    ;   FueDerrotado = false,
        VillanoActualizado = villain(NombreVillano, VidaNueva, Debilidades)
    ).


% siguiente_estado(+EstadoActual, -EstadoSiguiente)
% Siempre se pelea contra el primer villano de la lista.
% Se elige un poder cualquiera, se descuenta energia, y se actualiza la vida del villano.
siguiente_estado(
    estado([VillanoActual | VillanosResto], Poderes, EnergiaActual),
    estado(VillanosSiguiente, Poderes, EnergiaNueva)
) :-
    member(PoderElegido, Poderes),
    PoderElegido = power(_, _, CostoEnergia),
    EnergiaActual >= CostoEnergia,
    EnergiaNueva is EnergiaActual - CostoEnergia,
    aplicar_poder_a_villano(VillanoActual, PoderElegido, VillanoActualizado, Derrotado),
    ( Derrotado = true ->
        VillanosSiguiente = VillanosResto
    ;   VillanosSiguiente = [VillanoActualizado | VillanosResto]
    ).


% meta: si ya no quedan villanos, gano
es_meta(estado([], _, _)).


% dfs(+EstadoActual, +Visitados)
dfs(EstadoActual, _) :-
    es_meta(EstadoActual),
    !.

dfs(EstadoActual, Visitados) :-
    siguiente_estado(EstadoActual, EstadoSiguiente),
    \+ member(EstadoSiguiente, Visitados),
    dfs(EstadoSiguiente, [EstadoSiguiente | Visitados]).


% consulta principal
batman_can_win(EnergiaMaxima) :-
    power_list(Poderes),
    villain_list(Villanos),
    EstadoInicial = estado(Villanos, Poderes, EnergiaMaxima),
    dfs(EstadoInicial, [EstadoInicial]).


% consultas
% ?- batman_can_win(60).
% ?- batman_can_win(59).

% resultados esperados
% true.
% false.
