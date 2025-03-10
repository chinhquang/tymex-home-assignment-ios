//
//  MainCoordinator.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//

import SwiftUI

enum AppPages: Hashable {
    case userList
    case userDetail(loginName: String)
}

final class Coordinator: ObservableObject {
    
    @Published var path: NavigationPath = NavigationPath()
    
    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .userDetail(let userName):
            let service = UserDetailService()
            let viewModel = UserDetailViewModel(service: service, loginName: userName)
            UserDetailView(viewModel: viewModel)
            
        case .userList:
            let service = UserService()
            let viewModel = UserListViewModel(service: service)
            UserListView(viewModel: viewModel)
        }
    }
}

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .userList)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}
