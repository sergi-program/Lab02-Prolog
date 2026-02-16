/* Ejercicio 1 - Problema de la rana

Se quiere determinar si una rana puede llegar desde la orilla_inicial 
hasta la orilla_final saltando entre piedras, teniendo una distancia 
maxima de salto.

Se utiliza el algoritmo DFS visto en clase.
*/


% base de conocimiento

% Coordenadas de las ubicaciones: ubicacion(ID, X, Y).
ubicacion(orilla_inicial, 0, 5).
ubicacion(piedra1, 2, 4).
ubicacion(piedra2, 5, 6).
ubicacion(piedra3, 8, 4).
ubicacion(piedra4, 5, 0).
ubicacion(orilla_final, 10, 5).

% Capacidad maxima de salto
salto_maximo(4.0).


% utilidades

% distancia(+LugarA, +LugarB, -Distancia)
% Calcula la distancia euclidiana entre dos ubicaciones.
distancia(LugarA, LugarB, Distancia) :-
    ubicacion(LugarA, XA, YA),
    ubicacion(LugarB, XB, YB),
    DX is XA - XB,
    DY is YA - YB,
    Distancia is sqrt(DX*DX + DY*DY).

% puede_saltar(+LugarActual, +LugarSiguiente)
% Verifica si la rana puede saltar entre dos puntos
puede_saltar(LugarActual, LugarSiguiente) :-
    LugarActual \= LugarSiguiente,
    salto_maximo(SaltoMaximo),
    distancia(LugarActual, LugarSiguiente, Distancia),
    Distancia =< SaltoMaximo.


% espacio de estados
% Un estado se representa como pos(Lugar)

% siguiente_estado(+EstadoActual, -EstadoSiguiente)
siguiente_estado(pos(LugarActual), pos(LugarSiguiente)) :-
    ubicacion(LugarSiguiente, _, _),
    puede_saltar(LugarActual, LugarSiguiente).


% condicion meta
es_meta(pos(orilla_final)).


% dfs(+EstadoActual, +Visitados, -Camino)
dfs(EstadoActual, _, [EstadoActual]) :-
    es_meta(EstadoActual),
    !.

dfs(EstadoActual, Visitados, [EstadoActual | CaminoResto]) :-
    siguiente_estado(EstadoActual, EstadoSiguiente),
    \+ member(EstadoSiguiente, Visitados),
    dfs(EstadoSiguiente, [EstadoSiguiente | Visitados], CaminoResto).


% consulta principal
buscar_solucion(Solucion) :-
    EstadoInicial = pos(orilla_inicial),
    dfs(EstadoInicial, [EstadoInicial], Solucion).


% consulta
% ?- buscar_solucion(S).

% resultado esperado (una posible solucion):
% S = [pos(orilla_inicial), pos(piedra1), pos(piedra2), pos(piedra3), pos(orilla_final)].
