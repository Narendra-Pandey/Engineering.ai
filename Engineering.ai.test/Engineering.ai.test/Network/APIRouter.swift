//
//  APIRouter.swift
//  Engineering.ai.test
//
//  Created by PCQ182 on 25/12/19.
//  Copyright © 2019 PCQ182. All rights reserved.
//

import Foundation
import Alamofire

protocol Router {
    var path:String { get }
    var method: HTTPMethod { get }
    var parameter: [String:String] { get }
}

enum APIRouter {
    case getListing(parameter:[String:String])
}

// MARK: - API Router SetUp -
extension APIRouter : Router {
    var path: String {
        switch self {
        case .getListing:
            return Environment.basePath + "search_by_date"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getListing:
            return .get
        }
    }
    
    var parameter: [String : String] {
        switch self {
        case .getListing(let param):
            return param
        }
    }
}

// MARK: - Get with Param -
extension APIRouter {
    func getWithParam() -> String {
        switch self {
        case .getListing(let param):
            var url = URLComponents(string: self.path.trimmingCharacters(in: .whitespaces))
            let queryItem = param.reduce(into: [URLQueryItem]()) { (result, kvPair) in
                result.append(URLQueryItem(name: kvPair.key, value: kvPair.value))
            }
            url?.queryItems = queryItem
            return try! (url?.asURL().absoluteString)!
        }
    }
}
