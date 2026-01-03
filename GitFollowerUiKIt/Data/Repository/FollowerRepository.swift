//
//  FollowerRepository.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

final class FollowerRepository: FollowerRepositoryProtocol {
    private let remoteDataSource: RemoteFollowerDataSourceProtocol
    
    init(remoteDataSource: RemoteFollowerDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getFollowers(username: String, page: Int) async throws -> [Follower] {
        let dtos = try await remoteDataSource.fetchFollowers(username: username, page: page)
        return dtos.map { $0.toDomain() }
    }
}

