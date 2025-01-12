//
//  APIClient.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum UserURL {
    case users
    case userDetail(userName: String)
    
    var urlString: String {
        switch self {
            
        case .users:
            return "https://api.github.com/users"
        case .userDetail(let userName):
            return "https://api.github.com/users/\(userName)"
        }
    }
}

actor APIClient {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func sendRequest<T: Decodable>(
        to url: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryParams: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        // Build URL
        guard var urlComponents = URLComponents(string: url) else {
            throw APIError.invalidURL
        }

        // Add query parameters
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let finalURL = urlComponents.url else {
            throw APIError.invalidURL
        }

        // Build request
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = headers

        do {
            // Perform network request
            let (data, response) = try await session.data(for: request)

            // Handle HTTP response
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }

            // Decode the response
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw error is APIError ? error : APIError.unknownError
        }
    }
}
