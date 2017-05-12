import Argo
import Moya
import RxCocoa
import RxSwift

protocol OpportunitiesServiceType: class {
    var currentOpportunities: Observable<[Opportunity]> { get }
    
    func fetchOpportunities() -> Observable<Void>
    func joinOpportunity(id: Int) -> Observable<Bool>
    func resignOpportunity(id: Int) -> Observable<Bool>
}

final class OpportunitiesService: BaseService, OpportunitiesServiceType {
    fileprivate let opportunitiesSubject = ReplaySubject<[Opportunity]>.create(bufferSize: 1)
    lazy var currentOpportunities: Observable<[Opportunity]> = self.opportunitiesSubject.asObservable() //self.userSubject.asObservable()
        .startWith([])
        .shareReplay(1)
    
    func fetchOpportunities() -> Observable<Void> {
        return self.provider.networking.request(.events)
            .mapJSON()
            .map(JSON.init)
            .map { json in
                do {
                    let decoded = EventsEnvelope.decode(json)
                    let dematerialized = try decoded.dematerialize()
                    self.opportunitiesSubject.on(.next(dematerialized.events))
                } catch let error {
                    log.error("Failed to decode opportunities: \(error.localizedDescription)")
                }
                return ()
            }
    }
    
    func joinOpportunity(id: Int) -> Observable<Bool> {
        return self.provider.networking.request(.joinEvent(id: id))
            .mapJSON()
            .map(JSON.init)
            .map { json in
                do {
                    let decoded = JoinEventEnvelope.decode(json)
                    let dematerialized = try decoded.dematerialize()
                    print(dematerialized)
                    return dematerialized.success
                } catch {
                    return false
                }
            }
    }
    
    func resignOpportunity(id: Int) -> Observable<Bool> {
        return self.provider.networking.request(.resignEvent(id: id))
            .mapJSON()
            .map(JSON.init)
            .map { json in
                do {
                    let decoded = JoinEventEnvelope.decode(json)
                    let dematerialized = try decoded.dematerialize()
                    print(dematerialized)
                    return dematerialized.success
                } catch {
                    return false
                }
        }
    }
    
}
