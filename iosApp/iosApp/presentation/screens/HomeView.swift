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
    
    private func formatMillisToDateString(_ millis: Int64, localeIdentifier: String = "es_ES", dateFormat: String = "dd/MM/yyyy HH:mm") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(millis) / 1000.0)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.timeZone = .current
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
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

