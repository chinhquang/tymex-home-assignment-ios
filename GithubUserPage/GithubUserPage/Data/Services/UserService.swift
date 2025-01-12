//
//  UserService.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [UserResponse]
}

final class UserService: UserServiceProtocol {

    let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchUsers() async throws -> [UserResponse]  {
        let url = UserURL.users.urlString
        return try await apiClient.sendRequest(to: url, responseType: [UserResponse].self)
    }
}
