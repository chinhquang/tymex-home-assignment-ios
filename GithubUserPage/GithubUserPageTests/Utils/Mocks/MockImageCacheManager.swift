//
//  GithubUserPageTests.swift
//  GithubUserPageTests
//
//  Created by chinh on 1/9/25.
//

import XCTest
import Combine
@testable import GithubUserPage

actor MockImageCacheManager: ImageCachable {
    private var mockCache: [String: UIImage] = [:]
    
    func getImage(forKey key: String) async -> UIImage? {
        return mockCache[key]
    }
    
    func setImage(_ image: UIImage, forKey key: String) async {
        mockCache[key] = image
    }
}
