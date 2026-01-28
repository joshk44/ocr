import SwiftUI

struct ChatBubbleView: View {
    let text: String
    let actor: MessageActor
    
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

#Preview {
    VStack(spacing: 16) {
        ChatBubbleView(text: "Hello! How can I help you?", actor: .ai)
        ChatBubbleView(text: "I need help with my code", actor: .user)
    }
    .padding()
}
