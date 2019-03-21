import Data.Char

--(1) Crie uma função isVowel :: Char -> Bool que verifique
--se um caracter é uma vogal ou não.

isVowel :: Char -> Bool
isVowel c
      | c =='A' || c=='a' = True
      | c =='E' || c=='e' = True
      | c =='I' || c=='i' = True
      | c =='O' || c=='o' = True
      | c =='U' || c=='u' = True
      | otherwise = False


--(2)Escreva uma função addComma, que adicione uma vírgula
--no final de cada string contida numa lista.

addComa :: [String] -> [String]
addComa strings = map (\str -> str++",") strings


--(3)Crie uma função htmlListItems :: [String] -> [String], que receba
-- uma lista de strings e retorne outra lista contendo as strings formatadas
--como itens de lista em HTML.
--Resolva este exercício COM e SEM funções anônimas (lambda).

htmlListItems :: [String] -> [String]
htmlListItems strings = map (\str-> "<LI>"++str++"</LI>") strings

--(sem lambda)

htmlFormat :: String -> String
htmlFormat str = "<LI>" ++ str ++ "</LI>"
htmlListItems_ :: [String] -> [String]
htmlListItems_ strings = map htmlFormat strings


--(4)Defina uma função que receba uma string e produza outra retirando
--as vogais, conforme os exemplos abaixo.
--Resolva este exercício COM e SEM funções anônimas (lambda).

semVogais :: String -> String
semVogais str = filter (\c->  not( isVowel c) )str

--(sem lambda)

verificaConsoante:: Char -> Bool
verificaConsoante c = if isVowel c == True then False else True
semVogais_ :: String -> String
semVogais_ str = filter verificaConsoante str


--(5)Defina uma função que receba uma string, possivelmente contendo espaços,
 --e que retorne outra string substituindo os demais caracteres
 --por '-', mas mantendo os espaços.
 --Resolva este exercício COM e SEM funções anônimas (lambda).

codifica :: String -> String
codifica str = map (\c -> if c/= ' ' then '-' else ' ')str

--(sem lambda)

substitui :: Char -> Char
substitui c = if c/= ' ' then '-' else ' '
codifica_ :: String -> String
codifica_ str = map substitui str


--(6)Escreva uma função firstName :: String -> String que, dado o nome
--completo de uma pessoa, obtenha seu primeiro nome.
--Suponha que cada parte do nome seja separada por um espaço
--e que não existam espaços no início ou fim do nome.

firstName :: String -> String
firstName str = head(words str)


--(7)Escreva uma função isInt :: String -> Bool que verifique se uma
--dada string só contém dígitos de 0 a 9. Exemplos:

isInt :: String -> Bool
isInt str = filter(\c -> not (c>='0' && c<='9'))str == ""

--(8)Escreva uma função lastName :: String -> String que, dado o nome
--completo de uma pessoa, obtenha seu último sobrenome.
--Suponha que cada parte do nome seja separada por um espaço
--e que não existam espaços no início ou fim do nome.

lastName :: String -> String
lastName str = last(words(str));

--(9)Escreva uma função userName :: String -> String que, dado o
--nome completo de uma pessoa, crie um nome de usuário (login) da pessoa,
--formado por: primeira letra do nome seguida do sobrenome, tudo em minúsculas.

strToLower :: String -> String
strToLower str = map toLower str

charToString :: Char -> String
charToString c = [c]

userName :: String -> String
userName str  = charToString(toLower(head(head(words(str))))) ++ strToLower(last(words(str)))


--(10)Escreva uma função encodeName :: String -> String que substitua
--vogais em uma string, conforme o esquema
--a seguir: a = 4, e = 3, i = 2, o = 1, u = 0.

substituiVogal :: Char -> Char
substituiVogal c
            | c == 'a' || c == 'A' = '4'
            | c == 'e' || c == 'E' = '3'
            | c == 'i' || c == 'I' = '2'
            | c == 'o' || c == 'O' = '1'
            | c == 'u' || c == 'U' = '0'
            |otherwise = c
encodeName :: String -> String
encodeName str = map substituiVogal str

--(11)Escreva uma função betterEncodeName :: String -> String que substitua
--vogais em uma string, conforme este
--esquema: a = 4, e = 3, i = 1, o = 0, u = 00.

substituiVogal_ :: Char -> String
substituiVogal_ c
        | c == 'a' || c == 'A' = "4"
        | c == 'e' || c == 'E' = "3"
        | c == 'i' || c == 'I' = "1"
        | c == 'o' || c == 'O' = "0"
        | c == 'u' || c == 'U' = "00"
        |otherwise = [c]

betterEncodeName :: String -> String
betterEncodeName str = concat(map substituiVogal_ str)


--(12)Dada uma lista de strings, produzir outra lista com
--strings de 10 caracteres, usando o seguinte esquema: strings de
--entrada com mais de 10 caracteres são truncadas, strings com até 10
--caracteres são completadas com '.' até ficarem com 10 caracteres.

refazString :: String  -> String
refazString str
          | length(str) == 10 = str
          | length(str) > 10 = take 10 str
          | length(str) < 10 = take 10 (str++"..........")

refazStrings :: [String] -> [String]
refazStrings strings = map refazString strings
