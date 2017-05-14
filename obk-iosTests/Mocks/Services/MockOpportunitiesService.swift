import RxSwift

final class MockOpportunitiesService: OpportunitiesServiceType {
    var currentOpportunities: Observable<[Opportunity]> {
        return .just([])
    }
    
    func fetchOpportunities() -> Observable<Void> {
        return .just(())
    }
    
    func joinOpportunity(id: Int) -> Observable<Bool> {
        return .just(true)
    }
    
    func resignOpportunity(id: Int) -> Observable<Bool> {
        return .just(true)
    }
}
