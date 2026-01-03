//
//  FollowerListViewModel.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

@MainActor
final class FollowerListViewModel {
    private let getFollowersUseCase: GetFollowersUseCase
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isLoading = false
    
    var onFollowersUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onShowEmptyState: ((String) -> Void)?
    
    init(getFollowersUseCase: GetFollowersUseCase) {
        self.getFollowersUseCase = getFollowersUseCase
    }
    
    func loadFollowers(username: String, page: Int) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let newFollowers = try await getFollowersUseCase.execute(username: username, page: page)
            
            if newFollowers.count < 100 {
                hasMoreFollowers = false
            }
            
            if page == 1 {
                followers = newFollowers
            } else {
                followers.append(contentsOf: newFollowers)
            }
            
            filteredFollowers = followers
            
            if followers.isEmpty {
                let message = "This user doesn't have any followers. Go follow them!"
                onShowEmptyState?(message)
            } else {
                onFollowersUpdated?()
            }
        } catch let error as AppError {
            onError?(error.errorDescription ?? "An error occurred")
        } catch {
            onError?("An unknown error occurred")
        }
        
        isLoading = false
    }
    
    func loadMoreFollowers(username: String) async {
        guard hasMoreFollowers, !isLoading else { return }
        page += 1
        await loadFollowers(username: username, page: page)
    }
    
    func filterFollowers(query: String?) {
        guard let query = query, !query.isEmpty else {
            filteredFollowers = followers
            onFollowersUpdated?()
            return
        }
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(query.lowercased()) }
        onFollowersUpdated?()
    }
}

