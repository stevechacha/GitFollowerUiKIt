//
//  User.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

struct User : Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String
    var publicRepos:Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
