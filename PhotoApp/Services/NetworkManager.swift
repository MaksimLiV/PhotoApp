//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by Maksim Li on 25/07/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternetConnection
    case requestTimeout
    case networkError(underlying: Error)
    case serverError(statusCode: Int, message: String?)
    case noData
    case invalidResponse
    case decodingError(underlying: Error, rawData: Data?)
}

// MARK: - Singleton

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let urlSession: URLSession
    
    private init() {
        urlSession = URLSession.shared
    }
    
    func fetchPhotos(completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/photos?_limit=50"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30.0
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                let networkError = self.mapURLSessionError(error)
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: nil)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(photos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(underlying: error, rawData: data)))
                }
            }
        }
        
        task.resume()
    }
    
    private func mapURLSessionError(_ error: Error) -> NetworkError {
        let nsError = error as NSError
        
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet,
             NSURLErrorNetworkConnectionLost:
            return .noInternetConnection
            
        case NSURLErrorTimedOut:
            return .requestTimeout
            
        default:
            return .networkError(underlying: error)
        }
    }
}

extension NetworkError: LocalizedError {
    var userFriendlyMessage: String {
        switch self {
        case .invalidURL, .invalidResponse:
            return "Something went wrong. Please try again."
            
        case .noInternetConnection:
            return "Please check your internet connection."
            
        case .requestTimeout:
            return "Request is taking too long. Please try again."
            
        case .networkError:
            return "Network problem. Please try again."
            
        case .serverError(let statusCode, _):
            if statusCode >= 500 {
                return "Server is temporarily unavailable."
            } else {
                return "Something went wrong. Please try again."
            }
            
        case .noData:
            return "No photos available at the moment."
            
        case .decodingError:
            return "Data format error. Please try again later."
        }
    }
    
    var technicalDetails: String {
        switch self {
        case .invalidURL:
            return "URL creation failed"
        case .noInternetConnection:
            return "No internet connection"
        case .requestTimeout:
            return "Request timeout"
        case .serverError(let statusCode, _):
            return "HTTP \(statusCode)"
        case .networkError(let error):
            return "URLSession error: \(error)"
        case .decodingError(let error, _):
            return "JSON decoding failed: \(error)"
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response format"
        }
    }
}
