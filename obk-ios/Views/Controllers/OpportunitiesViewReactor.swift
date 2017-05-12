import Argo
import Moya
import RxCocoa
import RxSwift
import RxSwiftExt
import RxSwiftUtilities

import ReactorKit

final class OpportunitiesViewReactor: Reactor {
    enum Action {
        case refresh
        case setOpportunities([Opportunity])
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setOpportunities([Opportunity], nextPage: Int?)
        case appendOpportunities([Opportunity], nextPage: Int?)
    }
    
    struct State {
        var isRefreshing: Bool = false
        var nextPage: Int?
        var opportunities: [Opportunity] = []
    }
    
    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
        
        // TODO: ?
        _ = provider.opportunitiesService.currentOpportunities
            .map(Action.setOpportunities)
            .bindTo(self.action)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isRefreshing else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = self.provider.opportunitiesService.fetchOpportunities()
                .map { _ in Mutation.setRefreshing(false) }
            return .concat([startRefreshing, endRefreshing])
        case let .setOpportunities(opportunities):
            // TODO: Next Page
            return .just(.setOpportunities(opportunities, nextPage: 1))
        }
        
        
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing// && !isEmpty
            return state
            
        case let .setOpportunities(opportunities, nextPage):
            state.opportunities = opportunities
            state.nextPage = nextPage
            return state
            
        case let .appendOpportunities(opportunities, nextPage):
            let ops = state.opportunities + opportunities
            state.opportunities = ops
            state.nextPage = nextPage
            return state
        }
    }
    
    func reactorForOpportunity(_ opportunity: Opportunity) -> OpportunityDetailsViewReactor {
        return OpportunityDetailsViewReactor(provider: provider, opportunity: opportunity)
    }
    
}
