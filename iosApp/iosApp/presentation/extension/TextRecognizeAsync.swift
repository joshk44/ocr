
import UIKit
@preconcurrency import Vision

func recognizeTextAsync(in image: UIImage,
                        languages: [String] = ["es-ES", "en-US"],
                        level: VNRequestTextRecognitionLevel = .accurate) async throws -> [String] {
    
    guard let cg = image.cgImage else { throw NSError(domain: "OCR", code: -1) }

    let request = VNRecognizeTextRequest()
    request.recognitionLevel = level
    request.recognitionLanguages = languages
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: cg,
                                        orientation: cgImagePropertyOrientation(from: image.imageOrientation))

    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
                cont.resume()
            } catch {
                cont.resume(throwing: error)
            }
        }
    }

    let observations = (request.results) ?? []
    return observations.compactMap { $0.topCandidates(1).first?.string }
}

// Utilidad: orientación correcta para Vision
private func cgImagePropertyOrientation(from ui: UIImage.Orientation) -> CGImagePropertyOrientation {
    switch ui {
    case .up: return .up
    case .down: return .down
    case .left: return .left
    case .right: return .right
    case .upMirrored: return .upMirrored
    case .downMirrored: return .downMirrored
    case .leftMirrored: return .leftMirrored
    case .rightMirrored: return .rightMirrored
    @unknown default: return .up
    }
}
