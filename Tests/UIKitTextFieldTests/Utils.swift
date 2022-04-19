import XCTest

extension XCTestCase {
  func wait(for time: TimeInterval) {
    RunLoop.current.run(until: Date() + time)
  }
}
