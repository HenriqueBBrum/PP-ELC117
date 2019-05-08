import Data.Char

--1. Defina um predicado odd(N) que seja verdadeiro se N for um número ímpar.
myOdd :: Int -> Bool
myOdd n =  mod n 2 /= 0

--2. Defina um predicado recursivo hasN(L,N) que seja verdadeiro se L for uma lista de N elementos.

hasN :: Int -> [Int] -> Bool
hasN 0 [] = True
hasN _ [] = False
hasN 0 _ = False
hasN n (x:xs) = hasN (n-1) xs

-- 3.Defina um predicado recursivo inc99(L1,L2), de forma que L2 seja uma lista com todos os elementos de L1 acrescidos da constante 99.

inc99 :: [Int] -> [Int]
inc99 [] = []
inc99 list = (head list + 99):inc99(tail list)

-- 4.Defina um predicado recursivo incN(L1,L2,N), de forma que L2 seja uma lista com todos os elementos de L1 acrescidos da constante N.

incN ::Int -> [Int] -> [Int]
incN _ [] = []
incN n list = (head list + n):incN n (tail list)

-- 5.Defina um predicado recursivo comment(L1,L2), de forma que L1 seja uma lista de strings e L2 tenha todos os elementos de L1
--concatenados com o prefixo "%%". Dica: consulte predicados Prolog para manipulação de strings.

comment :: [String] -> [String]
comment [] = []
comment strs =  ((head strs) ++ "%%"):comment (tail strs)


-- 6.Defina um predicado recursivo onlyEven(L1,L2), de forma que L2 seja uma lista só com os elementos pares de L1,
--conforme o exemplo abaixo:

onlyEven :: [Int] -> [Int]
onlyEven [] = []
onlyEven (x:xs)
  |odd(x) == True =  onlyEven xs
  |otherwise = x : onlyEven xs

--7.Defina um predicado recursivo countdown(N,L), de forma que L seja uma lista com os números [N, N-1, N-2, .., 1],
--sendo N um número positivo. Exemplo:

countdown :: Int -> [Int]
countdown 1 = [1]
countdown n = n : countdown (n-1)

--8.Defina um predicado recursivo nRandoms(N,L), de forma que L seja uma lista com N números gerados aleatoriamente,
--conforme os exemplos abaixo:
--Nao consegui importar "System.Random" então criei uma função para mandar uns números que parecem ser random

getRandomNumber :: Int -> Int
getRandomNumber n
  |mod n 2 == 0 = n*n-n-12+n*5
  |mod n 3 == 0 = n*n*n-12*n+n*n*5
  |mod n 5 == 0 = n-12+n*5
  |otherwise = (mod n 7)*n-n*n-12+n*5

nRandoms :: Int -> [Int]
nRandoms 0 = []
nRandoms n = getRandomNumber n : nRandoms(n-1)

--9.Defina um predicado recursivo potN0(N,L), de forma que L seja uma lista de potências de 2, com expoentes de N a 0. Exemplo de uso:

potN0 :: Int -> [Int]
potN0 0 = [1]
potN0 n = 2^n : potN0(n-1)



--10. Defina um predicado recursivo zipmult(L1,L2,L3), de forma que cada elemento da lista L3 seja o produto dos elementos de L1 e L2 n
--a mesma posição do elemento de L3. Exemplo:

zipmult :: [Int] -> [Int] -> [Int]
zipmult _ [] = []
zipmult [] _ = []
zipmult list1 list2 = ((head list1) * (head list2)):zipmult(tail list1) (tail list2)


--11.Defina um predicado recursivo potencias(N,L), de forma que L seja uma lista com as N primeiras potências de 2,
--sendo a primeira 2^0 e assim por diante, conforme o exemplo abaixo:

potenciasAux :: Int -> Int -> [Int]
potenciasAux 0 _ = []
potenciasAux n k = 2^k:potenciasAux (n-1) (k+1)

potencias :: Int -> [Int]
potencias n = potenciasAux n 0

--12.Defina um predicao recursivo cedulas(V,L1,L2), que receba um valor V e uma lista L1 de cédulas com valores em Reais (R$), em ordem decrescente,
-- e obtenha a lista L2 decompondo o valor V em 0 ou mais cédulas de cada tipo. Exemplo:

cedulas :: Int -> [Int] -> [Int]
cedulas 0 [] = []
cedulas valor (x:xs) = a:cedulas b xs
  where a = valor `div` x
        b = valor - a*x
