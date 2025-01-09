//
//  UserListViewModel.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//
import SwiftUI
import Foundation

class UserListViewModel: ObservableObject {
    @Published var users: [UserViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    private let service: UserServiceProtocol

    init(service: UserServiceProtocol ) {
        self.service = service
    }

    @MainActor
    func fetchItems() async {
        isLoading = true
        errorMessage = nil
        do {
            let userServiceResult = try await service.fetchUsers()
            switch userServiceResult {
            case .success(let users):
                self.users = users.map { UserViewModel(from: $0)}
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
