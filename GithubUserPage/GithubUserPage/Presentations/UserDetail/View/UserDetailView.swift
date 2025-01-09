//
//  UserDetailView.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import SwiftUI

struct UserDetailView: View {

    @StateObject private var viewModel: UserListViewModel
    @EnvironmentObject private var coordinator: Coordinator

    init(viewModel: UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading Photos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(viewModel.users) { user in
                    HStack(alignment: .top) {
                        if let url = user.avatarURL {
                            CachedAsyncImage(
                                url: url,
                                placeholder: ProgressView()
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(Circle())
                            )
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        } else {
                            Color.gray // Error loading image
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.loginUsername)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.leading, 8)
                                .lineLimit(1)
                            Divider()
                                .padding(.leading, 8)
                                .padding(.trailing, 8)
                                .padding(.top, 4)
                            
                            Text(user.landingPageURLAttributedString ?? AttributedString(""))
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .padding(.leading, 8)
                                .padding(.top, 8)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // Drop shadow
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 8)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        coordinator.push(page: .userDetail(loginName: user.loginUsername))
                    }
                }
                
                .listStyle(.plain)
                .background(Color(.systemGroupedBackground))
            }
        }
        .task {
            await viewModel.fetchItems()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
