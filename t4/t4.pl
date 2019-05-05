assasino(X):- motivo(X), acesso(X).

acesso(X):- temChave(X),roubouArma(X),estavaApart(X),!.

temChave(bia).

temChave(X):-localizacao(X,portoAlegre,terca);localizacao(X,santaMaria,santaMaria).

roubouArma(X):-roubouMartelo(X);roubouBaseballBat(X).

roubouBaseballBat(X):- localizacao(X,portoAlegre,quinta);localizacao(X,santaMaria,quarta), relacao(X,bernardo),!.

roubouMartelo(X):- localizacao(X,apartamento,quinta);localizacao(X,apartamento,quarta).

estavaApart(X):-localizacao(X,apartamento,quinta);localizacao(X,apartamento,sexta).

motivo(X):- insanidade(X);ciumes(X);dinheiro(X).

insanidade(X):- insano(X).
ciumes(X):- ciumento(X).
dinheiro(X):- pobre(X).


ciumento(X):- relacao(anita,Y), relacao(X,Y).
ciumento(X):- relacao(anita,Y), relacao(Y,X).

relacao(anita,bernardo).
relacao(bernardo,caren).
relacao(anita,pedro).
relacao(pedro,alice).
relacao(alice,henrique).
relacao(henrique,maria).
relacao(maria,adriano).
relacao(adriano,caren).

vitima(anita).

insano(adriano).
insano(maria).

pobre(bernardo).
pobre(bia).
pobre(pedro).
pobre(maria).

%segunda não importa
localizacao(pedro,santaMaria,segunda).
localizacao(pedro,santaMaria,terca).
localizacao(pedro,portoAlegre,quarta).
localizacao(pedro,santaMaria,quinta).
localizacao(pedro,apartamento,sexta).

localizacao(caren,portoAlegre,segunda).
localizacao(caren,portoAlegre,terca).
localizacao(caren,portoAlegre,quarta).
localizacao(caren,santaMaria,quinta).
localizacao(caren,apartamento,sexta).

localizacao(henrique,apartamento,segunda).
localizacao(henrique,portoAlegre,terca).
localizacao(henrique,apartamento,quarta).
localizacao(henrique,apartamento,quinta).
localizacao(henrique,apartamento,sexta).

localizacao(bia,apartamento,segunda).
localizacao(bia,portoAlegre,terca).
localizacao(bia,portoAlegre,quarta).
localizacao(bia,santaMaria,quinta).
localizacao(bia,apartamento,sexta).

localizacao(adriano,apartamento,segunda).
localizacao(adriano,apartamento,terca).
localizacao(adriano,santaMaria,quarta).
localizacao(adriano,apartamento,quinta).
localizacao(adriano,apartamento,sexta).

localizacao(alice,apartamento,segunda).
localizacao(alice,portoAlegre,terca).
localizacao(alice,portoAlegre,quarta).
localizacao(alice,apartamento,quinta).
localizacao(alice,apartamento,sexta).

localizacao(bernardo,santaMaria,segunda).
localizacao(bernardo,santaMaria,terca).
localizacao(bernardo,portoAlegre,quarta).
localizacao(bernardo,santaMaria,quinta).
localizacao(bernardo,apartamento,sexta).

localizacao(maria,apartamento,segunda).
localizacao(maria,santaMaria,terca).
localizacao(maria,santaMaria,quarta).
localizacao(maria,santaMaria,quinta).
localizacao(maria,apartamento,sexta).
