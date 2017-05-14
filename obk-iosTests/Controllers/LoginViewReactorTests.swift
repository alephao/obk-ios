import XCTest

import ReactorKit
import RxCocoa
import RxExpect
import RxSwift
import RxTest
import RxOptional

@testable import obk_ios

final class LoginViewReactorTests: XCTestCase {
    
    fileprivate let validEmail = "a@a.com"
    fileprivate let validPassword = "a"
    
    var loginViewReactor: LoginViewReactor!
    
    override func setUp() {
        super.setUp()
        UIApplication.shared.delegate = MockAppDelegate()
        loginViewReactor = LoginViewReactor(provider: MockServiceProvider())
    }
    
    func testIsCredentialsValid() {
        RxExpect("it should change isCredentialsValid when email and password are valid") { test in
            test.input(self.loginViewReactor.action, [
                next(100, .updateEmail(self.validEmail)),
                next(200, .updatePassword(self.validPassword)),
            ])
            
            test.assert(self.loginViewReactor.state.map { state in state.isCredentialsValid })
                .equal([false, false, true])
        }
    }

    func testIsLoading() {
        RxExpect("it should change isLoading when start logging in") { test in
            test.input(self.loginViewReactor.action, [
                next(0, .updateEmail(self.validEmail)),
                next(10, .updatePassword(self.validPassword)),
                next(100, .login)
            ])

            test.assert(self.loginViewReactor.state.map { state in state.isLoading }.distinctUntilChanged())
                .filterNext()
                .since(50)
                .equal([false, true, false])
        }
    }
    
}
