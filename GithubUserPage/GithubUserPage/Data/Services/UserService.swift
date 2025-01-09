//
//  UserService.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> Result<[UserResponse], any Error>
}

final class UserService: UserServiceProtocol {

    func fetchUsers() async throws -> Result<[UserResponse], any Error>  {
        let url = UserURL.users.urlString
        do {
            let result = try await APIClient.shared.sendRequest(to: url, responseType: [UserResponse].self)
            switch result {
                
            case .success(let users):
                return .success(users)
            case .failure(let error):
                return .failure(error)
            }
        } catch let error  {
            return .failure(error)
        }
    }
}
