import Alamofire

protocol RequestConvertible: URLRequestConvertible {
    typealias Query     = [String : String?]
    typealias Headers   = [String : String]
    typealias Cookies   = [String : String]
    
    var baseURLString: String   { get }
    var method: HTTPMethod      { get }
    var path: String            { get }
    var queryParams: Query?     { get }
    var parameters: Parameters? { get }
    var headers: Headers?       { get }
    var cookies: Cookies?       { get }
}

extension RequestConvertible {
    
    var path: String            { return "" }
    var queryParams: Query?     { return nil }
    var parameters: Parameters? { return nil }
    var headers: Headers?       { return nil }
    var cookies: Cookies?       { return nil }
    
    //MARK: Private
    
    private func addQueryParams(url: URL) -> URL {
        var url = url
        if let queryParams = self.queryParams, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            var urlComponents = urlComponents
            var queryItems = [URLQueryItem]()
            for (name, value) in queryParams {
                if let value = value {
                    queryItems.append(URLQueryItem(name: name, value: value))
                }
            }
            
            urlComponents.queryItems = queryItems
            if let urlFromComponents = urlComponents.url, queryItems.count > 0 {
                url = urlFromComponents
            }
        }
        
        return url
    }
    
    private func set(cookies: Cookies, for url: URL) {
        let jar                 = HTTPCookieStorage.shared
        let cookie              = cookies.map{ "\($0.key)=\($0.value)" }.joined(separator: ", ")
        let cookieHeaderField   = ["Set-Cookie": cookie]
        let cookies             = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        jar.setCookies(cookies, for: url, mainDocumentURL: url)
    }
    
    private func set(headers: Headers, request: inout URLRequest) {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func fill(request: URLRequest) throws -> URLRequest {
        var request = request
        if let parameters = self.parameters {
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
        
        if let headers = self.headers {
            self.set(headers: headers, request: &request)
        }
        
        if let cookies = self.cookies, let url = request.url {
            self.set(cookies: cookies, for: url)
        }
        
        return request
    }
    
    //MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        var url = try self.baseURLString.appending(self.path).asURL()
        url     = self.addQueryParams(url: url)
        
        var urlRequest          = URLRequest(url: url)
        urlRequest.httpMethod   = self.method.rawValue
        urlRequest              = try self.fill(request: urlRequest)
        
        return urlRequest
    }
}
