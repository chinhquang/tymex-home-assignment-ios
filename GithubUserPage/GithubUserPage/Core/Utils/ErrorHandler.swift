//
//  ErrorHandler.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL is invalid."
        case .noData: return "No data was received from the server."
        case .decodingError: return "Failed to decode the response."
        case .serverError(let statusCode): return "Server error with status code \(statusCode)."
        case .unknownError: return "An unknown error occurred."
        }
    }
}
