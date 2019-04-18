is_member(A,[A,_]).
is_member(A,L):-
	is_member(A,[_|T]).

ao_lado(X, Y, L):- nextto(X,Y,L); nextto(Y,X,L).

um_entre(X, Y, L):- 
	(nextto(X,A,L); nextto(A,X,L)),
	(nextto(Y,A,L); nextto(A,Y,L)).

%aviao(piloto,cor,anomalia,bebida,esporte)

problema_avioes(Avioes):-
	Avioes = [_,_,_,_,_],
	member(aviao(milton,vermelha,_,_,_), Avioes),
	member(aviao(walter,_,radio_ruim,_,_),Avioes),
	member(aviao(_,verde,_,_,pescar),Avioes),
	member(aviao(rui,_,_,_,futebol),Avioes),
	nextto(aviao(_,branca,_,_,_),aviao(_,verde,_,_,_),Avioes),
	member(aviao(_,_,altimetro_desregulado,leite,_),Avioes),
	member(aviao(_,preta,_,cerveja,_),Avioes),
	member(aviao(_,vermelha,_,_,natacao),Avioes),
	[aviao(farfarelli,_,_,_,_)| _] = Avioes,
	ao_lado(aviao(_,_,_,cafe,_),aviao(_,_,pane_hidraulica,_,_),Avioes),
	ao_lado(aviao(_,_,_,cerveja,_),aviao(_,_,problem_bussola,_,_),Avioes),
	member(aviao(_,_,_,cha,equitacao),Avioes),
	member(aviao(nascimento,_,_,agua,_),Avioes),
	ao_lado(aviao(farfarelli,_,_,_,_),aviao(_,azul,_,_,_),Avioes),
	um_entre(aviao(_,_,pane_hidraulica,_,_),aviao(_,_,altimetro_desregulado,_,_),Avioes),	
	member(aviao(_,_,_,_,tenis),Avioes),
	member(aviao(_,_,problema_temp,_,_),Avioes).

positivos1([],[]).
positivos1([H|T],L) :- H > 0, positivos1(T,Resto), L = [H|Resto].
positivos1([H|T],L) :- H =< 0, positivos1(T,L).

positivos2([],[]).
positivos2([H|T],L) :- H > 0, L = [H|Resto], positivos2(T,Resto).
positivos2([H|T],L) :- H =< 0, positivos2(T,L).

%Com alguns teste percebi que,a principio, o 1 faz menos lips mas usa mais a CPU e o 2 o contrario


