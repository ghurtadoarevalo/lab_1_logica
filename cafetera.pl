grain(arabica, suave).
grain(robusto, fuerte).
grain(combinado, medio).
grain(descafeinado, suave).
% Hechos para los granos
% ----------------------------------------------------------------------
%
% ----------------------------------------------------------------------
% Hechos para la preparación.
preparation(espresso, [7,0,0,30]).
preparation(americano, [7,0,0,60]).
preparation(cortado, [7,3,0,50]).
preparation(capuccino, [7,19,0,150]).
preparation(latte, [7,9,0,90]).
preparation(mokaccino, [7,9,3,100]).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Hechos para las tazas.
% Taza grande = 2 * ingrediente
% Taza mediana = 1 * ingrediente
% Taza chica = 60 * ingrediente
cup(grande, 2).
cup(mediana,1).
cup(pequena,0.5).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Hechos para la estación del año.
season(verano, 60).
season(primavera, 90).
season(invierno, 120).
season(otono, 90).
% ----------------------------------------------------------------------


% ----------------------------------------------------------------------
%                                Funciones
% ----------------------------------------------------------------------


% ----------------------------------------------------------------------
% Función que multiplica todos los elemento de una lista
% por una variable numérica. Lo deja en formato float la nueva lista.

% Ej: Lista = [1,2,3,4] , Value = 2  => Salida = [2.0,4.0,6.0,8.0]

% Entrada: Lista con números, Lista Salida, Valor numérico.
% Salida: Lista con numeros multiplicados por el valor numérico
% (float).
multByValueFloat([],[], _Value).
multByValueFloat([X|Xs],[Y|Ys], Value) :-
   multByValueFloat(Xs,Ys, Value),
   Y is float(X * Value).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Función que multiplica todos los elemento de un lista
% por una variable numérica. Lo deja en formato entero la nueva lista.

% Ej: Lista = [1,2,3,4] , Value = 2  => Salida = [2,4,6,8]

% Entrada: Lista con números, Lista Salida, Valor numérico.
% Salida: Lista con numeros multiplicados por el valor numérico
multByValue([],[], _Value).
multByValue([X|Xs],[Y|Ys], Value) :-
   multByValue(Xs,Ys, Value),
   Y is X * Value.
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Función que divide todos los elementos de una lista por los de otra
% lista.

% Ej: Lista1 = [10,20,30,40],Lista2 = [5,2,3,2] => Salida = [2,10,10,20]

% Entrada: Lista 1, Lista 2, Lista de salida.
% Salida: Lista con los resultados de la división.
divList([],[],[]).
divList([X|Xs],[Y|Ys], [Z|Zs]) :-
   divList(Xs,Ys, Zs),
   ( X == 0.0
   -> Z is 9999999999999.0
   ;  ( Y == 0.0)
      ->  Z is 999999999999.0
      ;   Z is float(X/Y)).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Función que agrega un elemento a una lista

% Ej: Lista 1 = [10,20,30], Elemento = 15 => Salida = [10,20,30,15]

% Entrada: Lista 1, Elemento, Lista de salida.
% Salida: Lista con los resultados de la división.
appendTail([],X,[X]).
appendTail([H|T],X,[H|L]):-appendTail(T,X,L).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Función que entrega el mínimo elemento de una lista.

% Ej: Lista 1 = [3,2,1,6,10] => Salida = 1

% Entrada: Salida, Lista.
% Salida: El menor número de la lista.
listMin(M, [X|Xs]):-
         list_min2(M, X, Xs).

list_min2(M, M, []):- !.

list_min2(X, Y, [Z|Zs]):-
          Z =< Y,
          !,
          list_min2(X, Z, Zs).

list_min2(X, Y, [Z|Zs]):-
          Z >= Y,
          list_min2(X, Y, Zs).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Función que permite saber la cantidad de ingredientes, intensidad y
% tiempo de prepraración de un café según ciertos parámetros.

% Ej: mediana, capuccino, robusto, verano =>Salida = [7,19,0,150,fuerte,60]

% Entrada: Tamaño taza, Tipo de preparación, Tipo de café, Estación del
% año, Salida.
% Salida: Lista con la cantidad de ingredientes, intensidad y tiempo de
% prepraración.
prepararCafe(TamanoTaza, TipoPreparacion, TipoCafe, EstacionAno, Salida):-
   preparation(TipoPreparacion, Ingredients),
   grain(TipoCafe, Grain),
   cup(TamanoTaza, Cup),
   season(EstacionAno, Season),
   %NewValue tiene la lista de ingredientes multiplicada por la taza
   multByValue(Ingredients,NewValue, Cup),
   %NewValue2 tiene la lista de ingredientes multiplicada por la taza
   %el grano (suave,medio,fuerte).
   appendTail(NewValue, Grain, NewValue2),
   %Salida queda con lo mismo que NewValue2 + el tiempo.
   appendTail(NewValue2, Season, Salida).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Función que permite saber la cantidad de tazas y el tiempo de
% preparación que tomará al ingresar cierta cantidad de ingredientes y
% otros parámetros.

% Ej: mediana, cortado, arabica, verano, 700, 200, 0, 3000 =>
% Salida = [60, 3600].

% Entrada: Tamaño taza, Tipo de preparación, Tipo de café, Estación del
% año, Cantidad de cafe, Cantidad de leche, Cantidad de chocolate,
% Cantidad de Agua, Salida.
% Salida: Lista con la cantidad de tazas y el tiempo de prepraración.
cantidadTazas(TamanoTaza, TipoPreparacion, _TipoCafe, EstacionAno, CantidadCafe, CantidadLeche, CantidadChocolate, CantidadAgua, Salida):-
   preparation(TipoPreparacion, Ingredients),
   cup(TamanoTaza, Cup),
   season(EstacionAno, Season),
   multByValueFloat(Ingredients, NewIngredientsList, Cup),
   AllIngredients = [CantidadCafe, CantidadLeche, CantidadChocolate, CantidadAgua],
   divList(AllIngredients, NewIngredientsList, DividedList),
   listMin(Min, DividedList),
   MinRounded is round(Min),
   Time is Season * MinRounded,
   Salida = [MinRounded, Time].
% ----------------------------------------------------------------------

















