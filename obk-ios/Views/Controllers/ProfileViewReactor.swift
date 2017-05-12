import Argo
import Moya
import RxCocoa
import RxSwift
import RxSwiftExt
import RxSwiftUtilities

import ReactorKit
import RxDataSources

enum ProfileItem {
    case ProfileItemBasic(String)
    case ProfileItemSubtitle(String, String)
    case ProfileItemButton(String)
}

struct ProfileSection {
    var header: String?
    var items: [Item]
}

extension ProfileSection: SectionModelType {
    typealias Item = ProfileItem
    
    init(original: ProfileSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class ProfileViewReactor: Reactor {
    enum Action {
        case logout
        case updateVolunteer(Volunteer)
    }
    
    enum Mutation {
        case setSections([ProfileSection])
        case setLoggedOut
    }
    
    struct State {
        var sections: [ProfileSection] = []
        var isLoggedOut: Bool = false
    }
    
    let provider: ServiceProviderType
    let initialState: State
    
    fileprivate let disposeBag = DisposeBag()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateVolunteer(volunteer):
            return .just(.setSections(createSections(for: volunteer)))
        case .logout:
            return .just(.setLoggedOut)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setSections(sections):
            state.sections = sections
            return state
        case .setLoggedOut:
            state.isLoggedOut = true
            return state
        }
    }
    
    fileprivate func createSections(for volunteer: Volunteer) -> [ProfileSection] {
        return [
            ProfileSection(header: nil, items: [
                .ProfileItemSubtitle("Name", "\(volunteer.firstName) \(volunteer.lastName)"),
                .ProfileItemSubtitle("Email", volunteer.email)
                ]),
            ProfileSection(header: nil, items: [
                .ProfileItemSubtitle("Mobile number", volunteer.mobileNumber),
                .ProfileItemSubtitle("Date of Birth", volunteer.dateOfBirth)
                ]),
            ProfileSection(header: "WORKING WITH CHILDRENS NUMBER", items: [
                .ProfileItemBasic(volunteer.wwccn ?? "Not provided")
                ]),
            ProfileSection(header: nil, items: [
                .ProfileItemButton("Logout")
                ])
        ]
    }
}
