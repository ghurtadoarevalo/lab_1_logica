grain(arabica, suave).
grain(robusto, fuerte).
grain(combinado, medio).
grain(descafeinado, suave).
% Hechos para los granos
% ----------------------------------------------------------------------
%
% ----------------------------------------------------------------------
% Hechos para la preparaci�n.
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
% Hechos para la estaci�n del a�o.
season(verano, 60).
season(primavera, 90).
season(invierno, 120).
season(otono, 90).
% ----------------------------------------------------------------------


% ----------------------------------------------------------------------
%                                Funciones
% ----------------------------------------------------------------------


% ----------------------------------------------------------------------
% Funci�n que multiplica todos los elemento de una lista
% por una variable num�rica. Lo deja en formato float la nueva lista.

% Ej: Lista = [1,2,3,4] , Value = 2  => Salida = [2.0,4.0,6.0,8.0]

% Entrada: Lista con n�meros, Lista Salida, Valor num�rico.
% Salida: Lista con numeros multiplicados por el valor num�rico
% (float).
multByValueFloat([],[], _Value).
multByValueFloat([X|Xs],[Y|Ys], Value) :-
   multByValueFloat(Xs,Ys, Value),
   Y is float(X * Value).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Funci�n que multiplica todos los elemento de un lista
% por una variable num�rica. Lo deja en formato entero la nueva lista.

% Ej: Lista = [1,2,3,4] , Value = 2  => Salida = [2,4,6,8]

% Entrada: Lista con n�meros, Lista Salida, Valor num�rico.
% Salida: Lista con numeros multiplicados por el valor num�rico
multByValue([],[], _Value).
multByValue([X|Xs],[Y|Ys], Value) :-
   multByValue(Xs,Ys, Value),
   Y is X * Value.
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Funci�n que divide todos los elementos de una lista por los de otra
% lista.

% Ej: Lista1 = [10,20,30,40],Lista2 = [5,2,3,2] => Salida = [2,10,10,20]

% Entrada: Lista 1, Lista 2, Lista de salida.
% Salida: Lista con los resultados de la divisi�n.
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
% Funci�n que agrega un elemento a una lista

% Ej: Lista 1 = [10,20,30], Elemento = 15 => Salida = [10,20,30,15]

% Entrada: Lista 1, Elemento, Lista de salida.
% Salida: Lista con los resultados de la divisi�n.
appendTail([],X,[X]).
appendTail([H|T],X,[H|L]):-appendTail(T,X,L).
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% Funci�n que entrega el m�nimo elemento de una lista.

% Ej: Lista 1 = [3,2,1,6,10] => Salida = 1

% Entrada: Salida, Lista.
% Salida: El menor n�mero de la lista.
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


install(X):-
   (   X == si
   ->  true
   ;   false).



%Considerando que el min de cantidad chocolate es 15gr.
sePuedeUsar(Instalada, CantidadAgua, CantidadCafe, CantidadLeche, CantidadChocolate):-
   install(Instalada),
   CantidadAgua >= 150,
   CantidadCafe >= 30,
   CantidadLeche >= 30,
   CantidadChocolate >= 15.


% ----------------------------------------------------------------------
% Funci�n que permite saber la cantidad de ingredientes, intensidad y
% tiempo de prepraraci�n de un caf� seg�n ciertos par�metros.

% Ej: mediana, capuccino, robusto, verano =>Salida = [7,19,0,150,fuerte,60]

% Entrada: Tama�o taza, Tipo de preparaci�n, Tipo de caf�, Estaci�n del
% a�o, Salida.
% Salida: Lista con la cantidad de ingredientes, intensidad y tiempo de
% prepraraci�n.
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
% Funci�n que permite saber la cantidad de tazas y el tiempo de
% preparaci�n que tomar� al ingresar cierta cantidad de ingredientes y
% otros par�metros.

% Ej: mediana, cortado, arabica, verano, 700, 200, 0, 3000 =>
% Salida = [60, 3600].

% Entrada: Tama�o taza, Tipo de preparaci�n, Tipo de caf�, Estaci�n del
% a�o, Cantidad de cafe, Cantidad de leche, Cantidad de chocolate,
% Cantidad de Agua, Salida.
% Salida: Lista con la cantidad de tazas y el tiempo de prepraraci�n.
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

















