import SwiftUI
import SnackBack
import SnackBackModels

struct ContentView: View {
    @State
    var message: String = ""
    
    let service: SnackBackServicing
    
    init(key: String) {
        self.service = SnackBackService(key: key)
    }
    
    var feedback: FeedbackContent {
        FeedbackContent(message: message)
    }
    
    var body: some View {
        Form {
            Section {
                 
                TextField(text: $message) {
                    Text("Let us know what you think")
                }   
            }
            Section {
                Button {
//                    service.submit(feedback: FeedbackContent(message: message))
                } label: {
                    Text("Submit")
                }    
            }
            
        }
    }
}
