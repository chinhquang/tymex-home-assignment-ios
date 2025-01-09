//
//  ImageDownloader.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//
import SwiftUI

protocol ImageDownloaderProtocol {
    var image: Image? { get set }
    var isLoading: Bool { get set }
    func loadImage() async
}


final class ImageDownloader: ImageDownloaderProtocol, ObservableObject {
    
    @Published var image: Image? = nil
    
    @Published var isLoading: Bool = true
    
    private let url: URL
    
    private let uuid: String
    
    private let cacheManager: ImageCachable
    
    private let urlSession: URLSession
    
    init(url: URL,
         uuid: String,
         cacheManager: ImageCachable = ImageCacheManager.shared,
         urlSession: URLSession = URLSession.shared) {
        self.url = url
        self.uuid = uuid
        self.cacheManager = cacheManager
        self.urlSession = urlSession
    }

    func loadImage() async {
        // Check the cache first
        let cachedImage = await cacheManager.getImage(forKey: uuid)
        if let cachedImage {
            await self.setImage(uiImage: cachedImage)
            return
        }
        
        // If not cached, fetch the image from the network
        Task {
            do {
                let (data, _) = try await urlSession.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await setImage(uiImage: uiImage)
                    await cacheManager.setImage(uiImage, forKey: uuid) // Cache the image
                } else {
                    await setLoadingState(isLoading: false)
                }
            } catch {
                await setLoadingState(isLoading: false)
                
            }
        }
    }
    
    @MainActor
    private func setImage(uiImage: UIImage) {
        self.image = Image(uiImage: uiImage)
        self.isLoading = false
    }
    
    @MainActor
    private func setLoadingState(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
