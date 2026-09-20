import SnackBackModels
import SwiftUI

@MainActor
public class FeedbackViewModel: ObservableObject {
  @Published public var message: String = ""
  @Published public var isSubmitting: Bool = false
  @Published public var showSuccess: Bool = false
  @Published public var errorMessage: String? = nil

  private let service: SnackBackServicing

  public init(service: SnackBackServicing) {
    self.service = service
  }

  @MainActor
  public func submit() async {
    isSubmitting = true
    errorMessage = nil

    do {
      let content = FeedbackContent(message: message)
      try await service.submit(feedback: content)
      showSuccess = true
      message = ""
    } catch SnackBackError.emptyMessage {
      errorMessage = "Please enter a message before submitting."
    } catch {
      errorMessage = "Failed to submit feedback. Please try again later."
    }

    isSubmitting = false
  }
}

public struct FeedbackView: View {
  @StateObject private var model: FeedbackViewModel

  public init(model: FeedbackViewModel) {
    _model = StateObject(wrappedValue: model)
  }

  public var body: some View {
    Form {
      Section {
        if #available(iOS 16.0, macOS 13.0, *) {
          TextEditor(text: $model.message)
            .frame(minHeight: 100)
            .scrollContentBackground(.hidden)
        } else {
          TextEditor(text: $model.message)
            .frame(minHeight: 100)
        }
      } header: {
        Text("Let us know what you think")
      } footer: {
        if let error = model.errorMessage {
          Text(error)
            .foregroundColor(.red)
        }
      }

      Section {
        Button(action: {
          Task {
            await model.submit()
          }
        }) {
          HStack {
            Spacer()
            if model.isSubmitting {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            } else {
              Text("Submit Feedback")
            }
            Spacer()
          }
        }
        .disabled(model.isSubmitting || model.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
      }
    }
    .alert(isPresented: $model.showSuccess) {
      Alert(
        title: Text("Thank You"),
        message: Text("Your feedback has been submitted successfully."),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}
