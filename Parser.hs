module Main where

import Text.ParserCombinators.Parsec
import Control.Applicative hiding (many, optional, (<|>))

program = endBy1 statement eol
statement =     commentLiteral
--            <|> definitionLiteral
            <|> lambdaLiteral
            <|> stringLiteral
            <|> charLiteral
            <|> number
            <?> "statement"

commentLiteral =     try docCommentLiteral
                 <|>     plainCommentLiteral

docCommentLiteral =
   do string ";;"
      content <- many1 commentLiteralChar
      return ("comment.doc", content)

plainCommentLiteral =
   do char ';'
      content <- many1 commentLiteralChar
      return ("comment.plain", content)

definitionLiteral =
   do name <- identifierLiteral
      char ':'
      _ <- whitespace
      value <- statement
      return ("define", "...")


identifierLiteral =
  do start <- identifierStartLiteralChar
     rest  <- many1 identifierLiteralChar
     string ([start] ++ rest)

identifierStartLiteralChar = oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-=./<>?~!@#$%^&*()_+|"
identifierLiteralChar      = oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=./<>?~!@#$%^&*()_+|"

lambdaLiteral =
   do char '['
--      args <- argListLiteral
      _ <- whitespace
      string "->"
      _ <- whitespace
      contents <- many1 statement
      _ <- whitespace
      char ']'
      return ("lambda", "...")

argListLiteral = many identifierLiteral --argLiteral

argLiteral =
   do value <- identifierLiteral
      _ <- whitespace
      return value

--argLiteralChar = noneOf " \t [](){}\"'\\;:`" -- any character except whitespace or [ ] ( ) { } " ' \ ; : `
--argLiteralChar = oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=./<>?~!@#$%^&*()_+|"

stringLiteral =
   do char '"'
      content <- many1 stringLiteralChar
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
binDigit  = char '0' <|> char '1'

-- TODO: Handle escaped "s and 's
stringLiteralChar = noneOf "\""
charLiteralChar   = noneOf "'"

commentLiteralChar = noneOf "\r\n"

-- This probably should be whitespaceLiteral, but this is nicer imo
whitespace            = many whitespaceCharLiteral
whitespaceCharLiteral =   try space
                      <|> try tab

eol =   try (string "\n\r")
    <|> try (string "\r\n")
    <|> try (string "\n")
    <|>      string "\r"
    <?> "end of line"


--parseCoere :: String -> Either ParseError String
parseCoere input = parse program "(unknown)" input

main =
    do c <- getContents
       case parse program "(stdin)" c of
            Left e -> do putStrLn "Error parsing input:"
                         print e
            Right r -> mapM_ print r
