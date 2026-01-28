import SwiftUI
import FoundationModels

struct ChatTranscriptView: View {
    let transcript: [Transcript.Entry]
    let streamingText: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(transcript) { entry in
                        switch entry {
                        case .prompt(let prompt):
                            ChatBubbleView(
                                text: segmentsToString(segments: prompt.segments),
                                actor: .user
                            )
                        case .response(let response):
                            if streamingText.isEmpty {
                                ChatBubbleView(
                                    text: segmentsToString(segments: response.segments),
                                    actor: .ai
                                )
                            }
                        default:
                            EmptyView()
                        }
                    }
                    
                    if !streamingText.isEmpty {
                        ChatBubbleView(text: streamingText, actor: .ai)
                    }
                    
                    // Bottom anchor to scroll to
                    Color.clear
                        .frame(height: 1)
                        .id("BOTTOM")
                }
            }
            .onChange(of: transcript) { _, _ in
                withAnimation {
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                }
            }
        }
    }
}

#Preview {
    ChatTranscriptView(
        transcript: [],
        streamingText: "This is a streaming response..."
    )
}
