import Foundation

// Conservative parser: returns suggestions to verify, not trusted financial data.
struct BillSuggestions {
    var previous: Double?
    var present: Double?
    var usage: Double?
    var rate: Double?
    var currentBill: Double?
    var arrears: Double?
    var totalDue: Double?
}

enum BillParser {
    static func parse(_ text: String) -> BillSuggestions {
        var result = BillSuggestions()
        let lines = text.components(separatedBy: .newlines)
        func numbers(_ s: String) -> [Double] {
            guard let re = try? NSRegularExpression(pattern: #"-?\d[\d,]*(?:\.\d+)?"#) else { return [] }
            let ns = s as NSString
            return re.matches(in: s, range: NSRange(location: 0, length: ns.length)).compactMap { Double(ns.substring(with: $0.range).replacingOccurrences(of: ",", with: "")) }
        }
        for (index, line) in lines.enumerated() {
            let t = line.lowercased()
            let values = numbers(line)
            if t.contains("billing rate"), let n = values.last { result.rate = n }
            if t.contains("current bill"), let n = values.last { result.currentBill = n }
            if t.contains("total amount due"), let n = values.last { result.totalDue = n }
            if t.contains("total arrears"), let n = values.last { result.arrears = n }
            // Only infer paired readings when headings and values appear in nearby rows.
            if t.contains("pres") && t.contains("prev") {
                for nearby in lines.dropFirst(index + 1).prefix(4) {
                    let nums = numbers(nearby)
                    if nums.count >= 4 && nums[1] > 1000 && nums[2] > 1000 {
                        result.present = nums[1]; result.previous = nums[2]
                        result.usage = nums[3]
                        break
                    }
                }
            }
        }
        return result
    }
}
