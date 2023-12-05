import RegexBuilder

struct Day04: AdventDay {
  let cards: [Card]

  init(data: String) {
    cards = data.components(separatedBy: "\n")
      .filter { !$0.isEmpty }
      .map(Card.init(line:))
  }

  struct Card {
    let winningNumbers: [Int]
    let participantNumbers: [Int]

    init(line: String) {
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

      let (_, winningNumbersString, participantNumbersString) = line.matches(of: regex).first!.output
      winningNumbers = winningNumbersString.split(separator: " ").map { Int($0)! }
      participantNumbers = participantNumbersString.split(separator: " ").map { Int($0)! }
    }

    func matchCount() -> Int {
      Set(winningNumbers).intersection(participantNumbers).count
    }

    func points() -> Int {
      let matchCount = matchCount()
      if matchCount == 0 {
        return 0
      } else {
        return 2 << (matchCount - 2)
      }
    }
  }

  func part1() -> Any {
    return cards.map { $0.points() }.sum()
  }

  // [1, 1, 1, 1, 1]
  // For each card:
  // - Pop first number as cardCount (and replace with 1 at the back)
  // - Add cardCount to running total
  // - Calculate number of matches
  // - For each match, +cardCount another deque value
  // Return cardCount total

  func part2() -> Any {
    var upcomingCardCounts = Deque<Int>()
    var cardCountTotal = 0
    for card in cards {
      let cardCount = upcomingCardCounts.popFirst() ?? 1
      cardCountTotal += cardCount

      let matchCount = card.matchCount()
      if upcomingCardCounts.count < matchCount {
        upcomingCardCounts.append(contentsOf: [Int](repeating: 1, count: matchCount - upcomingCardCounts.count))
      }
      for index in 0..<matchCount {
        upcomingCardCounts[index] += cardCount
      }
    }
    return cardCountTotal
  }
}
