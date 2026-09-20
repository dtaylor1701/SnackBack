import Foundation
import SnackBackModels

open class SnackBackServiceFake: SnackBackServicing, @unchecked Sendable {
  private let lock = NSLock()
  private var _error: SnackBackError?
  private var _submittedFeedback: [FeedbackContent] = []

  public var error: SnackBackError? {
    get {
      lock.lock()
      defer { lock.unlock() }
      return _error
    }
    set {
      lock.lock()
      defer { lock.unlock() }
      _error = newValue
    }
  }

  public var submittedFeedback: [FeedbackContent] {
    lock.lock()
    defer { lock.unlock() }
    return _submittedFeedback
  }

  public init(error: SnackBackError? = nil) {
    self._error = error
  }

  private func record(_ feedback: FeedbackContent) -> SnackBackError? {
    lock.lock()
    defer { lock.unlock() }
    _submittedFeedback.append(feedback)
    return _error
  }

  public func submit(feedback: FeedbackContent) async throws {
    if let err = record(feedback) {
      throw err
    }
  }
}
