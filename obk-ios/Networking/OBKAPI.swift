import Moya
import MoyaSugar

enum OBKAPI {
    case events
    case joinEvent(id: Int)
    case resignEvent(id: Int)
    case signin(email: String, password: String)
    case signup(
        dob: String,
        email: String,
        firstName: String,
        gender: String,
        landline: String?,
        lastName: String,
        mobile: String,
        password: String,
        passwordConfirmation: String,
        subNewsletter: Bool,
        wwccn: String?)
}

extension OBKAPI: SugarTargetType {
    var baseURL: URL {
        return URL(string: "http://obk.herokuapp.com/api")!
    }
    
    var route: Route {
        switch self {
        case .events:
            return .get("/events")
        case let .joinEvent(id):
            return .put("/events/\(id)/join")
        case let .resignEvent(id):
            return .put("/events/\(id)/resign")
        case .signin:
            return .post("/volunteers/sign_in")
        case .signup:
            return .post("/volunteers/sign_up")
        }
    }
    
    var params: Parameters? {
        switch self {
        case let .signin(email, password):
            return ["email": email, "password": password]
        case let .signup(dob, email, firstName, gender, landline, lastName, mobile, password, passwordConfirmation, subNewsletter, wwccn):
            var p: [String: Any] = [
                "dob": dob,
                "email": email,
                "first_name": firstName,
                "gender": gender,
                "last_name": lastName,
                "mobile_number": mobile,
                "password": password,
                "password_confirmation": passwordConfirmation,
                "sub_newsletter": subNewsletter,
                ]
            
            if landline != nil {
                p["landline_number"] = landline!
            }
            
            if wwccn != nil {
                p["wwccn"] = wwccn!
            }
            
            return p as? Parameters
        default:
            return nil
        }
    }
    
    public var task: Task {
        switch self {
        case .events, .joinEvent, .resignEvent, .signin, .signup:
            return .request
        }
    }
    
    var httpHeaderFields: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    public var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
}
