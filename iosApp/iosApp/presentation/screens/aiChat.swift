import SwiftUI
import FoundationModels

struct aiChat: View {
    @State private var inputText: String = ""
    
    @State private var session = LanguageModelSession()
    
    @State private var streaming: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(session.transcript) { entry in
                            switch entry {
                            case .prompt(let prompt):
                                chatBubble(text: segmentsToString(segments:  prompt.segments), actor: .user)
                            case .response(let response):
                                if (self.streaming.isEmpty) {
                                    chatBubble(text: segmentsToString(segments:  response.segments), actor: .ai)
                                }
                            default : EmptyView()
                            }
                        }
                        if !self.streaming.isEmpty {
                            chatBubble (text: self.streaming, actor: .ai)
                        }
                        // Bottom anchor to scroll to
                        Color.clear
                            .frame(height: 1)
                            .id("BOTTOM")
                    }
                }
                .onChange(of: session.transcript) { _, _ in
                    withAnimation {
                        proxy.scrollTo("BOTTOM", anchor: .bottom)
                    }
                }
            }
            .navigationTitle("AI Chat")
            .toolbar{
                Button("Reset", systemImage: "arrow.clockwise"){
                    session = LanguageModelSession()
                }
            }
            .safeAreaInset (edge: .bottom){
                HStack {
                    TextField ("Let's talk", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button ("Send", systemImage: "paperplane") {
                        Task{
                            do {
                                try await session.respond(to: inputText)
                                inputText.removeAll()
                            }catch {
                                print(error)
                            }
                        }
                    }
                    .foregroundColor(.blue)
                    .labelStyle(.iconOnly)
                    .padding()
                    .glassEffect()
                }
                .padding()
            }
        }
    }
}

#Preview {
    aiChat()
}

func segmentsToString(segments: [Transcript.Segment]) -> String {
    let strings = segments.compactMap { segment -> String? in
        if case let .text(textSegment) = segment {
            return textSegment.content
        }
        return nil
    }
    return strings.reduce("", +)
}

struct chatBubble: View {
    
    let text: String
    let actor: Actor
    
    var body: some View {
        Text(text)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary, lineWidth: 1)
            }
            .frame(maxWidth: .infinity, alignment: actor == .ai ? .leading : .trailing)
            .padding(.horizontal)
    }
}

enum Actor {
    case user
    case ai
}
