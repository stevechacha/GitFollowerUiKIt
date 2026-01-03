//
//  RemoteFollowerDataSource.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

protocol RemoteFollowerDataSourceProtocol {
    func fetchFollowers(username: String, page: Int) async throws -> [FollowerDTO]
}

final class RemoteFollowerDataSource: RemoteFollowerDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchFollowers(username: String, page: Int) async throws -> [FollowerDTO] {
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw AppError.invalidUsername
        }
        
        let endpoint = "\(encodedUsername)/followers?per_page=100&page=\(page)"
        
        do {
            let dtos: [FollowerDTO] = try await networkService.request(endpoint, responseType: [FollowerDTO].self)
            return dtos
        } catch {
            throw error
        }
    }
}

