import Argo
import Moya
import RxCocoa
import RxSwift

//protocol RegistrationServiceType: class {
//    func signup(firstName: String,
//                lastName: String,
//                email: String,
//                password: String,
//                contactNumber: String,
//                dateOfBirth: String,
//                wwccn: String?,
//                subNewsletter: Bool) -> Observable<Volunteer?>
//}
//
//final class RegistrationService: BaseService, RegistrationServiceType {
//    func signup(firstName: String,
//                lastName: String,
//                email: String,
//                password: String,
//                contactNumber: String,
//                dateOfBirth: String,
//                wwccn: String?,
//                subNewsletter: Bool) -> Observable<Volunteer?> {
//        return self.provider.networking.request(.signup(dob: dateOfBirth,
//                                                        email: email,
//                                                        firstName: firstName,
//                                                        gender: "M", // Gender is not necessary now
//            landline: nil,
//            lastName: lastName,
//            mobile: contactNumber,
//            password: password,
//            passwordConfirmation: password,
//            subNewsletter: subNewsletter,
//            wwccn: wwccn)
//            )
//            .do(onNext: { [weak self] response in self?.extractToken(response) })
//            .mapJSON()
//            .map { [weak self] anyJson in
//                let json = JSON(anyJson)
//                do {
//                    let decoded = AuthEnvelope.decode(json)
//                    let dematerialized = try decoded.dematerialize()
//                    let volunteer = dematerialized.data.volunteer
//                    self?.provider.userService.updateCurrentUser(volunteer)
//                    return volunteer
//                } catch {
//                    return nil
//                }
//        }
//    }
//    
//    fileprivate func extractToken(_ response: Response) {
//        if let r = response.response as? HTTPURLResponse {
//            let headers = r.allHeaderFields
//            
//            if let accessToken = headers["access-token"] as? String,
//                let client = headers["client"] as? String,
//                let expiry = headers["expiry"] as? String,
//                let tokenType = headers["token-type"] as? String,
//                let uid = headers["uid"] as? String{
//                
//                let accessToken = AccessToken(accessToken: accessToken,
//                                              expiry: expiry,
//                                              client: client,
//                                              tokenType: tokenType,
//                                              uid: uid)
//                
//                
//                self.currentAccessToken = accessToken
//                try? self.save(accessToken)
//            }
//        }
//    }
//}
