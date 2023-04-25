import UIKit

struct Debtor {
    let id = UUID()
    var image: UIImage
    var name: String
    var debt: Float
    var startDate: Date
    var endDate: Date?
    var interest: Interest?
    var duration: String
    var total: Float

    static func loadDebtors() -> [Debtor]? {
        let debtor1 = Debtor(image: UIImage(named: "NewYork")!, name: "Alex", debt: 10.0, startDate: Date(), endDate: nil, interest: Interest(state: .daily, percent: 0.1), duration: "1 day", total: 100)
        let debtor2 = Debtor(image: UIImage(named: "NewYork")! ,name: "Ivan", debt: 100.0, startDate: Date(), endDate: nil, interest: Interest(state: .daily, percent: 0.1), duration: "1 day", total: 10)
        
        return [debtor1, debtor2]
    }
}


