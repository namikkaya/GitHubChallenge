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
    
    private enum CodingKeys : String, CodingKey {
        case page, perPage = "per_page"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
    }
}
