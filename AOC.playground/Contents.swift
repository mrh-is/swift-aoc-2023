import RegexBuilder

let whitespace = OneOrMore(.whitespace)
let number = OneOrMore(.digit)
let numberList = OneOrMore {
  number
  ZeroOrMore(" ")
}
let regex = Regex {
  "Card"
  whitespace
  number
  ":"
  whitespace

  Capture { numberList }
  whitespace
  "|"
  whitespace
  Capture { numberList }
}

let line = "Card   1: 79  1  6  9 88 95 84 69 83 97 | 42 95  1  6 71 69 61 99 84 12 32 96  9 82 88 97 53 24 28 65 83 38  8 68 79"
line.matches(of: regex)
let (_, winningNumbersString, participantNumbersString) = line.matches(of: regex).first!.output
print(winningNumbersString)
print(winningNumbersString.split(separator: " ").map { Int($0)! })
print(participantNumbersString)
print(participantNumbersString.split(separator: " ").map { Int($0)! })
