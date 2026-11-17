import Foundation
func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() { fatalError("FAILED: \(message)") }
    print("PASS: \(message)")
}
check(Billing.consumption(previous: 9668, present: 9851) == 183, "October ZANECO reading difference")
check(Billing.consumption(previous: 9851, present: 9991) == 140, "November 17 confirmed consumption")
check(Billing.consumption(previous: 9991, present: 9851) == 0, "Decreasing reading invalid")
check(abs(Billing.predictedCharges(kWh: 140, historicalBill: 2755.09, historicalKWh: 183) - 2107.72) < 0.02, "November sample estimated current charges")
check(Billing.predictedCharges(kWh: 0, historicalBill: 2755.09, historicalKWh: 183) == 0, "Zero consumption")
check(Billing.predictedCharges(kWh: 100, historicalBill: 0, historicalKWh: 0) == 0, "Zero denominator guard")
check(Billing.consumption(previous: 100, present: 120, multiplier: 2) == 40, "Meter multiplier")
print("All billing tests passed")
