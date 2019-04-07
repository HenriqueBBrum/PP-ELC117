import Text.Printf

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
greenToblue n = [(0,g,b) |  g<-[255,255-(255 `div` n)..0], b<-[0,(255 `div` n)..255], b == abs(g-255)]

blueToRed :: Int -> [(Int,Int,Int)]
blueToRed 0 = [(0,0,0)]
blueToRed n = [(r,0,b) | r<-[0,(255 `div` n)..255], b<-[255,255-(255`div` n)..0], r == abs(b-255)]

redToGreen :: Int -> [(Int,Int,Int)]
redToGreen 0 = [(0,0,0)]
redToGreen n = [(r,g,0) | r<-[255,255-(255`div` n)..0], g<-[0,(255 `div` n)..255],g == abs(r-255)]


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
        fstY = 50.0

genNCirclesLines :: Int -> Int -> Float -> Float ->[Circle]
genNCirclesLines nline i y r
    | nline == 0 = []
    |otherwise = concat(genCircleLine i y r) ++ genNCirclesLines (nline-1) i (y+4*r) r

genCircleLine :: Int -> Float -> Float -> [[Circle]]
genCircleLine i y r = [createCirclesTriangularForm (m*4*r) y r | m <- [10..10+fromIntegral (i-1)]]


createCirclesTriangularForm :: Float -> Float -> Float -> [Circle]
createCirclesTriangularForm  x y r = [((x,y-(r-r/3)),r)]++[((x+(r-r/3),y+r/3),r)]++[((x-r+r/3,y+r/3),r)]


-------------------------------------------------------------------------------
-- Gera��o de circulos em linha curvilínea
-------------------------------------------------------------------------------


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
genCase1::String
genCase1 = svgElements svgRect rects (map svgStyle palette)
  where rects = genAllRects nrects nrectperline
        palette = completeGreenPalette nrects nrectperline
        nrects = 6
        nrectperline  = 10

genCase2::String
genCase2 = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInCircleFormation ncircles ((300.0,200.0), 100.0)
        palette = rgbPalette2 ncircles
        ncircles = 50

genCase3 :: String
genCase3 = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInTiangularFormation ncirclescomb 10 r
        palette = rgbPalette (3*ncirclescomb)
        ncirclescomb = 101
        r = 10.0

genCase4::String
genCase4 = svgElements svgCircle circles (map svgStyle palette)
  where circles = genCirclesInCircleFormation ncircles ((300.0,200.0), 100.0)
        palette = rgbPalette2 ncircles
        ncircles = 50




main :: IO ()
main = do
  writeFile "caseX.svg" $ svgString
  where svgString = svgBegin w h ++ genCase3 ++ svgEnd
        (w,h) = (1500, 1000)
