module Main where

import Text.ParserCombinators.Parsec
import Control.Applicative hiding (many, optional, (<|>))

program = endBy1 statement eol
statement =     commentLiteral
--            <|> definitionLiteral
--            <|> lambdaLiteral
            <|> stringLiteral
            <|> charLiteral
            <|> number
            <?> "statement"

commentLiteral =     try docCommentLiteral
                 <|>     plainCommentLiteral

docCommentLiteral =
   do string ";;"
      content <- many commentLiteralChar
      return ("comment.doc", content)

plainCommentLiteral =
   do char ';'
      content <- many commentLiteralChar
      return ("comment.plain", content)

{--
definitionLiteral =
   do name <- identifierLiteral
      char ':'
      _ <- whitespace
      value <- statement
      return ("define", ...)
--}

{--
lambdaLiteral =
   do char '['
      args <- argListLiteral
      _ <- whitespace
      string '->'
      _ <- whitespace
      contents <- many statement
      _ <- whitespace
      char ']'
      return ("lambda", ...)
--}

{--
argListLiteral = many argLiteral

argLiteral =
   do value <- many argLiteralChars
      _ <- whitespace
      return value

argLiteralChars = -- any character except whitespace or [ ] ( ) { } " ' \ ; : `
--}

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

number =     negativeNumber
         <|> positiveNumber

positiveNumber =     try octalNumber
                 <|> try hexNumber
                 <|> try binNumber
                 <|> try floatNumber
                 <|>     decimalNumber

negativeNumber =
   do char '-'
      (t, v) <- positiveNumber
      return (t, "-" ++ v)

floatNumber =
   do start <- decDigits
      char '.'
      end  <- decDigits
      return ("number.float", start ++ "." ++ end)

decimalNumber =
   do content <- decDigits
      return ("number.decimal", content)

octalNumber =
   do string "0c"
      content <- octDigits
      return ("number.octal", "0c" ++ content)

hexNumber =
   do string "0x"
      content <- hexDigits
      return ("number.hex", "0x" ++ content)

binNumber =
   do string "0b"
      content <- binDigits
      return ("number.binary", "0b" ++ content)

decDigits = many1 digit
octDigits = many1 octDigit
hexDigits = many1 hexDigit
binDigits = many1 binDigit
binDigit = char '0' <|> char '1'

-- Handle escaped "s and 's
stringLiteralChar = noneOf "\""
charLiteralChar   = noneOf "'"

commentLiteralChar = noneOf "\r\n"

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
