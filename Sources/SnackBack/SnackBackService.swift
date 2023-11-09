import Pigeon
import SnackBackModels

public enum SnackBackError: Error {

}

public protocol SnackBackServicing {
  func submit(feedback: FeedbackContent) async throws
}

public final class SnackBackService: Service, SnackBackServicing {

  public let key: String

  public init(key: String) {
    self.key = key

    super.init(host: "")

    self.contentType = .json
  }

  public func submit(feedback: FeedbackContent) async throws {
    let content = try encoder.encode(feedback)

    try await request(.post, path: "send_feedback", body: content)
  }

  public override func defaultHeaders() -> [HTTPHeader] {
    var headers = super.defaultHeaders()
    // add api key
    return headers
  }

}
