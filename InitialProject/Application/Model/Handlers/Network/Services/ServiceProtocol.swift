//
//  ServiceProtocol.swift
//  q9elements.mobile
//
//  Created by volodymyrkhmil on 2/23/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import Alamofire

protocol ServiceProtocol {
    @discardableResult
    func request(request: URLRequestConvertible) -> DataRequest
    
    @discardableResult
    func upload(_ data: Data,to url: URLConvertible,method: HTTPMethod,headers: HTTPHeaders?) -> UploadRequest
    
    func upload(
    multipartFormData: @escaping (MultipartFormData) -> Void,
    to url: URLConvertible,
    with headers: HTTPHeaders,
    encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
}
