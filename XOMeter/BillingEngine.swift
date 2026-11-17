import Foundation

enum Billing {
    static func consumption(previous: Double, present: Double, multiplier: Double = 1) -> Double {
        guard previous.isFinite, present.isFinite, multiplier.isFinite,
              previous >= 0, present >= previous, multiplier > 0 else { return 0 }
        return (present - previous) * multiplier
    }
    static func predictedCharges(kWh: Double, historicalBill: Double, historicalKWh: Double) -> Double {
        guard kWh.isFinite, kWh >= 0, historicalBill.isFinite, historicalBill >= 0,
              historicalKWh.isFinite, historicalKWh > 0 else { return 0 }
        return kWh * historicalBill / historicalKWh
    }
    static func pesos(_ amount: Double) -> String {
        amount.formatted(.currency(code: "PHP"))
    }
}
