//
//  FollowerDTO.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

struct FollowerDTO: Codable {
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    func toDomain() -> Follower {
        return Follower(login: login, avatarUrl: avatarUrl)
    }
}

