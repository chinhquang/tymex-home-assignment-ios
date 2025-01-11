//
//  UserDetailView.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import SwiftUI

struct UserDetailView: View {

    @StateObject private var viewModel: UserDetailViewModel
    @EnvironmentObject private var coordinator: Coordinator

    init(viewModel: UserDetailViewModel) {
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
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        if let url = viewModel.avatarURL {
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
                            Text(viewModel.username)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.leading, 8)
                                .lineLimit(1)
                            Divider()
                                .padding(.leading, 8)
                                .padding(.trailing, 8)
                                .padding(.top, 4)
                            
                            HStack(alignment: .center, spacing: 4) {
                                Image(systemName: "map")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text(viewModel.location)
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                                    .padding(.leading, 4)
                                    .lineLimit(1)
                            }
                            .padding(.leading, 8)
                            .padding(.top, 8)
                           
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // Drop shadow
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                }
                HStack(alignment: .center,  spacing: 40){
                    VStack (spacing: 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.gray.opacity(0.2))  // Background color
                                .frame(width: 60, height: 60)  // Container size
                            
                            Image(systemName: "person.2.fill")  // System icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)  // Image size
                                .foregroundColor(.black)  // Image color
                        }
                        Text(viewModel.followerCountString)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .lineLimit(1)
                        Text("Follower")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .lineLimit(1)
                    }
                    VStack (spacing: 4){
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.gray.opacity(0.2))  // Background color
                                .frame(width: 60, height: 60)  // Container size
                            
                            Image(systemName: "trophy.fill")  // System icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)// Image size
                                .foregroundColor(.black)  // Image color
                        }
                        Text(viewModel.followingCountString)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .lineLimit(1)
                        Text("Following")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .lineLimit(1)
                    }
                }.padding(.top, 20)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Blog")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .lineLimit(1)
                        Text(viewModel.blog)
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .lineLimit(0)
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                Spacer()
            }
                
        }
        .task {
            await viewModel.fetchUserInfo()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
