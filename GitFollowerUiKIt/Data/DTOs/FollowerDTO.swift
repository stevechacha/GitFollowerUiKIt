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
    
    func toDomain() -> Follower {
        return Follower(login: login, avatarUrl: avatarUrl)
    }
}

