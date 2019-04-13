import Text.Printf
import Data.Char
import System.IO
import System.Exit
import Data.Fixed

type Point     = (Float,Float)
type Rect      = (Point,Float,Float)
type Circle    = (Point,Float)


-------------------------------------------------------------------------------
-- Paletas
-------------------------------------------------------------------------------

rgbPalette :: Int -> [(Int,Int,Int)]
rgbPalette n  = take (x+rest) (strongToWeak (x+rest) 'r') ++ take x (strongToWeak x 'g') ++ take x (strongToWeak x 'b')
    where x = n `div` 3
          rest = n `mod` 3

strongToWeak :: Int -> Char ->[(Int,Int,Int)]
strongToWeak 0 _ = []
strongToWeak n c
  |c == 'r' || c == 'R' = [(r,0,0) | r<-[0,(255 `div` n)..255]]
  |c == 'g' || c == 'G' = [(0,g,0) | g<-[0,(255 `div` n)..255]]
  |c == 'b' || c == 'B' = [(0,0,b) | b<-[0,(255 `div` n)..255]]
  |otherwise = [(x,x-(x`div`2),x-(x`div`2)) | x <-[0,(255 `div` n)..255]]


fadeColor :: (Int, Int, Int) -> [(Int, Int, Int)]
fadeColor color  = [color]

trd (_,_,a) = a
first (a,_,_) = a
second (_,a,_) = a

takeN :: Int -> [Int]
takeN n
  |n > 360 =  take n $ cycle [0..360]
  |otherwise = take n $ cycle [0,(360 `div` n)..360]

rainbowPalette :: Int  -> [(Int, Int, Int)]
rainbowPalette n = [rainbowPalette2 x |x <- takeN n]

rainbowPalette2 :: Int -> (Int, Int, Int)
rainbowPalette2 angle
  |angle < 60 = (255, hsvLights !! angle, 0)
  |angle < 120 = (hsvLights !! (120-angle), 255, 0)
  |angle < 180 = ( 0, 255, hsvLights !! (angle-120))
  |angle < 240 = (0, hsvLights !! (240-angle), 255)
  |angle < 300 = (hsvLights !! (angle-240), 0, 255)
  |otherwise = (255, 0, hsvLights !! (360-angle))
  where hsvLights = part1 ++ part2 ++ part3 ++ part4
        part1 = [0, 4, 8, 13, 17, 21, 25, 30, 34, 38, 42, 47, 51, 55, 59, 64, 68, 72, 76]
        part2 = [81, 85, 89, 93, 98, 102, 106, 110, 115, 119, 123, 127, 132, 136, 140, 144]
        part3 = [149, 153, 157, 161, 166, 170, 174, 178, 183, 187, 191, 195, 200, 204, 208]
        part4 = [212, 217, 221, 225, 229, 234, 238, 242, 246, 251, 255]


createRgbCopy :: Float-> Float -> Float -> (Float, Float, Float)
createRgbCopy h c x
  | h>= 0 && h<60 = (c,x,0)
  | h>= 60 && h<120 = (x,c,0)
  | h>= 120 && h<180 = (0,c,x)
  | h>= 180 && h<240 = (0,x,c)
  | h>= 240 && h<300 = (x,0,c)
  | h>= 300 && h<360 = (c,0,x)

returnMod :: Float -> Float -> Float
returnMod x y = x `mod'` y

hsvToRgb :: (Float, Float, Float) -> (Int, Int, Int)
hsvToRgb hsv
  |first hsv>360 || first hsv<0 = (0,0,0)
  |second hsv < 0.0 || second hsv >1.0 = (255,255,255)
  |trd  hsv < 0.0 || trd hsv >1.0 = (125,0,125)
  |otherwise =  (round((first rgbCopy + m)*255), round((second rgbCopy + m)*255), round((trd rgbCopy + m)*255))
  where rgbCopy = createRgbCopy (first hsv) c x
        m = trd hsv - c
        x = c*(1-abs( returnMod (first hsv/60) 2 - 1))
        c = second hsv * trd hsv



-------------------------------------------------------------------------------
-- Gera��o de ret�ngulos em suas posi��es
-------------------------------------------------------------------------------

--generate n rects, each line of rects has x rects
genAllRects :: Int -> Int -> [Rect]
genAllRects n x
  |n `mod` x == 0 = genNLine (n `div` x) x 0.0
  |otherwise = genNLine (n`div`x) x 0.0 ++ genRectsInLine (n `mod` x) lastLineY
  where lastLineY  = fromIntegral (n `div`x)*12

--generate n lines with x rects recursively each line is y from each other
genNLine :: Int -> Int -> Float -> [Rect]
genNLine n x y
    | n == 0 = []
    |otherwise = genRectsInLine x y ++ genNLine (n-1) x (y+12)

--generate line with n rects with y position equal y
genRectsInLine :: Int -> Float -> [Rect]
genRectsInLine n  y = [((m*(w+gap), y),w,h) | m <- [0..fromIntegral (n-1)]]
  where (w,h) = (10,10)
        gap = 10

-------------------------------------------------------------------------------
-- Gera��o de circulos em formato de circulo
-------------------------------------------------------------------------------

genCirclesInCircleFormation :: Int -> Circle ->[Circle]
genCirclesInCircleFormation qnt circle = genCircles qnt qnt circle

genCircles :: Int -> Int -> Circle -> [Circle]
genCircles qnt i circle
  | i == 0 = []
  | otherwise = createCircle 5.0 angleRadians circle  ++ genCircles qnt (i-1) circle
  where angleRadians  = pi * (fromIntegral i) * 2.0/ fromIntegral(qnt)

createCircle :: Float -> Float -> Circle -> [Circle]
createCircle  r angle circle = [((fst(fst circle) + cos(angle)*snd circle,snd(fst circle) + sin(angle)*snd circle), r)]

-------------------------------------------------------------------------------
-- Gera��o de circulos em formato de triangulo
-------------------------------------------------------------------------------
genCirclesInTiangularFormation :: Int -> Int -> Float ->[Circle]
genCirclesInTiangularFormation n i r
  |n `mod` i == 0 = genNCirclesLines (n `div` i) i fstY r
  |otherwise = genNCirclesLines  (n`div`i) i fstY r ++ concat(genCircleLine (n `mod` i) (lastLineY+fstY) r)
  where lastLineY  = fromIntegral (n `div`i)*4*r
        fstY = 2*r

genNCirclesLines :: Int -> Int -> Float -> Float ->[Circle]
genNCirclesLines nline i y r
    | nline == 0 = []
    |otherwise = concat(genCircleLine i y r) ++ genNCirclesLines (nline-1) i (y+4*r) r

genCircleLine :: Int -> Float -> Float -> [[Circle]]
genCircleLine i y r = [createCirclesTriangularForm (m) y r | m <- [r,r+4*r..4*r*fromIntegral (i-1)]]

createCirclesTriangularForm :: Float -> Float -> Float -> [Circle]
createCirclesTriangularForm  x y r = [((x,y-(r-r/3)),r)]++[((x+(r-r/3),y+r/3),r)]++[((x-r+r/3,y+r/3),r)]


-------------------------------------------------------------------------------
-- Gera��o de circulos em linha curvilínea
-------------------------------------------------------------------------------
genCirclesInCurvilinearFormation :: Int ->[Circle]
genCirclesInCurvilinearFormation n = gen3CurvilinearLines n  50.0

gen3CurvilinearLines :: Int -> Float -> [Circle]
gen3CurvilinearLines n y =  genCurvilinearLine (x+rest) (x+rest) y ++ genCurvilinearLine x x (y+50) ++ genCurvilinearLine x x (y+100)
    where x = n `div` 3
          rest = n `mod` 3

genCurvilinearLine :: Int -> Int -> Float -> [Circle]
genCurvilinearLine n i y
  | i == 0 = []
  | otherwise = createCircle2 n r angleRadians initP ++ genCurvilinearLine n (i-1) y
  where angleRadians  = pi * (fromIntegral i) * (5.0/(2.0*fromIntegral(n)))
        x = (r+r/2)*fromIntegral(n-i)
        r = 5.0
        initP = (x,y)

createCircle2 ::Int -> Float -> Float -> Point -> [Circle]
createCircle2  n r angle p  = [((100.0 + fst p,100+ snd p + cos(angle)*4*(fromIntegral n)/r), r)]

-------------------------------------------------------------------------------
-- Gera��o de circulo fromado por varios retangulos
-------------------------------------------------------------------------------
genRectanglesInCircleFormation :: Int -> Int -> Circle ->[Rect]
genRectanglesInCircleFormation qntC qntR circle = genNCircles qntC 0 qntR (fst circle) ((snd circle)/(fromIntegral qntC))

genNCircles :: Int -> Int -> Int-> Point -> Float -> [Rect]
genNCircles qntC i qntR p r
  | i >= qntC = []
  | otherwise = genRectangles qntR qntR p r ++ genNCircles qntC (i+1) qntR newP (2*r)
  where  newP = ((fst p - r/8), (snd p - r/8)+r/3)

genRectangles :: Int -> Int -> Point -> Float -> [Rect]
genRectangles qnt i center circleR
  | i == 0 = []
  | i `mod` 2 == 0 = createRects angleRadians center circleR size ((-1*fst p), 0.0) ++ genRectangles qnt (i-1) center circleR
  | otherwise = createRects angleRadians center circleR size p ++ genRectangles qnt (i-1) center circleR
  where angleRadians  = pi * (fromIntegral i) * 2.0/(fromIntegral(qnt))
        p = (circleR/4 ,0.0)
        size  = aux (qnt-i) (circleR/16)

aux:: Int -> Float -> Float
aux 0 _ = 1
aux n val = val + aux(n-1) (val/2)


createRects ::  Float ->Point -> Float -> Float-> Point -> [Rect]
createRects angle center circleR size p = [((fst center + cos(angle)*circleR-(fst p),snd center + sin(angle)*circleR), size,size)]

-------------------------------------------------------------------------------
-- Gera��o do fractal de mandelbrot
-------------------------------------------------------------------------------

genRectanglesInMdSet :: Point -> Point -> Int -> Int -> [Rect]
genRectanglesInMdSet screenSize p magnf maxi = createRectsInMdSet screenSize p magnf maxi

cal :: Int -> Point -> Point-> [Point]
cal 0 (_,_) (_,_) = []
cal i originalP p =[(tempReal,tempImag)] ++ cal (i-1) originalP (tempReal, tempImag)
  where tempReal = (fst p)*(fst p) - (snd p)*(snd p) + fst originalP
        tempImag = 2* (fst p) *(snd p) + snd originalP

belToMdSet :: Point -> Int -> Bool
belToMdSet p maxi = if (realPart * imaPart) < 5  then True else False
    where realPart = fst (last (cal maxi p p))
          imaPart = snd (last (cal maxi p p))



createRectsInMdSet :: Point -> Point -> Int -> Int -> [Rect]
createRectsInMdSet screenSize p magnf maxi = [((x,y),1,1) | x<-[0.0..(fst screenSize)], y<-[0.0..(snd screenSize)],belToMdSet(x/mag-fst p,y/mag - snd p) maxi == True]
  where mag = fromIntegral magnf


-------------------------------------------------------------------------------
-- Strings SVG
-------------------------------------------------------------------------------

-- Gera string representando ret�ngulo SVG
-- dadas coordenadas e dimensoes do ret�ngulo e uma string com atributos de estilo
svgRect :: Rect -> String -> String
svgRect ((x,y),w,h) style =
  printf "<rect x='%.3f' y='%.3f' width='%.2f' height='%.2f' style='%s' />\n" x y w h style

svgCircle :: Circle -> String -> String
svgCircle ((x,y),r) style =
  printf "<circle cx='%.3f' cy='%.3f' r='%.2f' style='%s' />\n" x y r style


-- String inicial do SVG
svgBegin :: Float -> Float -> String
svgBegin w h = printf "<svg width='%.2f' height='%.2f' xmlns='http://www.w3.org/2000/svg'>\n" w h

-- String final do SVG
svgEnd :: String
svgEnd = "</svg>"

-- Gera string com atributos de estilo para uma dada cor
-- Atributo mix-blend-mode permite misturar cores
svgStyle :: (Int,Int,Int) -> String
svgStyle (r,g,b) = printf "fill:rgb(%d,%d,%d); mix-blend-mode: screen;" r g b

-- Gera strings SVG para uma dada lista de figuras e seus atributos de estilo
-- Recebe uma funcao geradora de strings SVG, uma lista de c�rculos/ret�ngulos e strings de estilo
svgElements :: (a -> String -> String) -> [a] -> [String] -> String
svgElements func elements styles = concat $ zipWith func elements styles

-------------------------------------------------------------------------------
-- Fun��o principal que gera arquivo com imagem SVG
-------------------------------------------------------------------------------

mapDigitsToInt :: [Char] -> Int
mapDigitsToInt str = joinInt (map digitToInt str)

joinInt :: [Int] -> Int
joinInt l = read $ map intToDigit l


adjustColor:: String -> String -> String -> String -> (Int, Int, Int)
adjustColor x y z hsv
  |hsv == "y" =  hsvToRgb ((read x ::Float), (read y ::Float), (read z ::Float))
  |otherwise = ((read x ::Int), (read y ::Int), (read z ::Int))

rainbowOrNot ::Int -> Int -> String -> (Int, Int, Int) -> [(Int, Int, Int)]
rainbowOrNot cs n rw color
  | rw == "y" = rainbowPalette (n)
  | cs ==  1 || cs == 2 = fadeColor color
  | cs == 3 = take (n) $ cycle [(255,0,0),(0,255,0),(0,0,255)]
  | cs == 4 = rgbPalette n
  | cs == 5 = take (n) $ cycle [(255,0,0),(0,255,0),(0,0,255),(255,255,0)]
  | cs == 6 = take n $ cycle [color]


genCase1::Int -> Int -> (Int,Int,Int) ->String -> String
genCase1 nrects nrectperline color rw = svgElements svgRect rects (map svgStyle palette)
  where rects = genAllRects nrects nrectperline
        palette = rainbowOrNot 1 nrects rw color

genCase2::Int -> Float -> Point -> (Int,Int,Int) -> String -> String
genCase2 ncircles r p color rw = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInCircleFormation ncircles (p, r)
        palette = rainbowOrNot 2 ncircles rw color

genCase3 ::Int -> Int  -> Float -> String -> String
genCase3 ncirclescomb combPerLine r rw = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInTiangularFormation ncirclescomb combPerLine r
        palette  = rainbowOrNot 3 (3*ncirclescomb) rw (0,0,0)

genCase4::Int -> String -> String
genCase4 ncircles rw = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInCurvilinearFormation ncircles
        palette = rainbowOrNot 4 ncircles rw (0,0,0)


--Does something cool
genCase5::Int -> Int-> Float -> Point -> String ->String
genCase5 nC nR r p rw = svgElements svgRect rects (map svgStyle palette)
  where rects = genRectanglesInCircleFormation nC nR (p,r)
        palette = rainbowOrNot 5 (nC*nR) rw (0,0,0)

genCase6::Int -> Int -> (Int,Int,Int)-> String -> String
genCase6 mf mi color rw = svgElements svgRect rects (map svgStyle palette)
  where palette = rainbowOrNot 6 (length rects) rw color
        rects = genRectanglesInMdSet (300.0,300.0) (2.0, 1.6) mf mi

prompt :: String -> IO String
prompt text = do
  putStr text
  hFlush stdout
  getLine


main :: IO()
main = do
  putStrLn "Try case 3, 5 and 6 both on google and windows\n"
  putStrLn "case 1 : A green table\ncase 2 : A circle formed of circles"
  putStrLn "case 3 : A grid of Borromean rings\ncase 4 : Three curves formed by circles"
  putStrLn "case 5 : Something interesting that happened by chance\ncase 6 : Mandelbrot set"

  caseVar<- prompt "Choose a case: "

  if((read caseVar :: Int) < 1 || (read caseVar :: Int) > 6) then do
      putStr "You chose a unvalid number"
      exitFailure
  else
      putStrLn "You chose a valid number "

  let (w,h) = (1500.0,1000.0)
  printf "Screen -> Width = %.2f Height =%.2f \n\n" w h

  rainbow <- prompt "To use rainbow palette type 'y', for normal palette type any other key: "

  putStrLn "This next options will only work if you chose normal palette for case 1,2 or 6"
  putStrLn "If your choices don't fall on that category just press they key 0 four times"
  putStrLn "Choose a color"
  hsv <- prompt "To use HSV type 'y', for RGB type any other key:  "
  putStrLn "If you chose hsv, the fst value is between 0 and 360 , the snd and trd are 0.0 and 1.0"
  x<- prompt "Type the firt value of your color model: "
  y<- prompt "Type the second value of your color model: "
  z<- prompt "Type the thrid value of your color model: "
  let color = (adjustColor x y z hsv)

  printf "\nCase %s\n" caseVar

  case(caseVar) of
      x | x == "1" -> do
          n1<- prompt "Type how many rects: "
          n2<- prompt "Type how many rects per line: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase1 (read n1 :: Int) (read n2 :: Int) color rainbow ++ svgEnd
      x | x == "2" -> do
          px<- prompt "Type X point where this case will be drawn: "
          py<- prompt "Type Y point where this case will be drawn : "
          let p = ((read px :: Float),(read py :: Float))
          n1<- prompt "Type how many circles: "
          n2<- prompt "Type the radius of the bigger circle: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase2 (read n1 :: Int) (read n2 :: Float) p color rainbow ++ svgEnd
      x | x == "3" -> do
          n1<- prompt "Type how many combinations: "
          n2<- prompt "Type the amount of combinations per line "
          n3<- prompt "Type the radius of every circle: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase3  (read n1 :: Int) (read n2 :: Int) (read n3 :: Float) rainbow ++ svgEnd
      x | x == "4" -> do
          n1<- prompt "Type how many circles in total: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase4 (read n1 :: Int) rainbow ++ svgEnd
      x | x == "5" -> do
          px<- prompt "Type X point where this case will be drawn: "
          py<- prompt "Type Y point where this case will be drawn : "
          let p = ((read px :: Float),(read py :: Float))
          n1<- prompt "Type how many pairs of circles: "
          n2<- prompt "Type the amount of rects per pair of circle "
          n3<- prompt "Type the proportion of the radius of the smallest circle: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase5  (read n1 :: Int) (read n2 :: Int) (read n3 :: Float) p rainbow ++ svgEnd
      x | x == "6" -> do
          putStr "This case takes some time to build so watch out for the maximum iteration\n"
          n1<- prompt "Type the magnification factor: "
          n2<- prompt "Type the maximum interation: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase6 (read n1 :: Int)  (read n2 :: Int) color rainbow ++ svgEnd
