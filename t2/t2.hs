import Text.Printf
import Data.Char
import System.IO
import System.Exit

type Point     = (Float,Float)
type Rect      = (Point,Float,Float)
type Circle    = (Point,Float)


-------------------------------------------------------------------------------
-- Paletas
-------------------------------------------------------------------------------

rgbPalette :: Int -> [(Int,Int,Int)]
rgbPalette n = take n $ cycle [(255,0,0),(0,255,0),(0,0,255),(255,255,0)]

rgbPalette2 :: Int -> [(Int,Int,Int)]
rgbPalette2 n  = init (greenToblue (x+rest)) ++ init (blueToRed x) ++ init (redToGreen x)
    where x = n `div` 3
          rest = n `mod` 3

greenToblue :: Int -> [(Int,Int,Int)]
greenToblue 0 = [(0,0,0)]
greenToblue n = [(0,g,b) | g<-[255,255-(255 `div` n)..0], b<-[0,(255 `div` n)..255], b == abs(g-255)]

blueToRed :: Int -> [(Int,Int,Int)]
blueToRed 0 = [(0,0,0)]
blueToRed n = [(r,0,b) | r<-[0,(255 `div` n)..255], b<-[255,255-(255`div` n)..0], r == abs(b-255)]

redToGreen :: Int -> [(Int,Int,Int)]
redToGreen 0 = [(0,0,0)]
redToGreen n = [(r,g,0) | r<-[255,255-(255`div` n)..0], g<-[0,(255 `div` n)..255],g == abs(r-255)]

rgbPalette3 :: Int -> [(Int,Int,Int)]
rgbPalette3 n  = take (x+rest) (strongToWeak (x+rest) 'r') ++ take x (strongToWeak x 'g') ++ take x (strongToWeak x 'b')
    where x = n `div` 3
          rest = n `mod` 3

strongToWeak :: Int -> Char ->[(Int,Int,Int)]
strongToWeak 0 _ = []
strongToWeak n c
  |c == 'r' || c == 'R' = [(r,0,0) | r<-[0,(255 `div` n)..255]]
  |c == 'g' || c == 'G' = [(0,g,0) | g<-[0,(255 `div` n)..255]]
  |c == 'b' || c == 'B' = [(0,0,b) | b<-[0,(255 `div` n)..255]]
  |otherwise = [(x,x-(x`div`2),x-(x`div`2)) | x <-[0,(255 `div` n)..255]]


--generate a list of n tuple where every z tuple the green part goes back to the
--same green as z-x
completeGreenPalette :: Int -> Int -> [(Int,Int,Int)]
completeGreenPalette n x
  |n `mod` x == 0 = greenNPalette (n `div` x) x 80
  |otherwise =  greenNPalette (n `div` x) x 80 ++ greenPalette (n `mod` x) lastInit
  where lastInit  = fromIntegral (n `div` x)*20+80

greenNPalette :: Int ->Int -> Int -> [(Int,Int,Int)]
greenNPalette n x y
    | n == 0 = []
    |otherwise = greenPalette x y ++ greenNPalette (n-1) x (y+10)

greenPalette :: Int -> Int -> [(Int,Int,Int)]
greenPalette n init = [(0,init+i*10,0) | i <- [0..(n-1)] ]




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
createCircle2  n r angle p  = [((100.0 + fst p, snd p + cos(angle)*4*(fromIntegral n)/r), r)]

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

genCase1::Int -> Int -> String
genCase1 nrects nrectperline = svgElements svgRect rects (map svgStyle palette)
  where rects = genAllRects nrects nrectperline
        palette = completeGreenPalette nrects nrectperline

genCase2::Int -> Float -> Point -> String
genCase2 ncircles r p = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInCircleFormation ncircles (p, r)
        palette = rgbPalette2 ncircles

genCase3 ::Int -> Int -> Float -> String
genCase3 ncirclescomb combPerLine r = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInTiangularFormation ncirclescomb combPerLine r
        palette = take (3*ncirclescomb) $ cycle [(255,0,0),(0,255,0),(0,0,255)]


genCase4::Int -> String
genCase4 ncircles = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInCurvilinearFormation ncircles
        palette = rgbPalette3 ncircles


--Does something cool
genCase5::Int -> Int-> Float -> Point ->String
genCase5 nC nR r p = svgElements svgRect rects (map svgStyle palette)
  where rects = genRectanglesInCircleFormation nC nR (p,r)
        palette = rgbPalette (nC*nR)

genCase6::Int -> Int -> (Int,Int,Int) -> String
genCase6 mf mi  color = svgElements svgRect rects (map svgStyle palette)
  where palette = [color | n <-[0..length rects]]
        rects = genRectanglesInMdSet (300.0,300.0) (2.0, 1.6) mf mi

prompt :: String -> IO String
prompt text = do
  putStr text
  hFlush stdout
  getLine

--Abrir o caso 3 e 5 tanto no google quanto no explorer para ver as diferenças

main :: IO()
main = do
  putStrLn "Try case 3, 5 and 6 both on google and windows\n"
  putStrLn "Choose a case :"
  putStrLn "case 1 : A green table\ncase 2 : A circle formed of circles"
  putStrLn "case 3 : A grid of Borromean rings\ncase 4 : Three curves formed by circles"
  putStrLn "case 5 : Something interesting that happened by chance\ncase 6 : Mandelbrot set"

  caseVar <- getChar
  aux<- prompt ""

  if(caseVar<'1' || caseVar >'6') then do
      putStr "You chose a unvalid number"
      exitFailure
  else
      putStrLn "You chose a valid number "

  let (w,h) = (1500.0,1000.0)
  printf "Width = %.2f Height =%.2f \n" w h
  printf "Case %c\n" caseVar

  case(caseVar) of
      x | x == '1' -> do
          n1<- prompt "Type how many rects: "
          n2<- prompt "Type how many rects per line: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase1 (read n1 :: Int) (read n2 :: Int) ++ svgEnd
      x | x == '2' -> do
          px<- prompt "Type X point where this case will be drawn: "
          py<- prompt "Type Y point where this case will be drawn : "
          let p = ((read px :: Float),(read py :: Float))
          n1<- prompt "Type how many circles: "
          n2<- prompt "Type the radius of the bigger circle: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase2 (read n1 :: Int) (read n2 :: Float) p ++ svgEnd
      x | x == '3' -> do
          n1<- prompt "Type how many combinations: "
          n2<- prompt "Type the amount of combinations per line "
          n3<- prompt "Type the radius of every circle: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase3  (read n1 :: Int) (read n2 :: Int) (read n3 :: Float) ++ svgEnd
      x | x == '4' -> do
          n1<- prompt "Type how many circles in total: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase4 (read n1 :: Int) ++ svgEnd
      x | x == '5' -> do
          px<- prompt "Type X point where this case will be drawn: "
          py<- prompt "Type Y point where this case will be drawn : "
          let p = ((read px :: Float),(read py :: Float))
          n1<- prompt "Type how many pairs of circles: "
          n2<- prompt "Type the amount of rects per pair of circle "
          n3<- prompt "Type the proportion of the radius of the smallest circle: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase5  (read n1 :: Int) (read n2 :: Int) (read n3 :: Float) p ++ svgEnd
      x | x == '6' -> do
          putStr "This case some time to build so watch out for the maximum iteration\n"
          n1<- prompt "Type the magnification factor: "
          n2<- prompt "Type the maximum interation: "
          r<- prompt "Type the value of the r in RGB: "
          g<- prompt "Type the value of the g in RGB: "
          b<- prompt "Type the value of the b in RGB: "
          writeFile "caseX.svg" $ svgBegin w h ++ genCase6 (read n1 :: Int)  (read n1 :: Int) ((read n1 :: Int),(read n1 :: Int),(read n1 :: Int)) ++ svgEnd
