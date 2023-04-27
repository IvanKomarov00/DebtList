import UIKit

struct Debtor: Equatable, Codable {
    let id: UUID
    var emoji: String
    var name: String
    var debt: Float
    var startDate: Date
    var endDate: Date?
    var interest: Interest?
    var duration: String
    var total: Float
    
    init(emoji: String, name: String, debt: Float, startDate: Date, endDate: Date? = nil, interest: Interest? = nil, duration: String, total: Float) {
        self.id = UUID()
        self.emoji = emoji
        self.name = name
        self.debt = debt
        self.startDate = startDate
        self.endDate = endDate
        self.interest = interest
        self.duration = duration
        self.total = total
    }

    static let documentsDirectory =
       FileManager.default.urls(for: .documentDirectory,
       in: .userDomainMask).first!
    static let archiveURL =
       documentsDirectory.appendingPathComponent("Debtors")
       .appendingPathExtension("plist")
    
    static func loadDebtors() -> [Debtor]? {
        guard let codedDebtors = try? Data(contentsOf: archiveURL) else{return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Debtor>.self, from: codedDebtors)
        //let debtor1 = Debtor(emoji: "😇", name: "Alex", debt: 10.0, startDate: Date(), endDate: nil, interest: Interest(state: .daily, percent: 0.1), duration: "1 day", total: 100)
    }
    
    static func saveDebtors(_ debtors: [Debtor]){
        let propertyListEncoder = PropertyListEncoder()
        let codedDebtors = try? propertyListEncoder.encode(debtors)
        try? codedDebtors?.write(to: archiveURL, options: .noFileProtection)
    }
}


