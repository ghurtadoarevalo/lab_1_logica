grain(arabica, suave).
grain(robusto, fuerte).
grain(combinado, medio).
grain(descafeinado, suave).

preparation(espresso, [7,0,0,30]).
preparation(americano, [7,0,0,60]).
preparation(cortado, [7,3,0,50]).
preparation(capuccino, [7,19,0,150]).
preparation(latte, [7,9,0,90]).
preparation(mokaccino, [7,9,3,100]).

cup(grande, 2).
cup(mediana,1).
cup(pequena,0.5).

season(verano, 60).
season(primavera, 90).
season(invierno, 120).
season(otono, 90).

multByValueFloat([],[], _Value).
multByValueFloat([X|Xs],[Y|Ys], Value) :-
   multByValueFloat(Xs,Ys, Value),
   Y is float(X * Value).

multByValue([],[], _Value).
multByValue([X|Xs],[Y|Ys], Value) :-
   multByValue(Xs,Ys, Value),
   Y is X * Value.


divList([],[],[]).
divList([X|Xs],[Y|Ys], [Z|Zs]) :-
   divList(Xs,Ys, Zs),
   ( X == 0.0
   -> Z is 9999999999999
   ;  ( Y == 0.0)
      ->  Z is 999999999999
      ;   Z is float(X/Y)).

appendTail([],X,[X]).
appendTail([H|T],X,[H|L]):-appendTail(T,X,L).

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


cantidadTazas(TamanoTaza, TipoPreparacion, TipoCafe, EstacionAno, CantidadCafe, CantidadLeche, CantidadChocolate, CantidadAgua, Salida):-
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



%Taza grande = 2 * ingrediente
%Taza mediana = 1 * ingrediente
%Taza chica = 60 * ingrediente









