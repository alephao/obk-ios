import Argo
import Moya
import RxCocoa
import RxSwift

protocol RegistrationServiceType: class {
    func signup(firstName: String,
                lastName: String,
                email: String,
                password: String,
                contactNumber: String,
                dateOfBirth: String,
                wwccn: String?,
                subNewsletter: Bool) -> Observable<Void>
}

final class RegistrationService: BaseService, RegistrationServiceType {
    func signup(firstName: String,
                lastName: String,
                email: String,
                password: String,
                contactNumber: String,
                dateOfBirth: String,
                wwccn: String?,
                subNewsletter: Bool) -> Observable<Void> {
        return self.provider.networking.request(.signup(dob: dateOfBirth,
                                                        email: email,
                                                        firstName: firstName,
                                                        gender: "M",
                                                        landline: nil,
                                                        lastName: lastName,
                                                        mobile: contactNumber,
                                                        password: password,
                                                        passwordConfirmation: password,
                                                        subNewsletter: subNewsletter,
                                                        wwccn: wwccn)
            ).mapJSON()
             .map(JSON.init)
             .map { json -> Void in
                print(json)
                return ()
            }
    }
}
