import SwiftUI
import shared
import Foundation
import Playgrounds
import FoundationModels

struct HomeView: View {
    let mainViewModel: OCRSessionListViewModel!
    
    @State var isShowingCamera = false
    @State var isPresentingStory = false
    @State var capturedImage: UIImage?
    @State var processingOCR = false
    @State var ocrResult: String = ""
    
    
    var body: some View {
        VStack {
            if capturedImage != nil {
                
                if processingOCR {
                    ProgressView( "OCR Processing...")
                    
                } else if !ocrResult.isEmpty {
                    Text( "OCR Results")
                        .font(.title)
                    Text(ocrResult)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .foregroundColor(Color.primary)
                        .background(
                            .ultraThinMaterial.opacity(0.5),
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                        )
                }
                
                HStack {
                    Button( "Scan Again") {
                        isShowingCamera = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button( "Create Story"){
                        isPresentingStory = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                
            } else {
                Text( "OCR Scanner")
                    .font(.largeTitle)
                    .padding()
                Button {
                    isShowingCamera = true
                } label: {
                    HStack {
                        Image(systemName: "Camera")
                        Text( "Launch Camera")
                    }.padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera ) {
            CameraView(isShown: $isShowingCamera, image: $capturedImage, onImageCaptured: processOCR)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $isPresentingStory) {
            BottomSheetStory(words: ocrResult, onStoryCreated: { story in
                let nowMillis = Int64(Date().timeIntervalSince1970 * 1000)
                mainViewModel.addSession(
                    ocrSession: OCRSession(
                        id: 0,
                        dateTime: nowMillis,
                        values: story
                    )
                )
            })
            .presentationDetents([.fraction(0.5), .large])
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(25)
            .presentationDragIndicator(.hidden)
            
        }
        .padding()
        .background(
            Image("Image")
                .scaledToFill()
                .ignoresSafeArea()
                .backgroundExtensionEffectIfAvailable()
                .blur(radius: 10.0))
    }
    
    
    func processOCR(image: UIImage) {
        processingOCR = true
        
        Task {
            do {
                let lines = try await recognizeTextAsync(in: image, languages: ["es-ES", "en-US"])
                ocrResult = lines.joined(separator: "\n")
                processingOCR = false
            } catch {
                print("Error OCR:", error)
                processingOCR = false
            }
        }
    }
}


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
                if let onStoryCreated {
                    onStoryCreated(self.story)
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}


#Preview("Empty State") {
    HomeView(
        mainViewModel: nil,
        isShowingCamera: false,
        capturedImage: UIImage(systemName: "doc.text.viewfinder"),
        processingOCR: false,
        ocrResult: "This is a princess in a cage",
    )
}
/*
#Playground{
    
    let words = "Simona la cocalisa"
    
    let session = LanguageModelSession()
    let response = try await session.respond(
        to: "Generate a short adventure story with these words: \(words)"
    )
}
*/

#Playground {
    let session = LanguageModelSession()

    var responseTextResult: String = ""

        let stream: LanguageModelSession.ResponseStream<String> = session.streamResponse(to: "Generate a story")

        for try await chunk in stream {
            responseTextResult.append(chunk.content)
            print("Chunk:", chunk)
        }

        print("Full response:", responseTextResult)
    
}
