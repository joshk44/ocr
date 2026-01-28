import SwiftUI
import FoundationModels

struct ChatBotAI: View {
    @State private var inputText: String = ""
    @State private var session = LanguageModelSession()
    @State private var streaming: String = ""
    
    var body: some View {
        NavigationStack {
            ChatTranscriptView(
                transcript: Array(session.transcript),
                streamingText: streaming
            )
            .navigationTitle("AI Chat")
            .toolbar {
                Button("Reset", systemImage: "arrow.clockwise") {
                    session = LanguageModelSession()
                }
            }
            .safeAreaInset(edge: .bottom) {
                ChatInputView(inputText: $inputText) {
                    sendMessage()
                }
            }
        }
    }
    
    private func sendMessage() {
        Task {
            do {
                let inputValue = inputText
                inputText.removeAll()
                try await session.respond(to: inputValue)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ChatBotAI()
}
