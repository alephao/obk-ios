import ReactorKit
import RxCocoa
import RxSwift

enum OpportunityDetailsAlertAction: AlertActionType {
    case yes
    case no
    
    var title: String? {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        }
    }
    
    var style: UIAlertActionStyle {
        switch self {
        case .yes: return .destructive
        case .no: return .default
        }
    }
}

final class OpportunityDetailsViewReactor: Reactor {
    
    enum Action {
        case join
        case resign
    }
    
    enum Mutation {
        case setOpportunity(Opportunity)
        case setGoing(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var opportunity: Opportunity
        var isLoading: Bool = false
        
        init(opportunity: Opportunity) {
            self.opportunity = opportunity
        }
    }
    
    var provider: ServiceProviderType
    var initialState: State
    
    // MARK: Initializing
    init(provider: ServiceProviderType, opportunity: Opportunity) {
        self.provider = provider
        self.initialState = State(opportunity: opportunity)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .join:
            let setLoading: Observable<Mutation> = .just(Mutation.setLoading(true))
            let setNotLoading: Observable<Mutation> = .just(Mutation.setLoading(false))
            let setGoing = self.provider.opportunitiesService.joinOpportunity(id: self.initialState.opportunity.id)
                .catchErrorJustReturn(false)
//                .map { success in !success }
                .map { _ in true }
                .map(Mutation.setGoing)
            
            return Observable.concat([setLoading, setGoing, setNotLoading])
        case .resign:
            let setLoading: Observable<Mutation> = .just(Mutation.setLoading(true))
            let setNotLoading: Observable<Mutation> = .just(Mutation.setLoading(false))
            let setGoing = self.provider.alertService.show(title: "Alert",
                                                           message: "Are you sure you want to leave this event?",
                                                           preferredStyle: .alert,
                                                           actions: [OpportunityDetailsAlertAction.yes, OpportunityDetailsAlertAction.no])
                .flatMap { alertAction -> Observable<Mutation> in
                    switch alertAction {
                    case .yes:
                        return self.provider.opportunitiesService.resignOpportunity(id: self.initialState.opportunity.id)
                            .catchErrorJustReturn(true)
                            .map { _ in false }
                            .map(Mutation.setGoing)
                    case .no:
                        return .empty()
                    }
                }
            
            return Observable.concat([setLoading, setGoing, setNotLoading])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setOpportunity(opportunity):
            state.opportunity = opportunity
            return state
        case let .setGoing(going):
            state.opportunity = Opportunity(id: state.opportunity.id,
                                            title: state.opportunity.title,
                                            desc: state.opportunity.desc,
                                            startDate: state.opportunity.startDate,
                                            endDate: state.opportunity.endDate,
                                            going: going)
            return state
            
        case let .setLoading(loading):
            state.isLoading = loading
            return state
        }
    }
    
}
