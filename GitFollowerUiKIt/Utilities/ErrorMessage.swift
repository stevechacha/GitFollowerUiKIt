//
//  ErrorMessage.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

enum GFError : String, Error{
    case invalidUsername = "This username created an inavlid request. Please try again"
    case invalidToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidREsponse =  "Invalid response frome the server . Please try again"
    case invalidData = "The data received from the serer was invalid. Please try again"
}

//enum Result<Success, Failure: Error> {
//    case success(Success)
//    case failure(Failure)
//}

