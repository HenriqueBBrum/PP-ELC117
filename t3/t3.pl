repete(0, _, []).
repete(N, C, L) :- 
 N > 0,
 L = [C | T],
 N1 is N - 1,
 repete(N1, C, T).


odd(N):- 1 is mod(N,2).


hasN([],0). 
hasN(L,N):-
	N>0,
	L = [_|T],
	N1 is N-1,
	hasN(T,N1).

inc99([],[]).
inc99(L1,L2):-
	L1 = [H|T],
	D is H+99,
	L2 = [D|T2],
	inc99(T,T2).

incN([],[],_).
incN(L1,L2,N):-
	N>0,
	L1 = [H|T],
	D is H+N,
	L2 = [D|T2],
	incN(T,T2,N).

comment([],[]).
comment(L1,L2):-
	L1 = [H|T],
	atom_concat(H, "%%", D),
	L2 = [D|T2],
	comment(T,T2).




onlyEven([],[]).
onlyEven(L1,L2):-
	L1 = [H|T],
	odd(H) ,
	L2 = [D|T2],
	onlyEven(T,T2).

countdown(0,[]).
countdown(N,L):-
	N>0,
	L = [N|T],
	N1 is N-1,
	countdown(N1,T).


nRandoms(0,[]).
nRandoms(N,L):-
	N>0,
	C is random(100),
	L = [C|T],
	N1 is N-1,
	nRandoms(N1,T).

potN0(0,[]).
potN0(N,L):-
	N>0,
	C is 2^N,
	L = [C|T],
	N1 is N-1,
	potN0(N1,T).


zipMult([],_,[]).
zipMult(_,[],[]).
zipMult(L1,L2,L3):-
	L1 = [H1|T1],
	L2 = [H2|T2],
	C is H1*H2,
	L3 = [C|T3],
	zipMult(T1,T2,T3).




potencias(0,[]).
potencias(N,L):-
	N1 is N-1,
	L = [_|T],
	potencias(N1,T),
	C is 2^N1,
	L = [C|_].



