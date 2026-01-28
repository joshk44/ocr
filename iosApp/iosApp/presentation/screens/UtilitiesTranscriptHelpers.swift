import Foundation
import FoundationModels

func segmentsToString(segments: [Transcript.Segment]) -> String {
    let strings = segments.compactMap { segment -> String? in
        if case let .text(textSegment) = segment {
            return textSegment.content
        }
        return nil
    }
    return strings.reduce("", +)
}
