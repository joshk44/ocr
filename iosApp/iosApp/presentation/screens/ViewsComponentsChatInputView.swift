import SwiftUI

struct ChatInputView: View {
    @Binding var inputText: String
    let onSend: () -> Void
    
    var body: some View {
        GlassEffectContainer(spacing: 2.0) {
            HStack {
                TextField("Let's talk", text: $inputText)
                    .padding()
                    .glassEffect()
                
                Button("Send", systemImage: "paperplane") {
                    onSend()
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

#Preview {
    @Previewable @State var text = ""
    
    ChatInputView(inputText: $text) {
        print("Send tapped")
    }
}
