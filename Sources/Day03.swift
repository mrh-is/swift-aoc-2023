import Foundation

struct Day03: AdventDay {
  var schematic: Schematic

  init(data: String) {
    schematic = Schematic(data: data)
  }

  struct Schematic {
    private let lines: [String]

    init(data: String) {
      lines = data.components(separatedBy: "\n")
    }

    private subscript(row: Int, column: Int) -> Character? {
      guard row >= 0 && row < lines.count else {
        return nil
      }
      let line = lines[row]
      guard column >= 0 && column < line.count else {
        return nil
      }
      return line[line.index(line.startIndex, offsetBy: column)]
    }

    private func isSymbol(_ character: Character) -> Bool {
      !(character.isNumber || character == ".")
    }

    private func isCharacterSymbol(at row: Int, _ column: Int) -> Bool {
      guard let character = self[row, column] else {
        return false
      }
      return isSymbol(character)
    }

    private func checkForSymbolAround(row: Int, columnRange: Range<Int>) -> Bool {
      /*
       Search the perimeter in this order:
       .13579.
       .BnnnC.
       .2468A.
       */
      let extendedColumnRange = (columnRange.lowerBound - 1)..<(columnRange.upperBound + 1)
      for column in extendedColumnRange {
        if isCharacterSymbol(at: row - 1, column)
            || isCharacterSymbol(at: row + 1, column) {
          return true
        }
      }
      if isCharacterSymbol(at: row, extendedColumnRange.lowerBound)
          || isCharacterSymbol(at: row, columnRange.upperBound) {
        return true
      }
      return false
    }

    // Scan each line for numbers (= groups of digits)
    // When you find one, check the perimeter for "symbols" (= non-digit && non-period)
    // If yes, add to total
    func partNumbers() -> [Int] {
      lines.enumerated().flatMap { (row, line) in
        line.rangesAndColumnRanges(of: /\d+/).filter { (_, columnRange) in
          checkForSymbolAround(row: row, columnRange: columnRange)
        }.map { (range, _) in
          Int(line[range])!
        }
      }
    }

    private func findNumbersSurrounding(_ row: Int, _ column: Int) -> [Int] {
      row.surroundingRange().clamped(to: 0...(lines.count - 1))
        .flatMap { checkRow in
          let line = lines[checkRow]
          let numberRanges = line.rangesAndColumnRanges(of: /\d+/)
          return numberRanges.filter { (_, columnRange) in
            columnRange.overlaps(column.surroundingRange())
          }.map { (range, _) in
            Int(line[range])!
          }
        }
    }

    // Scan each line for *s
    // When you find one, check for the perimeter for numbers
    // - Find number ranges in lines above/same/below
    // - See how many intersect with surrounding columns
    // If 2 numbers, multiply
    func gearRatios() -> [Int] {
      lines.enumerated().flatMap { (row, line) in
        line.columnRanges(of: /\*/).flatMap { range in
          range.compactMap { column -> Int? in
            let surroundingNumbers = findNumbersSurrounding(row, column)
            guard surroundingNumbers.count == 2 else {
              return nil
            }
            return surroundingNumbers[0] * surroundingNumbers[1]
          }
        }
      }
    }
  }

  // Scan each line for numbers (= groups of digits)
  // When you find one, check the perimeter for "symbols" (= non-digit && non-period)
  // If yes, add to total

  func part1() -> Any {
    return schematic.partNumbers().sum()
  }

  func part2() -> Any {
    return schematic.gearRatios().sum()
  }
}

private extension String {
  func columnRanges(of regex: some RegexComponent) -> [Range<Int>] {
    rangesAndColumnRanges(of: regex).map { $0.1 }
  }

  func rangesAndColumnRanges(of regex: some RegexComponent)
  -> [(Range<Self.Index>, Range<Int>)] {
    let ranges = ranges(of: regex)
    return ranges.map { range in
      (
        range,
        distance(from: startIndex, to: range.lowerBound)..<distance(from: startIndex, to: range.upperBound)
       )
    }
  }
}

private extension Int {
  func surroundingRange(distance: Int = 1) -> ClosedRange<Int> {
    return (self - distance)...(self + distance)
  }
}
