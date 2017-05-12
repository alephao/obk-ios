import Moya

struct AuthPlugin: PluginType {
    
    fileprivate let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let accessToken = self.provider.authService.currentAccessToken {
            request.addValue(accessToken.accessToken, forHTTPHeaderField: "access-token")
            request.addValue(accessToken.expiry, forHTTPHeaderField: "expiry")
            request.addValue(accessToken.client, forHTTPHeaderField: "client")
            request.addValue(accessToken.tokenType, forHTTPHeaderField: "token-type")
            request.addValue(accessToken.uid, forHTTPHeaderField: "uid")
        }
        return request
    }
    
}
