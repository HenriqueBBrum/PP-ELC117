sumSquares :: Int -> Int -> Int
sumSquares x y = x^2+y^2

hasEqHeads :: [Int] -> [Int] -> Bool
hasEqHeads lis1 lis2 = if (head lis1) == (head lis2)then True else False

addSuper_ :: String -> String
addSuper_ word = "Super" ++ word
addSuper :: [String] -> [String]
addSuper lis = map addSuper_ lis

findSpaceNum :: String -> Int
findSpaceNum string = length $ filter(== ' ') string

equation :: [Float] -> [Float]
equation lis = map (\n-> 3*n^2 + 2/n + 1) lis

selectNegative :: [Int] -> [Int]
selectNegative lis = filter(\n -> n < 0) lis

betweenOne100 :: [Int] -> [Int]
betweenOne100 lis = filter(\n -> n>0 && n<100) lis

bornAfter1980 :: [Int] -> [Int]
bornAfter1980 lis = filter(\n-> n-1980>0) lis

returnEven :: [Int] -> [Int]
returnEven lis = filter(\n-> mod n 2 ==0) lis

charFound :: Char -> String -> Bool
charFound c string = filter (\n -> c == n) string /= ""

aTailNames :: [String] -> [String]
aTailNames strings = filter(\n -> (last n) == 'a') strings


