//
//  UserDTO.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

struct UserDTO: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
        case location
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case htmlUrl = "html_url"
        case following
        case followers
        case createdAt = "created_at"
    }
    
    func toDomain() -> User {
        return User(
            login: login,
            avatarUrl: avatarUrl,
            name: name,
            location: location,
            bio: bio,
            publicRepos: publicRepos,
            publicGists: publicGists,
            htmlUrl: htmlUrl,
            following: following,
            followers: followers,
            createdAt: createdAt
        )
    }
}

