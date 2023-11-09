import SnackBackModels
import SwiftUI

public struct FeedbackViewModel {

}

public struct FeedbackView: View {
  @State
  var message: String = ""

  init(model: FeedbackViewModel) {

  }

  public var body: some View {
    Form {
      TextField(text: $message) {
        Text("Let us know what you think")
      }
    }
  }
}
