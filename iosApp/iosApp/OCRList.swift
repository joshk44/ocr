import SwiftUI
import shared
import Foundation

struct OCRList: View {
    var mainViewModel: OCRSessionListViewModel
    
    var body: some View {
        VStack {
            Observing(self.mainViewModel.ocrSessionList) { homeUIState in
                ScrollView {
                    LazyVStack {
                        ForEach(homeUIState.ocrSessionList, id: \.self) { value in
                            OCRView(session: value).frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
    }
}

struct OCRView: View {
    var session: OCRSession
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .opacity(0.3)
                VStack {
                    Text("\(session.dateTime)")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(session.values)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
            }.padding([.leading, .trailing])
        }
    }
}


struct HomeView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    @State private var processingOCR = false
    @State private var ocrResult: String = ""

    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()

                if processingOCR {
                    ProgressView("Processing OCR...")
                } else if !ocrResult.isEmpty {
                    Text("OCR Result:")
                        .font(.headline)
                    Text(ocrResult)
                        .padding()
                }

                Button("Scan Again") {
                    isShowingCamera = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text("OCR Scanner")
                    .font(.largeTitle)
                    .padding()

                Button {
                    isShowingCamera = true
                } label: {
                    HStack {
                        Image(systemName: "camera")
                        Text("Launch Camera")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraView(isShown: $isShowingCamera, image: $capturedImage, onImageCaptured: processOCR)
        }
        .padding()
    }

    func processOCR(image: UIImage) {
        processingOCR = true

        // Simulate OCR processing (replace with actual OCR implementation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // This is where you would call your OCR processing logic
            // For example, call a method from your shared KMM module
            // ocrResult = YourOCRService.recognizeText(from: image)

            // Placeholder result
            ocrResult = "Sample OCR text detected from image"
            processingOCR = false
        }
    }
}

// Camera functionality using UIViewControllerRepresentable
struct CameraView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    var onImageCaptured: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = uiImage
                parent.onImageCaptured(uiImage)
            }
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }
}
