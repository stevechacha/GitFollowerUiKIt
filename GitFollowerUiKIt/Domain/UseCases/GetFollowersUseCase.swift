//
//  GetFollowersUseCase.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

final class GetFollowersUseCase {
    private let repository: FollowerRepositoryProtocol
    
    init(repository: FollowerRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(username: String, page: Int) async throws -> [Follower] {
        return try await repository.getFollowers(username: username, page: page)
    }
}

