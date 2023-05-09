//
//  ApiManager.swift
//  GitHubChallenge
//
//  Created by namik kaya on 8.05.2023.
//

import Foundation
import Alamofire

final class ApiManager {
    private let baseURL: String = "https://api.github.com/"
    
    enum EndPoint {
        case repoList, repoDetail
        
        func getPath(param: String? = nil) -> String {
            switch self {
            case .repoList: return "orgs/google/repos"
            case .repoDetail: return "repos/google/\(param ?? "")"
            }
        }
    }
    
    func fetchData<Input: Encodable, Output:Decodable>(httpMethod: HTTPMethod = .get,
                                                       endPoint: EndPoint = .repoList,
                                                       parameter: Input? = nil,
                                                       outPutEntity: Output.Type,
                                                       completion: @escaping (Result<Output, KError>) -> ()) {
        
        AF.request(baseURL + endPoint.getPath(), method: httpMethod, parameters: parameter).responseDecodable(of: outPutEntity, queue: .global(qos: .background)) { response in
            switch response.result {
            case let .success(result):
                completion(.success(result))
            case let .failure(error):
                let kError = error.mapToKError()
                completion(.failure(kError))
            }
        }
    }
}

extension AFError {
    func mapToKError() -> KError {
        let errorCode = KErrorCode(rawValue: self.responseCode ?? KErrorCode.general.rawValue) ?? .general
        return KError(errorCode: errorCode, message: self.localizedDescription)
    }
}
