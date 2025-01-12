//
//  UserDetailService.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import Foundation

protocol UserDetailServiceProtocol {
    func fetchUserDetail(loginName: String) async throws -> UserDetailResponse
}

final class UserDetailService: UserDetailServiceProtocol {

    let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchUserDetail(loginName: String) async throws -> UserDetailResponse {
        let url = UserURL.userDetail(userName: loginName).urlString
        let result = try await apiClient.sendRequest(to: url, responseType: UserDetailResponse.self)
        return result
    }
}
