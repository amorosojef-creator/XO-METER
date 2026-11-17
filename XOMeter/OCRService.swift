import Foundation
import UIKit
import Vision

struct OCRResult {
    let lines: [String]
    var text: String { lines.joined(separator: "\n") }
    var meterCandidates: [Double] {
        let possible = lines.flatMap { line -> [Double] in
            let pattern = #"(?<![\d])0*([1-9]\d{3,6})(?:[.,](\d))?(?![\d])"#
            guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
            let ns = line as NSString
            return regex.matches(in: line, range: NSRange(location: 0, length: ns.length)).compactMap { match in
                let whole = ns.substring(with: match.range)
                return Double(whole.replacingOccurrences(of: ",", with: "."))
            }
        }
        return Array(Set(possible)).sorted()
    }
}

enum OCRService {
    static func recognize(_ image: UIImage) async throws -> OCRResult {
        try await Task.detached(priority: .userInitiated) {
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            request.recognitionLanguages = ["en-US"]
            if let cgImage = image.cgImage {
                try VNImageRequestHandler(cgImage: cgImage).perform([request])
            } else if let ciImage = CIImage(image: image) {
                try VNImageRequestHandler(ciImage: ciImage).perform([request])
            } else {
                throw NSError(domain: "XOMeter", code: 1, userInfo: [NSLocalizedDescriptionKey: "Image could not be decoded"])
            }
            let observations = (request.results ?? []).sorted { a, b in
                if abs(a.boundingBox.midY - b.boundingBox.midY) > 0.02 { return a.boundingBox.midY > b.boundingBox.midY }
                return a.boundingBox.minX < b.boundingBox.minX
            }
            return OCRResult(lines: observations.compactMap { $0.topCandidates(1).first?.string })
        }.value
    }
}
