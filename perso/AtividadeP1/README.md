Introdução às funções anônimas(lambda) em C++


O C++ inclui desde o C++11 a alternativa de criar funções lambda, sendo um dos principais objetivos aumentar a facilidade e agilidade de escrever códigos.

Em C++ elas são definidas assim:

	[] () →return-type{corpo}

O [] serve para indicar de que maneira os elementos fora do escopo da função podem ser usados.

    • []   Não é permitido usar elementos fora do escopo;

    • [=] Os elementos são passados por cópia (não é possível altera-los);
    • [&] Os elementos são passados por referência (é possível altera-los);
    • [x] O elemento x é passado por cópia;

    • [&x] O elemento x é passado por referência;

O () indica os parâmetros que a função lambda recebe.

O → explicita o tipo de retorno (não precisa ser usado caso o tipo seja simples pois o compilador descobre qual é mas para casos mais complexos é necessário)

O {} engloba o que a função irá fazer.

Exemplo:

		#include<iostream>

		inline void  print(auto i){ std::cout<<"X = "<<i<<std::endl; }


		inline int returnInt(auto i){ return [i](){return i+10;}(); }


		int main(){
   			 int x = 1000;

   			 [](int x){std::cout<<"X = "<<x<<std::endl;} (x);

   			 [=](){std::cout<<"X = "<<x<<std::endl;} ();

   			 print([](int x)→int {return x+10;} (x));

    			[&](){x=x+200;} ();

   			print(returnInt(x));

   			return 0;
		}

Obs.: Os parênteses após a função lambda são as chamadas das funções. Pode se declarar as funções lambdas também dessa maneira: “auto  f  = [](int x){return 1};” e depois chamar a função assim : “std::cout<<f(10)<<std::endl;”.


Tutorial preparado por Henrique Becker Brum.
