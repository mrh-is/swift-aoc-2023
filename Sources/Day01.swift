import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var lines: [any StringProtocol] {
    data.split(separator: "\n")
  }

  var valuesFromDigits: [Int] {
    lines.map { line in
      Int("\(line.first(where: { $0.isNumber })!)\(line.last(where: { $0.isNumber })!)")!
    }
  }

  func part1() -> Any {
    valuesFromDigits.reduce(0, +)
  }

  var valuesFromWordsOrDigits: [Int] {
    lines.map { line in
      let values = findWordsOrDigitsFromLine(line: line)
      return values.first! * 10 + values.last!
    }
  }

  private static let numberWords = [
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

  func findWordsOrDigitsFromLine(line: any StringProtocol) -> [Int] {
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
        if let value = Self.numberWords[stringyString] {
          results.append(value)
        }
      }
    }
    return results
  }

  func part2() -> Any {
    valuesFromWordsOrDigits.reduce(0, +)
  }
}
