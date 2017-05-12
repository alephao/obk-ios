import Argo
import Curry
import Foundation
import Runes

public struct EventsEnvelope {
    let events: [Opportunity]
    let meta: Meta
    
    struct Meta {
        let currentpage: Int
        let nextPage: Int?
        let prevPage: Int?
        let totalCount: Int
        let totalPages: Int
    }
}

extension EventsEnvelope: Decodable {
    public static func decode(_ j: JSON) -> Decoded<EventsEnvelope> {
        let create = curry(EventsEnvelope.init)
        return create
            <^> j <||  "events"
            <*> j <|  "meta"
    }
}

extension EventsEnvelope.Meta: Decodable {
    public static func decode(_ j: JSON) -> Decoded<EventsEnvelope.Meta> {
        let create = curry(EventsEnvelope.Meta.init)
        return create
            <^> j <|  "current_page"
            <*> j <|?  "next_page"
            <*> j <|?  "prev_page"
            <*> j <|  "total_count"
            <*> j <|  "total_pages"
    }
}
