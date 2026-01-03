//
//  FollowerRepositoryProtocol.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

protocol FollowerRepositoryProtocol {
    func getFollowers(username: String, page: Int) async throws -> [Follower]
}

