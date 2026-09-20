import Foundation
import Pigeon
import SnackBackModels

public enum SnackBackError: Error {
  case emptyMessage
  case networkFailure(Error)
  case serverError(statusCode: Int)
}

public protocol SnackBackServicing: Sendable {
  func submit(feedback: FeedbackContent) async throws
}

public final class SnackBackService: Service, SnackBackServicing, @unchecked Sendable {

  public let key: String

  public init(key: String, baseURL: URL) {
    self.key = key

    super.init(host: baseURL.absoluteString)

    self.contentType = .json
  }

  public func submit(feedback: FeedbackContent) async throws {
    guard !feedback.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      throw SnackBackError.emptyMessage
    }

    let requestPayload = FeedbackRequest(content: feedback)
    
    do {
      let content = try encoder.encode(requestPayload)
      _ = try await request(.post, path: "send_feedback", body: content)
    } catch let error as URLError {
      throw SnackBackError.networkFailure(error)
    } catch {
      // Need to handle Pigeon error structure if any, otherwise wrap generic error.
      // Depending on how Pigeon surfaces errors, we might want to check for HTTP status code.
      throw error
    }
  }

  public override func defaultHeaders() -> [HTTPHeader] {
    var headers = super.defaultHeaders()
    headers.append(HTTPHeader(field: "X-API-Key", value: key))
    return headers
  }

}
