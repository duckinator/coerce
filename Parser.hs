module Main where

--import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec hiding (many, optional, (<|>))
import Control.Applicative

program = endBy1 statement eol
statement =     stringLiteral
            <|> charLiteral
            <|> number
            <?> "statement"

stringLiteral =
   do char '"'
      content <- many stringLiteralChar
      char '"'
      return ("string", content)

charLiteral =
   do char '\''
      content <- charLiteralChar
      char '\''
      return ("char", [content])

number =     try octalNumber
         <|> try hexNumber
         <|> try binNumber
         <|> try decimalNegFloat
         <|> try decimalFloat
         <|> try decimalNegNumber
         <|>     decimalNumber

decimalNegFloat =
   do char '-'
      start <- decDigits
      char '.'
      end  <- decDigits
      return ("number.float", "-" ++ start ++ "." ++ end)

decimalFloat =
   do start <- decDigits
      char '.'
      end  <- decDigits
      return ("number.float", start ++ "." ++ end)

decimalNegNumber =
   do char '-'
      content <- decDigits
      return ("number.decimal", "-" ++ content)

decimalNumber =
   do content <- decDigits
      return ("number.decimal", content)

octalNumber =
   do string "0c"
      content <- octDigits
      return ("number.octal", content)

hexNumber =
   do string "0x"
      content <- hexDigits
      return ("number.hex", content)

binNumber =
   do string "0b"
      content <- binDigits
      return ("number.binary", content)

decDigits = many1 digit
octDigits = many1 octDigit
hexDigits = many1 hexDigit
binDigits = many1 binDigit
binDigit = char '0' <|> char '1'

-- Handle escaped "s and 's
stringLiteralChar = 	noneOf "\""
charLiteralChar = noneOf "'"

eol =   try (string "\n\r")
    <|> try (string "\r\n")
    <|> string "\n"
    <|> string "\r"
    <?> "end of line"


--parseCoere :: String -> Either ParseError String
parseCoere input = parse program "(unknown)" input

main =
    do c <- getContents
       case parse program "(stdin)" c of
            Left e -> do putStrLn "Error parsing input:"
                         print e
            Right r -> mapM_ print r
