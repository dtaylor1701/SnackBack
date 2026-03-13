import SnackBack
import SnackBackModels
import SwiftUI

struct ContentView: View {
  @State
  var presenting: Bool = false

  var body: some View {
    Button {
      presenting = true
    } label: {
      Text("Show")
    }
    .sheet(
      isPresented: $presenting,
      content: {
        Feedback(key: "test")
      })
  }
}

struct Feedback: View {
  @State
  private var message: String = ""

  @State
  private var submitting: Bool = false

  @Environment(\.dismiss)
  private var dismiss

  private var feedback: FeedbackContent? {
    guard !message.isEmpty else { return nil }

    return FeedbackContent(message: message)
  }

  private let service: SnackBackServicing

  public init(key: String) {
    self.init(service: SnackBackService(key: key))
  }

  public init(service: SnackBackServicing) {
    self.service = service
  }

  @ViewBuilder
  var form: some View {
    NavigationView {
      Form {
        Section {
          TextField(text: $message) {
            Text("Let us know what you think")
          }
        }
        Section {
          Button {
            guard let feedback else { return }

            Task {
              submitting = true
              try? await service.submit(feedback: feedback)
              submitting = false
              dismiss()
            }
          } label: {
            Text("Submit")
          }
          .disabled(feedback == nil)
        }
      }
      .navigationTitle("Submit Feedback")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button {
            dismiss()
          } label: {
            Text("Cancel")
          }
        }
      }
    }
  }

  var body: some View {
    ZStack {
      form
        .disabled(submitting)
      if submitting {
        ProgressView()
      }
    }
  }
}
