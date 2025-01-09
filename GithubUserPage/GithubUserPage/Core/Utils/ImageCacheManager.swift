//
//  ImageCacheManager.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//

import SwiftUI

protocol ImageCachable {

    func getImage(forKey key: String) async -> UIImage?
    func setImage(_ image: UIImage, forKey key: String) async
}

actor ImageCacheManager: ImageCachable {
    static let shared = ImageCacheManager()

    private var cache = NSCache<NSString, UIImage>()
    
    private init() {}

    func getImage(forKey key: String) async -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, forKey key: String) async {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
