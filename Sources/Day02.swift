struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var lines: [any StringProtocol] {
    data.split(separator: "\n")
  }

  struct Game {
    struct CubeSet {
      let blue: Int
      let green: Int
      let red: Int

      var power: Int {
        blue * green * red
      }
    }

    let id: Int
    let cubeSets: [CubeSet]
  }

  func parseGame(line: any StringProtocol) -> Game {
    func parseCubeSet(line: any StringProtocol) -> Game.CubeSet {
      var colorCounts = (blue: 0, green: 0, red: 0)
      let colorStrings = line.components(separatedBy: ", ")
      for colorString in colorStrings {
        if colorString.contains("blue") {
          colorCounts.blue = Int(colorString.dropLast(5))!
        } else if colorString.contains("green") {
          colorCounts.green = Int(colorString.dropLast(6))!
        } else if colorString.contains("red") {
          colorCounts.red = Int(colorString.dropLast(4))!
        }
      }
      return Game.CubeSet(blue: colorCounts.blue, green: colorCounts.green, red: colorCounts.red)
    }

    let halves = String(line).components(separatedBy: ": ")
    let id = Int(halves.first!.dropFirst(5))!
    let cubeSets = halves.last!.components(separatedBy: "; ")
      .map(parseCubeSet)
    return Game(id: id, cubeSets: cubeSets)
  }

  func checkPossibility(of game: Game, with bag: Game.CubeSet) -> Bool {
    for cubeSet in game.cubeSets {
      if cubeSet.blue > bag.blue || cubeSet.green > bag.green || cubeSet.red > bag.red {
        return false
      }
    }
    return true
  }

  func part1() -> Any {
    let bag = Game.CubeSet(blue: 14, green: 13, red: 12)
    return lines.map(parseGame)
      .filter { checkPossibility(of: $0, with: bag) }
      .map(\.id)
      .reduce(0, +)
  }

  func calculateMinimalCubeSet(_ game: Game) -> Game.CubeSet {
    var minimumColorCounts = (blue: 0, green: 0, red: 0)
    for cubeSet in game.cubeSets {
      minimumColorCounts.blue = max(minimumColorCounts.blue, cubeSet.blue)
      minimumColorCounts.green = max(minimumColorCounts.green, cubeSet.green)
      minimumColorCounts.red = max(minimumColorCounts.red, cubeSet.red)
    }
    return Game.CubeSet(blue: minimumColorCounts.blue, green: minimumColorCounts.green, red: minimumColorCounts.red)
  }

  func part2() -> Any {
    return lines.map(parseGame)
      .map(calculateMinimalCubeSet)
      .map(\.power)
      .reduce(0, +)
  }
}
