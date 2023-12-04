public extension Array where Element: AdditiveArithmetic {
  func sum() -> Element {
    reduce(Element.zero, +)
  }
}
