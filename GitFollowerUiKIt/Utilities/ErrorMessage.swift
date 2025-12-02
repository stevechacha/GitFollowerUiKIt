//
//  ErrorMessage.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

enum GFError : String, Error{
    case invalidUsername = "This username created an invalid request. Please try again"
    case invalidToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse =  "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again"
}

