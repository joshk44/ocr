//
//  HomeView.swift
//  iosApp
//
//  Created by Jose Ferreyra on 8/8/25.
//  Copyright © 2025 orgName. All rights reserved.
//
import SwiftUI
import shared
import Foundation

struct HomeView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    @State private var processingOCR = false
    @State private var ocrResult: String = ""

    var body: some View {
        VStack {
            if capturedImage != nil {
                
                if processingOCR {
                    ProgressView("Processing OCR...")
                    
                } else if !ocrResult.isEmpty {
                    Text("OCR Result:")
                        .font(.headline)
                    Text(ocrResult)
                        .foregroundColor(Color.primary)
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
        .fullScreenCover(isPresented: $isShowingCamera ) {
            CameraView(isShown: $isShowingCamera, image: $capturedImage, onImageCaptured: processOCR)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
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




