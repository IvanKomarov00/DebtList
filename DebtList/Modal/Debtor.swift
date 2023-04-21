import UIKit

struct Debtor {
    let id = UUID()
    var image: UIImage?
    var name: String
    var debt: Float
    var startDate: Date
    var endDate: Date?
    var interest: Interest?
    
    var duration: String {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: startDate, to: currentDate)

        if let years = components.year, years > 0 {
            return "more than \(years) years"
        } else if let months = components.month, months > 0 {
            return "more than \(months) months"
        } else if let days = components.day {
            return "\(days) days"
        } else {
            return "Less than a day"
        }
    }
    
    var total: Float {
        guard let interest = interest else { return debt }
        let timeInterval = Date().timeIntervalSince(startDate)
        switch interest.state {
        case .daily:
            let dailyInterest = (pow((1 + interest.percent), Float(timeInterval / 86400)) - 1) * debt
            return debt + dailyInterest
        case .mouthly:
            let months = Float(timeInterval / (86400 * 30))
            let monthlyInterest = (pow((1 + interest.percent), months) - 1) * debt
            return debt + monthlyInterest
        case .yearly:
            let years = Float(timeInterval / (86400 * 365))
            let yearlyInterest = (pow((1 + interest.percent), years) - 1) * debt
            return debt + yearlyInterest
        }
    }

    static func loadDebtors() -> [Debtor]? {
        let debtor1 = Debtor(name: "Alex", debt: 10.0, startDate: Date(), endDate: nil, interest: Interest(state: .daily, percent: 0.1))
        let debtor2 = Debtor(image: UIImage(named: "NewYork") ,name: "Ivan", debt: 100.0, startDate: Date(), endDate: nil, interest: Interest(state: .daily, percent: 0.1))
        
        return [debtor1, debtor2]
    }
}


