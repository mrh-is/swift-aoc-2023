import Foundation

let numberWords = [
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
]

func numbersInLine(line: any StringProtocol) -> [Int] {
  var results = [Int]()
  for offset in 0..<line.count {
    let index = line.index(line.startIndex, offsetBy: offset)

    // Check for digits
    if line[index].isNumber {
      results.append(line[index].wholeNumberValue!)
      continue
    }

    for lookbackCount in 3...5 {
      guard offset >= lookbackCount-1 else {
        continue
      }
      let startIndex = line.index(index, offsetBy: 1-lookbackCount)
      let substring = line[startIndex...index]
      // Compiler won't let me do this on the above line ¯\_(ツ)_/¯
      let stringyString = String(substring)
      if let value = numberWords[stringyString] {
        results.append(value)
      }
    }
  }
  return results
}

let testData2 = """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """

for line in testData2.split(separator: "\n") {
  print(line)
  print(numbersInLine(line: line))
}
