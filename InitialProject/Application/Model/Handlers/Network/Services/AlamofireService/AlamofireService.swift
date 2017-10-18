import Alamofire

class AlamofireService: ServiceProtocol {
    
    //MARK: Private.Properties
    
    private lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.httpCookieStorage = nil
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false

        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    //MARK: ServiceProtocol
    
    @discardableResult
    func request(request: URLRequestConvertible) -> DataRequest {
        return self.sessionManager.request(request)
    }
    
    @discardableResult
    func upload(_ data: Data, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequest {
        return self.sessionManager.upload(data, to: url, method: method, headers: headers)
    }
    
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        to url: URLConvertible,
        with headers: HTTPHeaders,
        encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) {
        self.sessionManager.upload(multipartFormData: multipartFormData, to: url, headers: headers, encodingCompletion: encodingCompletion)
    }
}
