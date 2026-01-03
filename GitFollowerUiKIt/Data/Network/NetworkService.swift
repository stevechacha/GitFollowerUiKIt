//
//  NetworkService.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: String, responseType: T.Type) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private let baseUrl = "https://api.github.com/users/"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: String, responseType: T.Type) async throws -> T {
        guard let url = URL(string: baseUrl + endpoint) else {
            throw AppError.invalidUsername
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw AppError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch let decodingError {
                print("Decoding error: \(decodingError)")
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Response data: \(String(dataString.prefix(500)))")
                }
                throw AppError.invalidData
            }
        } catch let error as AppError {
            throw error
        } catch {
            throw AppError.invalidToComplete
        }
    }
}

