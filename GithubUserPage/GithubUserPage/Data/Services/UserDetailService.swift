//
//  UserDetailService.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import Foundation

protocol UserDetailServiceProtocol {
    func fetchUserDetail(loginName: String) async throws -> Result<UserDetailResponse, any Error>
}

final class UserDetailService: UserDetailServiceProtocol {

    let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchUserDetail(loginName: String) async throws -> Result<UserDetailResponse, any Error> {
        let url = UserURL.userDetail(userName: loginName).urlString
        do {
            let result = try await apiClient.sendRequest(to: url, responseType: UserDetailResponse.self)
            switch result {
                
            case .success(let userDetail):
                return .success(userDetail)
            case .failure(let error):
                return .failure(error)
            }
        } catch let error  {
            return .failure(error)
        }
    }
}
