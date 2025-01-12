//
//  UserListViewModel.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//
import SwiftUI
import Foundation

class UserListViewModel: ObservableObject {

    @Published var hasLoaded = false
    @Published var users: [UserViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    private let service: UserServiceProtocol
    
    init(service: UserServiceProtocol ) {
        self.service = service
    }
    
    func fetchItems() async {
        await updateErrorMessage(message: nil)
        await updateLoadingState(isLoading: true)
        do {
            let userResponse = try await service.fetchUsers()
            await updateUserList(userResponse: userResponse)
            await updateLoadingState(isLoading: false)
        } catch {
            await updateLoadingState(isLoading: false)
            await updateErrorMessage(message: error.localizedDescription)
        }
    }
    
    func refresh() async {
        do {
            let userResponse = try await service.fetchUsers()
            await updateUserList(userResponse: userResponse)
            await updateLoadingState(isLoading: false)
        } catch {
            await updateLoadingState(isLoading: false)
            await updateErrorMessage(message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func updateUserList(userResponse: [UserResponse]){
        self.users = userResponse.map { UserViewModel(from: $0)}
    }
    
    @MainActor
    private func updateLoadingState(isLoading: Bool){
        self.isLoading = isLoading
    }
    
    @MainActor
    private func updateErrorMessage(message: String?){
        self.errorMessage = message
    }
}
