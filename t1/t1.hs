--(1) Retorna ture se for vogal false se não for

isVowel :: Char -> Bool
isVowel c
      | c =='A' || c=='a' = True
      | c =='E' || c=='e' = True
      | c =='I' || c=='i' = True
      | c =='O' || c=='o' = True
      | c =='U' || c=='u' = True
      | otherwise = False


--(2)Add virgula no fim de cada string da lista

addComa :: [String] -> [String]
addComa strings = map (\str -> str++",") strings


--(3.1)Recebe lista de strings e retorna as strings formatadas com
--itens de lista em HTML(com lambda)

htmlListItems :: [String] -> [String]
htmlListItems strings = map (\str-> "<LI>"++str++"<LI>") strings


--(3.2)Recebe lista de strings e retorna as strings formatadas com
--itens de lista em HTML(sem lambda)

htmlFormat :: String -> String
htmlFormat str = "<LI>" ++ str ++ "<LI>"
htmlListItems_ :: [String] -> [String]
htmlListItems_ strings = map htmlFormat strings


--(4.1)Retira as vogais de uma string(com lambda)

semVogais :: String -> String
semVogais str = filter (\c->  not( isVowel c) )str


--(4.2)Retira as vogais de uma string(sem lambda)

verificaConsoante:: Char -> Bool
verificaConsoante c = if isVowel c == True then False else True
semVogais_ :: String -> String
semVogais_ str = filter verificaConsoante str


--(5.1)Substitui todos os char da string por '-'
-- e matém os ' '(com lambda)

codifica :: String -> String
codifica str = map (\c -> if c/= ' ' then '-' else ' ')str


--(5.2)Substitui todos os char da string por '-'
-- e matém os ' '(sem lambda)

substitui :: Char -> Char
substitui c = if c/= ' ' then '-' else ' '
codifica_ :: String -> String
codifica_ str = map substitui str


--(6)Pega o primeiro nome da pessoa

firstName :: String -> String
firstName str = head(words str)


--(7)Verifica se a string só tem digitos de 0 à 9

isInt :: String -> Bool
isInt str = filter(\c -> not (c>='0' && c<='9'))str == ""
