//
//  AppError.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

enum AppError: LocalizedError {
    case invalidUsername
    case invalidToComplete
    case invalidResponse
    case invalidData
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidUsername:
            return "This username created an invalid request. Please try again"
        case .invalidToComplete:
            return "Unable to complete your request. Please check your internet connection"
        case .invalidResponse:
            return "Invalid response from the server. Please try again"
        case .invalidData:
            return "The data received from the server was invalid. Please try again"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

