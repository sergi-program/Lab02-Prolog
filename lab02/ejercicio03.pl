/*
Ejercicio 3 - 8 reinas

Se quiere resolver el problema de las 8 reinas usando DFS.
Un estado es una lista donde cada elemento representa la fila de la reina en cada columna.
Ejemplo: [4,3] significa:
- Columna 1 tiene una reina en fila 4
- Columna 2 tiene una reina en fila 3

La idea es ir construyendo la lista columna por columna, probando filas de 1 a 8,
sin poner reinas que se ataquen entre si.
*/


% una reina nueva no puede estar en la misma fila ni en diagonal con las anteriores

% no_atacan(+FilaNueva, +FilasPrevias)
no_atacan(_, []).
no_atacan(FilaNueva, [FilaPrev | Resto]) :-
    no_atacan_con_offset(FilaNueva, FilaPrev, 1),
    no_atacan_restantes(FilaNueva, Resto, 2).

no_atacan_restantes(_, [], _).
no_atacan_restantes(FilaNueva, [FilaPrev | Resto], Offset) :-
    no_atacan_con_offset(FilaNueva, FilaPrev, Offset),
    OffsetSiguiente is Offset + 1,
    no_atacan_restantes(FilaNueva, Resto, OffsetSiguiente).

% no_atacan_con_offset(+FilaNueva, +FilaPrev, +DeltaCol)
% DeltaCol es la diferencia de columnas entre la reina nueva y una reina previa
no_atacan_con_offset(FilaNueva, FilaPrev, DeltaCol) :-
    FilaNueva =\= FilaPrev,
    abs(FilaNueva - FilaPrev) =\= DeltaCol.


% siguiente_estado(+EstadoActual, -EstadoSiguiente)
% Agrega una reina en una fila candidata (1..8) si es segura
siguiente_estado(FilasActuales, FilasNuevas) :-
    length(FilasActuales, CantidadColocadas),
    CantidadColocadas < 8,
    between(1, 8, FilaCandidata),
    no_atacan(FilaCandidata, FilasActuales),
    append(FilasActuales, [FilaCandidata], FilasNuevas).


% meta: ya hay 8 reinas colocadas
es_meta(Filas) :-
    length(Filas, 8).


% dfs(+EstadoActual, +Visitados, -SolucionFinal)
% devuelve directamente una solucion final (no todo el camino)
dfs(EstadoActual, _, EstadoActual) :-
    es_meta(EstadoActual),
    !.

dfs(EstadoActual, Visitados, SolucionFinal) :-
    siguiente_estado(EstadoActual, EstadoSiguiente),
    \+ member(EstadoSiguiente, Visitados),
    dfs(EstadoSiguiente, [EstadoSiguiente | Visitados], SolucionFinal).


% consulta principal
solucion(Solucion) :-
    EstadoInicial = [],
    dfs(EstadoInicial, [EstadoInicial], Solucion).


% consulta
% ?- solucion(S).

% resultado esperado (ejemplos):
% S = [1,5,8,6,3,7,2,4] ;
% S = [1,6,8,3,7,4,2,5] ;
% ...
