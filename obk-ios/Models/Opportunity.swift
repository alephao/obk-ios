import Argo
import Curry
import Foundation
import Runes

private func nilIsFalse(_ val: Bool?) -> Bool {
    return val ?? false
}

public struct Opportunity {
    let id: Int
    let title: String
    let desc: String
    let startDate: String
    let endDate: String
    let going: Bool
    
    public func startDateDate() -> Date? {
        let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SZ")
        return dateFormatter.date(from: startDate)
    }
    
    public func endDateDate() -> Date? {
        let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SZ")
        return dateFormatter.date(from: endDate)
    }
    
    public func dateMidString() -> String {
        guard let sDate = startDateDate() else {
            return "Failed to get date"
        }
        let dateFormatter = DateFormatter(dateFormat: "EEEE MMM, dd")
        return dateFormatter.string(from: sDate)
    }
    
    public func durationString() -> String {
        let dateFormatter = DateFormatter(dateFormat: "ha")
        var dateString = ""
        
        if let startDate = self.startDateDate(),
            let endDate = self.endDateDate() {
            dateString = "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))"
        } else {
            dateString = "Failed to get date"
        }
        
        return dateString
    }
}

extension Opportunity: Decodable {
    public static func decode(_ j: JSON) -> Decoded<Opportunity> {
        let create = curry(Opportunity.init)
        return create
            <^> j <|  "id"
            <*> j <|  "title"
            <*> j <|  "description"
            <*> j <|  "start_date"
            <*> j <|  "end_date"
            <*> (j <|  "going" <|> .success(false))
    }
}
