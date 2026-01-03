//
//  NetworkManager.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import UIKit

// DEPRECATED: This class is deprecated. Use NetworkService and the clean architecture layers instead.
// Only kept for backward compatibility - the cache property is still used by GFImageView.
class NetworkManager {
    static let shared = NetworkManager()
    
    let baseUrl = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    // DEPRECATED: This method has been removed. Use NetworkService and FollowerRepository instead.
    // The getFollowers method was removed as it's no longer used in the clean architecture implementation.
}
