import SwiftUI
import Foundation
import FoundationModels
import shared

struct BottomSheetStory: View {
    var words: String = ""
    var onStoryCreated: ((String) -> Void)? = nil
    @State private var story: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var mainViewModel: OCRSessionListViewModel! = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Story")
                    .font(.headline)
                if isLoading {
                    ProgressView( "Generating story...")
                } else if let errorMessage {
                    Text(String(format: "Error", errorMessage))
                        .foregroundColor(.red)
                } else if !story.isEmpty {
                    Text(story)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text( "No story available. Try again.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .task {
            await generateStoryIfNeeded()
        }
        .padding()
    }
    
    @MainActor
    private func generateStoryIfNeeded() async {
        guard !isLoading, story.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        do {
            let session = LanguageModelSession()
            
            let prompt = "Generate an adventure story with these words: \(words)"
            let stream = session.streamResponse(to: prompt)
            isLoading = false
            for try await chunk in stream {
                self.story = chunk.content
       
            }
            if let onStoryCreated {
                onStoryCreated(self.story)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
