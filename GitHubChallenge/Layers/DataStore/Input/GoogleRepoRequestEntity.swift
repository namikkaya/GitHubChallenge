//
//  GoogleRepoRequestEntity.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit

struct GoogleRepoRequestEntity: Encodable {
    let page: Int?
    let perPage: Int?
    let sort: SortType?
    let type: ReqType?
    
    private enum CodingKeys : String, CodingKey {
        case page, perPage = "per_page", sort, type
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
        try container.encode(sort?.rawValue ?? "", forKey: .sort)
        try container.encode(type?.reqValue, forKey: .type)
    }
    
    enum SortType: String, CaseIterable {
        case created, updated, pushed, full_name
    }
    
    enum ReqType: String, CaseIterable{
        case all, publicType, privateType, forks, sources, member
        var reqValue: String {
            switch self {
            case .all: return "all"
            case .publicType:  return "public"
            case .privateType: return "private"
            case .forks: return "forks"
            case .sources: return "sources"
            case .member: return "member"
            }
        }
    }
}
