## Explicações:

### Inicio:

  A primeira parte é composta  das "simplification rules" em que o programa além de traduzir algumas palavras parecidas e trocar certas palavras por outras com o intuito de facilitar a busca de respostas também ajusta os pronomes para que a respota fique correta, um exemplo disso é quando o "am" é trocado por "are" ou seja as respostas vão usar "are" que assim ira endereçar o perguntador.

  Ainda na primeira parte , há todo o conjunto de respostas para cada tipo de pergunta ou inferência em que a regra "rule" vai ter um keyword como "my", "dream" ou "computer", a importancia dessa keyword em que a resposta vai ser uma das respostas da keyword mais importante mas se as keywords forem iguais a primeira na string ganha. Depois disso vem qual tipo de padrão especifico de cada keyword por exemplo quando o are é usado há varias maneiras de usa-lo como "..are you ...." ou "..they are...", por fim vem qual foi a ultima pergunta para que a eliza fique variando entre as respostas.
  
### Meio:

  Após isso, vem uma série de regras que manipulam a string de entrada retirando pontuação, colocando em lower case e por fim transformando cada parte dela em um "atomo" para entrar em uma lista, nessa parte não há nada muito especial.O o programa faz isso manipulando uma string e criando uma nova string mais limpa recursivamente e para criar atomos ele vai pegando cada palavra da string e converte para "atomicos" que é uma lista com cada palvra sem aspas, ou seja, a frase "can machines think." vira [can,machines,think].
  
### Fim:

  Na ultima parte vêm algumas regras para manipular listas, regras para pegar o input, escrever os comentarios, etc e por fim a regra principal que organiza o funcionamento do programa. Desta parte achei importante comentar 2 regras que são mais conplexas a "match" e "make comment".

  A regra "match" serve para pegar o Y de cada regra para escrever o comentário com algo que o usuário escreveu. Ela é dividida em 3 funções auxiliares: a match_aux1 confirma se na matchrule só tem variaveis ou constantes e se houver alguma lista ou algo assim ele tenta remover o que está dentro da lista; a match_aux2, junto com a match_3, é a funçaõ que irá recursivamente separar as palavras e na volta da chamada passar essas palavras para a match, ela também verifica se há na match_rule há uma das palavras; a match_aux3 junto com a match_Aux2 vai diminuindo até uma das listas estar vazia e ela também junta palavras parar formar uma lista caso tenha menos variaveis do que palavras.

  A regra "makecomment" faz o comentério para as palavras chaves. Há duas exceções, quando a keyword é "memory" ela recupera os inputs de mem para fazer o comentário e quando é "your" ela passa a lista de inputs para a mem. Ela é divida em 3 partes; mc_aux recebe as regras da keyword escolhida e usa a função match para pegar o Y, depois chama a mc_aux2; mc_aux2 decide qual comentario da keyowrd usar dependendo do numero que esta após a matchrule de cada keyword([1,[_,your,Y],0], o primeiro numero é qual varição da keyword your, a lista é a variação e o segundo numero é qual comentario foi ultilizado); a match_aux3 atualiza qual vai ser o novo comentário além de retornar o novo comentário
