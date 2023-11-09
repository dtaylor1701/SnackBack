import SnackBackModels

open class SnackBackServiceFake: SnackBackServicing {
  public var error: SnackBackError?

  public func submit(feedback: FeedbackContent) async throws {
    if let error {
      throw error
    }
  }
}
