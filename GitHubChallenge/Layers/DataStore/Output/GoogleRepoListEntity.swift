//
//  GoogleRepoListEntity.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation

struct GoogleRepoListEntity: Decodable {
    let name: String?
    let watcherCount: Int?
    let forksCount: Int?
    let owner: Owner?
    
    private enum CodingKeys : String, CodingKey {
        case name, watchersCount = "watchers_count", forksCount = "forks_count", owner
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        watcherCount = try values.decode(Int.self, forKey: .watchersCount)
        forksCount = try values.decode(Int.self, forKey: .forksCount)
        owner = try values.decode(Owner.self, forKey: .owner)
    }
}

struct Owner: Decodable {
    let login: String?
    let avatarURL: String?
    let reposURL: String?
    
    private enum CodingKeys : String, CodingKey {
        case login, avatarURL = "avatar_url", reposURL = "repos_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decode(String.self, forKey: .login)
        avatarURL = try values.decode(String.self, forKey: .avatarURL)
        reposURL = try values.decode(String.self, forKey: .reposURL)
    }
}
