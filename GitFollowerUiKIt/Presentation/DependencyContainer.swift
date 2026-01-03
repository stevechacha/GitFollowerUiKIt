//
//  DependencyContainer.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

final class DependencyContainer {
    @MainActor
    static func makeFollowerListViewModel() -> FollowerListViewModel {
        let networkService = NetworkService.shared
        let remoteDataSource = RemoteFollowerDataSource(networkService: networkService)
        let repository = FollowerRepository(remoteDataSource: remoteDataSource)
        let useCase = GetFollowersUseCase(repository: repository)
        return FollowerListViewModel(getFollowersUseCase: useCase)
    }
}

