//
//  UserDetailViewModel.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import SwiftUI
import Foundation

final class UserDetailViewModel: ObservableObject {
    // Presentation
    @Published var username: String = ""
    @Published var location: String = ""
    @Published var blog: String = ""
    @Published var followerCountString: String = ""
    @Published var followingCountString: String = ""
    @Published var avatarURL: URL? = nil
    // Loading State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let service: UserDetailServiceProtocol
    private let loginName: String

    init(service: UserDetailServiceProtocol, loginName: String) {
        self.service = service
        self.loginName = loginName
    }
    
    @MainActor
    func fetchUserInfo() async {
        isLoading = true
        errorMessage = nil
        do {
            let userServiceResult = try await service.fetchUserDetail(loginName: loginName)
            switch userServiceResult {
            case .success(let userDetail):
                self.username = userDetail.name ?? ""
                self.location = userDetail.location ?? ""
                self.followerCountString = String(format: "%d", userDetail.followers)
                self.followingCountString = String(format: "%d", userDetail.following)
                self.blog = userDetail.blog ?? ""
                self.avatarURL = URL(string: userDetail.avatarUrl)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
