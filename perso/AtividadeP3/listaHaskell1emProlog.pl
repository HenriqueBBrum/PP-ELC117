%1.Crie uma função sumSquares :: Int -> Int -> Int que calcule a soma dos quadrados de dois números x e y.

sumSquares(X,Y,Result):- A is X*X, B is Y*Y, Result is A+B.

%2.Crie uma função hasEqHeads :: [Int] -> [Int] -> Bool que verifique se 2 listas possuem o mesmo primeiro elemento.
%Use a função head e o operador lógico == para verificar igualdade.

hasEqHeads(L1,L2):- L1 = [H1|_], L2  = [H2|_], H1 =:= H2.

%3.Escreva uma função que receba uma lista de nomes e adicione a string
%"Super " no início de cada nome. Use o operador ++ para concatenar strings (ou qualquer lista).

addSuper([],[]).
addSuper(L1,L2):-
  L1 = [H1|T1],
  atom_concat("Super", H1, H2),
  L2 = [H2|T2],
  addSuper(T1,T2),!.

%4.Crie uma função que receba uma lista de chars e retorne o número de espaços nela contidos. Dica: aplique 2 funções consecutivamente.

countSpaces(S,N):-
  string_chars(S,L),
  countSpaces_(L,N).

countSpaces_([],0).
countSpaces_(L,N):-
  L = [H|T],
  H = ' ',
  countSpaces_(T,N1),
  N is N1+1,!.
countSpaces_(L,N):-
  L = [_|T],
  countSpaces_(T,N),!.

%5.Escreva uma função que, dada uma lista de números, calcule 3*n^2 + 2/n + 1 para cada número n da lista. Dica: defina uma função anônima.

calculo([],[]).
calculo([H1|T1],[H2|T2]):-
    H2 is 3*(H1*H1)+2/H1+1,
    calculo(T1,T2).

%6. Escreva uma função que, dada uma lista de números, selecione somente os que forem negativos.

onlyNeg([],[]).
onlyNeg([H1|T1],L2):-
  H1 < 0,
  L2 = [H1|T2],
  onlyNeg(T1,T2),!.
onlyNeg([_|T1],L2):-
  onlyNeg(T1,L2),!.

%7 Escreva uma função que receba uma lista de números e retorne somente os que estiverem entre 1 e 100,
%inclusive. Dica 1: defina uma função anônima. Dica 2: use o operador && para expressar um 'E' lógico.

entre0e100([],[]).
entre0e100([H1|T1],L2):-
  H1 > 0, H1 < 100,
  L2 = [H1|T2],
  entre0e100(T1,T2),!.
entre0e100([_|T1],L2):-
  entre0e100(T1,L2),!.


%8.Escreva uma função que, dada uma lista de idades de pessoas no ano atual, retorne uma lista somente com as
%idades de quem nasceu depois de 1980. Para testar a condição, sua função deverá subtrair a idade do ano atual.

bornAfter1980([],[]).
bornAfter1980([H1|T1],L2):-
 D is H1-1980,
 D>0,
 L2 = [H1|T2],
 bornAfter1980(T1,T2),!.
bornAfter1980([_|T1],L2):-
  bornAfter1980(T1,L2),!.

%9.Escreva uma função que receba uma lista de números e retorne somente aqueles que forem pares.

odd(N):- 1 is mod(N,2),!.

onlyEven([],[]).
onlyEven(L1,L2):-
	L1 = [H|T],
  \+odd(H),
  D is H,
  L2 = [D|T2],
	onlyEven(T,T2),!.

onlyEven(L1,L2):-
    	L1 = [_|T],
    	onlyEven(T,L2),!.

%10.Crie uma função charFound :: Char -> String -> Bool que verifique se o caracter (primeiro argumento) está contido
%na lista de chars (segundo argumento). Exemplos de uso da função:

charFound(S,C):-
  string_chars(S,L),
  charFound_(L,C),!.

charFound_([C|_],C).
charFound_(L,C):-
  L = [_|T],
  charFound_(T,C),!.

%11.Crie uma função que receba uma lista de nomes e retorne outra lista com somente aqueles nomes que terminarem com a letra 'a'.
%Dica: conheça o list monster, do autor Miran Lipovača :-)

convertToAtoms([],[]).
convertToAtoms(L,ListAtoms):-
  L = [H|T1],
  string_chars(H,Atomics),
  ListAtoms = [Atomics|T2],
  convertToAtoms(T1,T2),!.

convertoToStrigns([],[]).
convertoToStrigns(L,ListStrings):-
  L = [H|T1],
  atomics_to_string(H,String),
  ListStrings = [String|T2],
  convertoToStrigns(T1,T2),!.

lastCharIsA(L1,L2):-
  convertToAtoms(L1,A),
  lastCharIsA_(A,B),!,
  convertoToStrigns(B,L2).

myLast([H],H).
myLast([_|T],X):-
    myLast(T,X).

lastCharIsA_([],[]).
lastCharIsA_(L1,L2):-
  L1  = [H|T1],
  myLast(H,Y) ,
  Y = a,
  L2 = [H|T2],
  lastCharIsA_(T1,T2).
lastCharIsA_([_|T],L2):-
  lastCharIsA_(T,L2).
