import ReactorKit
import RxCocoa
import RxSwift

final class RootTabBarViewReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var opportunitiesViewReactor: OpportunitiesViewReactor
        var goingViewReactor: GoingViewReactor
        var profileViewReactor: ProfileViewReactor
    }
    
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.initialState = State(
            opportunitiesViewReactor:  OpportunitiesViewReactor(provider: provider),
            goingViewReactor: GoingViewReactor(provider: provider),
            profileViewReactor: ProfileViewReactor(provider: provider)
        )
    }
    
}
