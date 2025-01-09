//
//  UserViewModel.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//
import Foundation

final class UserViewModel: Identifiable {

    let id: Int
    let loginUsername: String
    let avatarURL: URL?
    let landingPageURL: URL?
    let landingPageURLAttributedString: AttributedString?

    init(from userResponse: UserResponse) {
        self.id = userResponse.id
        self.loginUsername = userResponse.login
        self.avatarURL = URL(string: userResponse.avatarUrl)
        self.landingPageURL = URL(string: userResponse.htmlUrl)
        var attributedString = AttributedString(userResponse.htmlUrl)
        attributedString.link = URL(string: userResponse.htmlUrl) // Apply link
        self.landingPageURLAttributedString = attributedString
    }
}
